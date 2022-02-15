//
//  MCQDto.swift
//  MCQs
//
//  Created by Tejasvi Tandon on 15/02/22.
//

import Foundation

struct QuestionsDto: Codable {
    var assessmentId: String
    var assessmentName: String
    var subject: String
    var questions: [Question]
    var duration: Int
    var totalMarks: Int
    
}
