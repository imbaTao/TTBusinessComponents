//
//  TTNormalBussinessStaticRow.swift
//  TTTemplate_Example
//
//  Created by 　hong on 2023/2/21.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import TTUIKit
import RxSwift
import RxCocoa
import RxRelay

// 常用静态行
open class TTNormalBussinessStaticRow: TTStaticRow {
    let leftStack = TTStackView.horizontalStack(12)
    let rightStack = TTStackView.horizontalStack(12)
    
    open override func setupUI() {
        super.setupUI()
        backgroundColor = .white
        leftStack.addArrangedSubviews([icon,titleLabel])
        rightStack.addArrangedSubviews([subTitleLabel,switchButton,subIcon])
        addSubviews([leftStack,rightStack])
        
        
        // config
        icon.isHidden = true
        icon.setContentCompressionResistancePriority(.required, for: .horizontal)
        icon.setContentCompressionResistancePriority(.required, for: .vertical)
        icon.setContentHuggingPriority(.required, for: .horizontal)
        icon.setContentHuggingPriority(.required, for: .vertical)
        
        switchButton.isHidden = true
        titleLabel.config(font: .regular(16), textColor: .black, text: "", alignment: .left, numberOfline: 1)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        subTitleLabel.config(font: .regular(15), textColor: .black, text: "", alignment: .right, numberOfline: 1)
        subTitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        subIcon.isHidden = true
        subIcon.setContentCompressionResistancePriority(.required, for: .horizontal)
        subIcon.setContentHuggingPriority(.required, for: .horizontal)
        rowHeight = 54
        
        
        // layout
        leftStack.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.5).offset(12 * 2)
            make.height.equalTo(titleLabel.snp.height)
        }
        
        rightStack.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.5).offset(12 * 2)
            make.height.equalTo(subTitleLabel.snp.height)
        }
    }
}
