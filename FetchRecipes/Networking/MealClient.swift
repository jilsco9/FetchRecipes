//
//  MealClient.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 9/25/23.
//

import Foundation

// The meals list and the mealDetails both come back from the API
// as "meals: [...]". We can use a generic decodable response to access
// the content of that array.
struct MealClientResponse<T>: Decodable where T: Decodable {
    let meals: [T]
}

// Using an actor for the MealClient to serialize any calls to
// getMealDetails, which can access and update the Meal Detail cache
actor MealClient {
    private let basePath = "https://themealdb.com/api/json/v1/1/"
    
    private let mealCache: NSCache<NSString, CacheEntryObject> = NSCache()
    
    enum MealClientError: AppError {
        case serverError(_ code: Int?)
        case parseError
        
        var id: String {
            switch self {
            case .serverError:
                return "MealClientError.serverError"
            case .parseError:
                return "MealClientError.parseError"
            }
        }
        
        var logDescription: String {
            switch self {
            case .serverError(let code):
                if let code = code {
                    return "Server responded with error code: \(code)"
                } else {
                    return "Unknown server error"
                }
            case .parseError:
                return "Could not parse response data"
            }
        }
        
        var userDescription: String {
            switch self {
            case .serverError(let code):
                if let code = code {
                    return "Server error \(code)"
                } else {
                    return "Server error"
                }
            case .parseError:
                return "Error reading data"
            }
        }
    }
    
    func getMeals(category: String) async throws -> [Meal] {
        let endpoint = try Endpoint(basePath: basePath, queryParameter: .category(value: category), pathOperation: .filter)
        let url = try endpoint.getPath()
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(MealClientResponse<Meal>.self, from: data).meals
    }
    
    func getMealDetails(id: String) async throws -> MealDetails {
        // Access our meal detail cache for the meal ID
        // to determine if the details have previously been
        // fetched.
        if let cached = mealCache[id] {
            switch cached {
            // If we have previously fetched the details,
            // and that fetch is complete, return the cached value
            case .ready(let details):
                return details
            // If we have previously fetched the details,
            // but that task is not complete, wait for the
            // fetch to finish and return the result
            case .inProgress(let task):
                return try await task.value
            }
        }
        
        // If we have not previously initiated a fetch,
        // do so now
        let endpoint = try Endpoint(basePath: basePath, queryParameter: .id(value: id), pathOperation: .lookup)
        let url = try endpoint.getPath()
        
        // Create the task to fetch the details and return a result or an error
        let task = Task<MealDetails, Error> {
            let (data, _) = try await URLSession.shared.data(from: url)
            let details = try JSONDecoder().decode(MealClientResponse<MealDetails>.self, from: data).meals
            // There should be one (and only one)
            // object in the Meal Details array, so we can
            // access it with details.first
            if let mealDetails = details.first {
                return mealDetails
            } else {
                throw MealClientError.parseError
            }
        }
        
        // Cache the in progress task
        mealCache[id] = .inProgress(task)
        do {
            // When the task completes, update the cache
            // with the result
            let details = try await task.value
            mealCache[id] = .ready(details)
            return details
        } catch {
            // If there is an error, clear the cache entry
            // to prepare for a retry
            // and throw the error
            mealCache[id] = nil
            throw error
        }
    }
}
