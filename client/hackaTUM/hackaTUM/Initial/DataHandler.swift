//
//  DataHandler.swift
//  hackaTUM
//
//  Created by Łukasz Zalewski on 11/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation

struct POI: Codable {
    let id: String
    let title: String
    let description: String
    let lat: Double
    let long: Double
    let ranking: Double
}

enum URLSessionTaskError: Error {
    case noData
    case couldNotDecodeData
    case incorrentUrl
}

class Future<Value> {
    fileprivate var result: Result<Value, Error>? {
        didSet { result.map(report) }
    }
    private lazy var callbacks = [(Result<Value, Error>) -> Void]()
    
    func observe(with callback: @escaping (Result<Value, Error>) -> Void) {
        callbacks.append(callback)
        result.map(callback)
    }
    
    private func report(result: Result<Value, Error>) {
        for callback in callbacks {
            callback(result)
        }
    }
}

class Promise<Value>: Future<Value> {
    init(value: Value? = nil) {
        super.init()
        result = value.map({ .success($0) })
    }
    
    func resolve(with value: Value) {
        result = .success(value)
    }
    
    func reject(with error: Error) {
        result = .failure(error)
    }
}

// Caseless enum to avoid instantiation
enum DataHandler {
    static func getAllPOI(in radius: Int, long: Double, lat: Double) -> Future<[POI]> {
        let session = URLSession(configuration: .default)
        let promise = Promise<[POI]>()
        guard let url = URL(string: "http://131.159.210.130:3000/api/poi/\(radius)") else {
            log.error("Incorrect url")
            promise.reject(with: URLSessionTaskError.incorrentUrl)
            return promise
        }
        var request = URLRequest(url: url)
        // Set the method
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let dict = [
            "lat": "\(lat)",
            "long": "\(long)"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            request.httpBody = jsonData
        } catch _ {
            log.error("Error during serialization to json")
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                promise.reject(with: URLSessionTaskError.noData)
                return
            }
            
            guard let tasks = try? JSONDecoder().decode([POI].self, from: data) else {
                promise.reject(with: URLSessionTaskError.couldNotDecodeData)
                return
            }
            
            promise.resolve(with: tasks)
        }
        
        task.resume()
        return promise
    }
}
