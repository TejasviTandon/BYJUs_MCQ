//
//  ViewController.swift
//  MCQs
//
//  Created by Tejasvi Tandon on 10/02/22.
//

import UIKit
import RxSwift
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var previousOutlet: UIButton!
    @IBOutlet weak var nextOutlet: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var submitTestOutlet: UIButton!
    
    private var viewModel: ViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModel(questionAPI: APIManager.shared())
        registerCollectionViewCell()
        bindCollectionView()
        viewModel.loadData()
        bindActions()
        bindTimer()
        bindTestSubmission()
    }
    
    //MARK: - UI Set up
    private func registerCollectionViewCell() {
        collectionView.register(UINib(nibName: "MCQCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MCQCollectionViewCell")
    }
    
    private func bindCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.mcqDatasource.bind(to: collectionView.rx.items(cellIdentifier: "MCQCollectionViewCell", cellType: MCQCollectionViewCell.self)) { (row, item, cell) in
            cell.configure(with: item)
        }.disposed(by: disposeBag)
        
    }
    
    private func bindTimer() {
        viewModel.timeRemaining.map({$0}).bind(to: timerLabel.rx.text).disposed(by: disposeBag)
    }
    
    
    //MARK: - Actions
    @IBAction func previousAction(_ sender: Any) {
        viewModel.previous()
        collectionView.scrollToItem(at: IndexPath(item: viewModel.currentItem, section: 0), at: .left, animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        viewModel.next()
        collectionView.scrollToItem(at: IndexPath(item: viewModel.currentItem, section: 0), at: .right, animated: true)
    }
    
    private func bindActions() {
        viewModel.isFirstQuestion.distinctUntilChanged().subscribe { value in
            if value.element == true {
                self.previousOutlet.alpha = 0.5
                self.previousOutlet.isUserInteractionEnabled = false
            }else {
                self.previousOutlet.alpha = 1.0
                self.previousOutlet.isUserInteractionEnabled = true
                
            }
        }.disposed(by: disposeBag)
        
        viewModel.isLastQuestion.asObservable().distinctUntilChanged().subscribe { value in
            if value.element == true {
                self.nextOutlet.alpha = 0.5
                self.nextOutlet.isUserInteractionEnabled = false
                
                let realm = try! Realm()
                print(realm.objects(Submission.self))
            }else {
                self.nextOutlet.alpha = 1.0
                self.nextOutlet.isUserInteractionEnabled = true
                
            }
        }.disposed(by: disposeBag)
        
    }
    
    private func bindTestSubmission() {
        submitTestOutlet.rx.tap.bind { [weak self] in
            self?.showAlert(withTitle: "Are you Sure You want to submit the test ?", message: "This action can not be changed.", okayButtonAction: "Yes", andCancelButton: "No", completion: { yes in
                if yes {
                    self?.viewModel.submitTest()
                }
            })
        }.disposed(by: disposeBag)
        
        viewModel.testSubmitted
            .subscribe { [weak self] value in
                if value.element == true {
                    let resultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
                    resultsViewController.viewModel = ResultsViewModel()
                    resultsViewController.modalPresentationStyle = .fullScreen
                    self?.present(resultsViewController, animated: true, completion: nil)
                }
            }.disposed(by: disposeBag)
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 32
        let height = collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
}

