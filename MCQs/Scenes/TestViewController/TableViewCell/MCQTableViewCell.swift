//
//  MCQTableViewCell.swift
//  MCQs
//
//  Created by Tejasvi Tandon on 10/02/22.
//

import UIKit
import RxSwift

class MCQTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var katexWebView: KatexMathView!
    @IBOutlet weak var katexHeightConstraint: NSLayoutConstraint!
    
    private var isOptionSelected = false
    private let disposeBag = DisposeBag()
    
    override var isSelected: Bool {
        didSet {
            isOptionSelected = self.isSelected
            setSelected(isOptionSelected)
        }
    }
    
    override func prepareForReuse() {
        isOptionSelected = false
        setSelected(isOptionSelected)
    }
    
    private func setSelected(_ selected: Bool) {
        selectionImageView?.isHighlighted = selected
    }

    func configure(mcOption: String) {
        katexWebView.loadLatex(mcOption)
        katexWebView.webViewHeight.subscribe { height in
            self.katexHeightConstraint.constant = height.element ?? 0
            self.containerView.layoutIfNeeded()
        }.disposed(by: disposeBag)
    }
    
}
