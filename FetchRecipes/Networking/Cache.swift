//
//  Cache.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 9/26/23.
//

import Foundation

final class CacheEntryObject {
    let entry: CacheEntry
    init(entry: CacheEntry) { self.entry = entry }
}

enum CacheEntry {
    case inProgress(Task<MealDetails, Error>)
    case ready(MealDetails)
}

extension NSCache where KeyType == NSString, ObjectType == CacheEntryObject {
    subscript(_ id: String) -> CacheEntry? {
        get {
            let key = id as NSString
            let value = object(forKey: key)
            return value?.entry
        }
        set {
            let key = id as NSString
            if let entry = newValue {
                let value = CacheEntryObject(entry: entry)
                setObject(value, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
}
