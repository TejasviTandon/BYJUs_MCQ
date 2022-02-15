//
//  MCQCollectionViewCell.swift
//  MCQs
//
//  Created by Tejasvi Tandon on 10/02/22.
//

import UIKit
import RxSwift
import RealmSwift

class MCQCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var katexMathView: KatexMathView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var katexViewHeight: NSLayoutConstraint!
    
    private var question: Question!
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: UIScreen.main.bounds.width - 32, height: contentView.frame.height)
        layoutAttributes.frame.size.width = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .required).width
        return layoutAttributes
    }
    
    func configure(with question: Question) {
        self.question = question
        setupQuestionView()
        setupOptionsTableView()
    }
    
    private func setupQuestionView() {
        katexMathView.loadLatex(question.text)
        katexMathView.webViewHeight.subscribe { [weak self] height in
            self?.katexViewHeight.constant = height.element ?? 56
        }.disposed(by: disposeBag)
    }
    
    private func setupOptionsTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        registerTableViewCell()
        tableView.reloadData()
    }
    
    private func registerTableViewCell() {
        tableView.register(UINib(nibName: "MCQTableViewCell", bundle: nil), forCellReuseIdentifier: "MCQTableViewCell")
    }
    
    private func selectedAnswer(option: Int) {
        let realm = try! Realm()
        
        if let already = questionAlreadyAnswered() {
            try! realm.write() {
                already.selectedOption = option
            }
        }else {
            let submission = Submission()
            submission.questionId = question.id
            submission.selectedOption = option
            submission.marks = question.marks
            //Since there is no validation provided for checking the correctness of the answer. I have assumed that all the questions attempted by the user are correct.
            submission.isCorrect = true
            try! realm.write() {
                realm.add(submission)
            }
        }
    }
    
    private func questionAlreadyAnswered() -> Submission? {
        let realm = try! Realm()
        let submissions = realm.objects(Submission.self)
        return submissions.first(where: {$0.questionId == self.question.id})
    }

}

extension MCQCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        question.mcOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "MCQTableViewCell", for: indexPath) as! MCQTableViewCell
        tableViewCell.configure(mcOption: question.mcOptions[indexPath.row])
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MCQTableViewCell
        cell.isSelected = true
        selectedAnswer(option: indexPath.row + 1)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MCQTableViewCell
        cell.isSelected = false
    }
    
}
