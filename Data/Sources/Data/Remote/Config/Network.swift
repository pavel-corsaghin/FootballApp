//
//  Network.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import Foundation
import Combine

typealias RequestModifier = ((URLRequest) -> URLRequest)

final class Network<Response: Decodable> {

    private var urlSession: URLSession { URLSession.shared }
    
    func request(
        _ endpoint: EndpointConvertible,
        requestModifier: @escaping RequestModifier = { $0 },
        preferedSuccessStatusCode: HttpStatus = .success
    ) -> AnyPublisher<Response, Error> {
        guard let _request = endpoint.request else {
            return Result.Publisher(.failure(NetworkError.invalidRequest)).eraseToAnyPublisher()
        }

        let request = requestModifier(_request)
        NetworkLogger.log(request: request)
        return urlSession
            .dataTaskPublisher(for: request)
            .handleEvents(
                receiveOutput: { data, response in
                    NetworkLogger.log(request: request, data: data, response: response, error: nil)
                },
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        NetworkLogger.log(request: request, data: nil, response: nil, error: error)
                    }
                }
            )
            .tryMap { data, response -> Data in
                guard let res = response as? HTTPURLResponse,
                      let statusCode = HttpStatus(rawValue: res.statusCode)
                else {
                    throw NetworkError.invalidResponse
                }
                
                guard statusCode == preferedSuccessStatusCode else {
                    // TODO: try to decode data for detail error message from server
                    let errorMessage = "Server error"
                    throw NetworkError.server(.init(status: statusCode, message: errorMessage))
                }
                
                return data
            }
            .decode(type: Response.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if let networkError = error as? NetworkError {
                    return networkError
                }
                
                return NetworkError.custom(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
