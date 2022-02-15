//
//  MCQsAPI.swift
//  MCQs
//
//  Created by Tejasvi Tandon on 14/02/22.
//

import Foundation
import RxSwift

protocol QuestionsAPI {
    func getQuestions() -> Observable<QuestionsDto>
}

extension APIManager: QuestionsAPI {
    func getQuestions() -> Observable<QuestionsDto> {
        return self.get(type: EndpointItem.mcq, params: nil)
    }
    
}
