//
//  ServiceHandler.swift
//  Locus
//
//  Created by Sanjeev on 20/02/22.
//

import Foundation

protocol ServiceHandler: AnyObject {
    func serve<T: Decodable>(endpoint: ApiEndpoint) async throws -> T
}

extension ServiceHandler {
    func serve<T: Decodable>(endpoint: ApiEndpoint) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: endpoint.request)
            
            guard let httpResponse = (response as? HTTPURLResponse),
                  httpResponse.statusCode == 200 else {
                      
                      let dict = try JSONSerialization.jsonObject(with: data, options: [])
                      if let error = dict as? [String: Any],
                         let message = error["message"] as? String {
                          throw CustomError.custom(message)
                      }
                      
                      throw CustomError.invalidResponse
                  }
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("error: ", error)
            throw error
        }
    }
}
