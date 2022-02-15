//
//  ViewModelError.swift
//  MCQs
//
//  Created by Tejasvi Tandon on 15/02/22.
//

import Foundation

enum ViewModelError: LocalizedError {
    case couldNotLoadData
    
    var errorDescription: String? {
        switch self {
        case .couldNotLoadData:
            return "Could not load data from server"
        }
    }
    var failureReason: String? {
        switch self {
        case .couldNotLoadData:
            return "Server Error"
        }
    }
    var recoverySuggestion: String? {
        switch self {
        case .couldNotLoadData:
            return "Please try again later"
        }
    }
}
