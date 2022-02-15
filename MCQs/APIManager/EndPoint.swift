//
//  EndPoint.swift
//  MCQs
//
//  Created by Tejasvi Tandon on 13/02/22.
//

import Alamofire

protocol EndPointType {
    // MARK: - Vars & Lets
    
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
}

enum EndpointItem {
    case mcq
}

// MARK: - EndPointType
extension EndpointItem: EndPointType {
    
    var baseURL: String {
        "https://assessed-da.s3-ap-southeast-1.amazonaws.com"
    }
    
    var path: String {
        switch self {
        case .mcq:
            return "/exam/exam.json"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .mcq:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .mcq:
            return ["Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest"]
        }
    }
    
    var url: URL {
        switch self {
        default:
            return URL(string: self.baseURL + self.path)!
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
}

