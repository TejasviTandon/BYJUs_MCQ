//
//  ViewModel.swift
//  MCQs
//
//  Created by Tejasvi Tandon on 13/02/22.
//

import Foundation
import RxSwift
import RxCocoa
import Foundation
import RealmSwift

protocol ViewModelInput {
    func loadData()
}

protocol ViewModelOutput {
    var mcqDatasource: BehaviorRelay<[Question]> { get }
    var error: BehaviorRelay<ViewModelError?> { get }
}

protocol ViewModelProtocol: ViewModelInput & ViewModelOutput {}

class ViewModel: ViewModelProtocol {
    
    var mcqDatasource: BehaviorRelay<[Question]> = BehaviorRelay<[Question]>(value: [])
    var error: BehaviorRelay<ViewModelError?> = BehaviorRelay<ViewModelError?>(value: nil)
    var currentItem = 0
    var isFirstQuestion = BehaviorRelay<Bool>(value: true)
    var isLastQuestion = BehaviorRelay<Bool>(value: false)
    var timeRemaining = BehaviorRelay<String>(value: "")
    var testSubmitted = BehaviorRelay<Bool>(value: false)
    
    private let questionAPI: QuestionsAPI
    private let disposeBag = DisposeBag()
    
    private var seconds = 0
    private var timer = Timer()
    
    init(questionAPI: QuestionsAPI) {
        self.questionAPI = questionAPI
    }
    
    func loadData() {
        questionAPI.getQuestions().asObservable().subscribe { [weak self] questionsDto in
            guard let self = self else { return }
            let mcqs = questionsDto.questions.filter { question in
                let questionType = QuestionType(rawValue: question.type)
                return questionType == .mcq
            }
            self.mcqDatasource.accept(mcqs)
            self.seconds = questionsDto.duration * 60
            self.runTimer()
        } onError: { [weak self] error in
            guard let self = self else { return }
            self.error.accept(ViewModelError.couldNotLoadData)
        }.disposed(by: disposeBag)
        
    }
    
    //MARK: - Actions
    func previous() {
        currentItem -= 1
        isLastQuestion.accept(false)
        if currentItem == 0 {
            isFirstQuestion.accept(true)
        }
    }
    
    func next() {
        currentItem += 1
        isFirstQuestion.accept(false)
        if currentItem == mcqDatasource.value.count - 1 {
            isLastQuestion.accept(true)
        }
    }
    
    func submitTest() {
        timer.invalidate()
        testSubmitted.accept(true)
    }
    
    
    //MARK: - Timer
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        seconds -= 1
        let time = secondsToHoursMinutesSeconds()
        let timeString = "\(time.0): \(time.1): \(time.2)"
        self.timeRemaining.accept(timeString)
        if seconds <= 0 {
            submitTest()
        }
    }
    
    private func secondsToHoursMinutesSeconds() -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}
