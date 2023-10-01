//
//  Endpoint.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 9/25/23.
//

import Foundation

struct Endpoint {
    let baseURL: URL
    let queryParameter: QueryParameter
    let pathOperation: PathOperation
    
    enum EndpointError: AppError {
        case invalidURL(_ path: String)
        
        var id: String {
            switch self {
            case .invalidURL:
                return "EndpointError.invalidURL"
            }
        }
        
        var logDescription: String {
            switch self {
            case .invalidURL(let path):
                return "Could not construct a URL from the given path: \(path)"
            }
        }
        
        var userDescription: String {
            switch self {
            case .invalidURL:
                return String(localized: "Invalid URL", comment: "An error for an invalid URL")
            }
        }
    }
    
    enum QueryParameter {
        case category(value: String)
        case id(value: String)
        
        var name: String {
            switch self {
            case .category:
                return "c"
            case .id:
                return "i"
            }
        }
        
        var queryItems: [URLQueryItem] {
            switch self {
            case .category(let value):
                return [URLQueryItem(name: name, value: value)]
            case .id(let value):
                return [URLQueryItem(name: name, value: value)]
            }
        }
    }
    
    enum PathOperation: String {
        case filter
        case lookup
        
        var path: String {
            return "\(self.rawValue).php"
        }
    }
    
    init(basePath: String, queryParameter: QueryParameter, pathOperation: PathOperation) throws {
        guard let baseURL = URL(string: basePath) else {
            throw EndpointError.invalidURL(basePath)
        }
        
        self.baseURL = baseURL
        self.queryParameter = queryParameter
        self.pathOperation = pathOperation
    }
    
    func getPath() throws -> URL {
        guard let url = URL(string: "\(pathOperation.path)", relativeTo: baseURL) else {
            throw EndpointError.invalidURL("\(baseURL.path)\(pathOperation.path)")
        }
        return url.appending(queryItems: queryParameter.queryItems)
    }
}
