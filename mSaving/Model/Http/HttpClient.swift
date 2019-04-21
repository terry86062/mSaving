//
//  HTTPClient.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/21.
//  Copyright © 2019 Terry. All rights reserved.
//

import Foundation

protocol MSRequest {
    
    var endPoint: String { get }
    
    var method: String { get }
    
    var headers: [String: String] { get }
    
    var body: Data? { get }
    
}

enum MSHTTPMethod: String {
    
    case POST
    
}

enum Result<T> {
    
    case success(T)
    
    case failure(Error)
    
}

enum MSHTTPClientError: Error {
    
    case transformHTTPURLResponseError
    
    case clientError(Data)
    
    case unexpectedError
    
    case serverError
    
}

class HTTPClient {
    
    static let shared = HTTPClient()
    
    func sendRequest(_ mSRequest: MSRequest,
                     completionHandler: @escaping (Result<Data>) -> Void) {
        
        URLSession.shared.dataTask(with: makeHTTPRequest(mSRequest), completionHandler: { (data, response, error) in
            
            guard error == nil else {
                
                return completionHandler(Result.failure(error!))
                
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                
                return completionHandler(Result.failure(MSHTTPClientError.transformHTTPURLResponseError))
                
            }
            
            let statusCode = httpResponse.statusCode
            
            print(statusCode)
            
            switch statusCode {
                
            case 200..<300:
                
                completionHandler(Result.success(data!))
                
            case 400..<500:
                
                completionHandler(Result.failure(MSHTTPClientError.clientError(data!)))
                
            case 500..<600:
                
                completionHandler(Result.failure(MSHTTPClientError.serverError))
                
            default:
                
                completionHandler(Result.failure(MSHTTPClientError.unexpectedError))
                
            }
            
        }).resume()
        
    }
    
    private func makeHTTPRequest(_ mSRequest: MSRequest) -> URLRequest {
        
        var request = URLRequest(url: makeURL(endPoint: mSRequest.endPoint))
        
        request.httpMethod = mSRequest.method
        
        request.allHTTPHeaderFields = mSRequest.headers
        
        request.httpBody = mSRequest.body
        
        return request
        
    }
    
    private func makeURL(endPoint: String) -> URL {
        
        let hostName = "https://api.einvoice.nat.gov.tw/"
        
        return URL(string: hostName + endPoint)!
        
    }
    
}
