//
//  WebService.swift
//  HotCoffee
//
//  Created by MAC on 05/04/2021.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

enum HttpMethods: String {
    case get = "GET"
    case post = "POST"
    
}

struct Resource<T: Codable> {
    let url : URL
    var httpMethod: HttpMethods = .get
    var body: Data? = nil
    
    init(url: URL) {
        self.url = url
    }
}

class WebServices {
    //Create a function load of generic type T from the Resource Strucr
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) { // The Result<T, NetworkError> is available in Swift 5 the first param is the response when successful and the second param is the response when their is an Error.
        
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {// If request was not successful we fire the error failure completion handler
                completion(.failure(.domainError))
                return
            }
            
            let result = try? JSONDecoder().decode(T.self, from: data) // Try decode the data when the response is successful
            if let result = result {
                DispatchQueue.main.async {// when successful, you fire the success completion handler on the main tread because you are passing the result data to the UI
                    completion(.success(result))
                }
            }else{
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
