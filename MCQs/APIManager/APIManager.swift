//
//  APIManager.swift
//  MCQs
//
//  Created by Tejasvi Tandon on 14/02/22.
//

import Foundation
import Alamofire
import RxSwift

class APIManager {
    
    // MARK: - Vars & Lets
    
    private let sessionManager: Session
    
    // MARK: - Vars & Lets
    
    private static var sharedApiManager: APIManager = {
        let apiManager = APIManager(sessionManager: Session())
        
        return apiManager
    }()
    
    // MARK: - Accessors
    
    class func shared() -> APIManager {
        return sharedApiManager
    }
    
    // MARK: - Initialization
    
    private init(sessionManager: Session) {
        self.sessionManager = sessionManager
    }
//    func get<T>(type: EndPointType, params: Parameters? = nil, handler: @escaping (T?, _ error: Error?)->()) -> Observable<T> where T: Codable {
    func get<T>(type: EndPointType, params: Parameters? = nil) -> Observable<T> where T: Codable {
        
        return Observable<T>.create({
            (observer) -> Disposable in
            
            let request = self.sessionManager.request(type.url,
                                                      method: type.httpMethod,
                                                      parameters: params,
                                                      encoding: type.encoding,
                                                      headers: type.headers)
            request.validate().responseJSON { data in
                switch data.result {
                case .success(_):
                    if let jsonData = data.data {
                        let decoder = JSONDecoder()
                        let result = try! decoder.decode(T.self, from: jsonData)
                        observer.onNext(result)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create(with: {
                request.cancel()
            })
        })
    }
    
}
