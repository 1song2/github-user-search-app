//
//  CoreDataStarredUsersStorage.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/29.
//

import Foundation
import CoreData

final class CoreDataStarredUsersStorage {
    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
}

extension CoreDataStarredUsersStorage: StarredUsersStorage {
    func getStarredUsers(completion: @escaping (Result<[User], CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = StarredUserEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: #keyPath(StarredUserEntity.username),
                                                            ascending: true)]
                let result = try context.fetch(request).map { $0.toDomain() }
                completion(.success(result))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }

    func save(_ item: UserViewModel) {
        coreDataStorage.performBackgroundTask { context in
            do {
                _ = StarredUserEntity(item: item, insertInto: context)
                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataStarredUsersStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
    
    func remove(_ item: UserViewModel) {
        coreDataStorage.performBackgroundTask { context in
            let request: NSFetchRequest<StarredUserEntity> = StarredUserEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id = %d", item.id)
            do {
                let objects = try context.fetch(request)
                for object in objects {
                    context.delete(object)
                }
                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataStarredUsersStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
