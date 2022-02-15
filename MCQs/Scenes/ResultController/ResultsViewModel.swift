//
//  ResultsViewModel.swift
//  MCQs
//
//  Created by Tejasvi Tandon on 15/02/22.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class ResultsViewModel {
    var questionsAttemped = BehaviorRelay<String>(value: "")
    var marksObtained = BehaviorRelay<String>(value: "")

    private let disposeBag = DisposeBag()
    
    func loadResults() {
        let realm = try! Realm()
        let submissions = realm.objects(Submission.self)
        
        let questionsAttempted = submissions.count
        self.questionsAttemped.accept("\(questionsAttempted)")
        
        let marksObtained = submissions.filter({$0.isCorrect}).reduce(0, {$0 + $1.marks})
        self.marksObtained.accept("\(marksObtained)")

    }
}
