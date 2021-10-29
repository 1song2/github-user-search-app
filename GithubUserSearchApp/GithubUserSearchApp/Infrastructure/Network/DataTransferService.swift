//
//  DataTransferService.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/24.
//

import Foundation

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

protocol DataTransferService {
    typealias CompletionHandler<T> = (Result<T, DataTransferError>) -> Void
    
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E,
                                                       completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T
}

protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

final class DefaultDataTransferService {
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    
    init(with networkService: NetworkService,
         errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver()) {
        self.networkService = networkService
        self.errorResolver = errorResolver
    }
}

extension DefaultDataTransferService: DataTransferService {
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E,
                                                       completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T {
        return self.networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, DataTransferError> = self.decode(data: data, decoder: endpoint.responseDecoder)
                return completion(result)
            case .failure(let error):
                printIfDebug("\(error)")
                let error = self.resolve(networkError: error)
                return completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private
    
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, DataTransferError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            printIfDebug("\(error)")
            return .failure(.parsing(error))
        }
    }
    
    private func parseLinks(_ links: String) throws -> [String: String] {
        let parseLinksPattern = "\\s*,?\\s*<([^\\>]*)>\\s*;\\s*rel=\"([^\"]*)\""
        let linksRegex = try! NSRegularExpression(pattern: parseLinksPattern, options: [.allowCommentsAndWhitespace])
        let length = (links as NSString).length
        let matches = linksRegex.matches(in: links,
                                         options: NSRegularExpression.MatchingOptions(),
                                         range: NSRange(location: 0, length: length))
        var result: [String: String] = [:]

        for m in matches {
            let matches = (1..<m.numberOfRanges).map { rangeIndex -> String in
                let range = m.range(at: rangeIndex)
                let startIndex = links.index(links.startIndex, offsetBy: range.location)
                let endIndex = links.index(links.startIndex, offsetBy: range.location + range.length)
                return String(links[startIndex ..< endIndex])
            }
            if matches.count != 2 { throw DataTransferError.noResponse }
            result[matches[1]] = matches[0]
        }
        return result
    }
    
    private func parseNextURL(_ httpResponse: HTTPURLResponse) throws -> String? {
        guard let serializedLinks = httpResponse.allHeaderFields["Link"] as? String else {
            return nil
        }
        let links = try parseLinks(serializedLinks)
        guard let nextPageURL = links["next"] else { return nil }
        return nextPageURL
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
    }
}

// MARK: - Error Resolver

class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error {
        return error
    }
}

// MARK: - Response Decoders

class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}

class RawDataResponseDecoder: ResponseDecoder {
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    func decode<T: Decodable>(_ data: Data) throws -> T {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(codingPath: [CodingKeys.default], debugDescription: "Expected Data type")
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}
