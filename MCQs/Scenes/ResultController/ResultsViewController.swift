//
//  ResultsViewController.swift
//  MCQs
//
//  Created by Tejasvi Tandon on 15/02/22.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

class ResultsViewController: UIViewController {

    @IBOutlet weak var questionsAttemptedLabel: UILabel!
    @IBOutlet weak var marksObtainedLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    
    var viewModel: ResultsViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadResults()
        bindLabels()
        animationView.loopMode = .playOnce
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play(completion: nil)
    }
    private func bindLabels() {
        viewModel.questionsAttemped.map({$0}).bind(to: questionsAttemptedLabel.rx.text).disposed(by: disposeBag)
        viewModel.marksObtained.map({$0}).bind(to: marksObtainedLabel.rx.text).disposed(by: disposeBag)
    }
    
}
