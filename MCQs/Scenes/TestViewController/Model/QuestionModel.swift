//
//  QuestionModel.swift
//  MCQs
//
//  Created by Tejasvi Tandon on 15/02/22.
//

import Foundation

struct Question: Codable {
    var id: String
    var qno: Int
    var text: String
    var mcOptions:[String]
    var type: String
    var marks: Int
}
