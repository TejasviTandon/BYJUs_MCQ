//
//  DatabaseManager.swift
//  MCQs
//
//  Created by Tejasvi Tandon on 15/02/22.
//

import Foundation
import RealmSwift

class Submission: Object {
    @objc dynamic var questionId = ""
    @objc dynamic var selectedOption = 0
    @objc dynamic var marks = 0
    @objc dynamic var isCorrect = false
}
