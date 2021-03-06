//
//  NetworkServiceTests.swift
//  GithubUserSearchAppTests
//
//  Created by Song on 2021/10/24.
//

import XCTest

class NetworkServiceTests: XCTestCase {    
    func test_whenMockDataPassed_shouldReturnProperResponse() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return correct data")
        
        let expectedResponseData = "Response data".data(using: .utf8)!
        let sut = DefaultNetworkService(config: config,
                                        sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                  data: expectedResponseData,
                                                                                  error: nil))
        //when
        _ = sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get)) { result in
            guard let responseData = try? result.get() else {
                XCTFail("Should return proper response")
                return
            }
            XCTAssertEqual(responseData.data, expectedResponseData)
            expectation.fulfill()
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenErrorWithNSURLErrorCancelledReturned_shouldReturnCancelledError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return hasStatusCode error")
        
        let cancelledError = NSError(domain: "network", code: NSURLErrorCancelled, userInfo: nil)
        let sut = DefaultNetworkService(config: config,
                                        sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                  data: nil,
                                                                                  error: cancelledError as Error))
        //when
        _ = sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                guard case NetworkError.cancelled = error else {
                    XCTFail("NetworkError.cancelled not found")
                    return
                }
                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenMalformedUrlPassed_shouldReturnUrlGenerationError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return correct data")
        
        let expectedResponseData = "Response data".data(using: .utf8)!
        let sut = DefaultNetworkService(config: config,
                                        sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                  data: expectedResponseData,
                                                                                  error: nil))
        //when
        _ = sut.request(endpoint: EndpointMock(path: "-;@,?:??", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should throw url generation error")
            } catch let error {
                guard case NetworkError.urlGeneration = error else {
                    XCTFail("Should throw url generation error")
                    return
                }
                
                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenStatusCodeEqualOrAbove400_shouldReturnhasStatusCodeError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return hasStatusCode error")
        
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 500,
                                       httpVersion: "1.1",
                                       headerFields: [:])
        let sut = DefaultNetworkService(config: config,
                                        sessionManager: NetworkSessionManagerMock(response: response,
                                                                                  data: nil,
                                                                                  error: NetworkErrorMock.someError))
        //when
        _ = sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                if case NetworkError.error(let statusCode, _) = error {
                    XCTAssertEqual(statusCode, 500)
                    expectation.fulfill()
                }
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenErrorWithNSURLErrorNotConnectedToInternetReturned_shouldReturnNotConnectedError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return hasStatusCode error")
        
        let error = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let sut = DefaultNetworkService(config: config,
                                        sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                  data: nil,
                                                                                  error: error as Error))
        //when
        _ = sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                guard case NetworkError.notConnected = error else {
                    XCTFail("NetworkError.notConnected not found")
                    return
                }
                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenhasStatusCodeUsedWithWrongError_shouldReturnFalse() {
        //when
        let sut = NetworkError.notConnected
        //then
        XCTAssertFalse(sut.hasStatusCode(200))
    }
    
    func test_whenhasStatusCodeUsed_shouldReturnCorrectStatusCode_() {
        //when
        let sut = NetworkError.error(statusCode: 400, data: nil)
        //then
        XCTAssertTrue(sut.hasStatusCode(400))
        XCTAssertFalse(sut.hasStatusCode(399))
        XCTAssertFalse(sut.hasStatusCode(401))
    }
}
