//
//  TTStaticSectionFooter.swift
//  TTTemplate_Example
//
//  Created by 　hong on 2023/2/21.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import TTUIKit

open class TTStaticSectionFooter: TTView {
//    lazy var titleLabel: UILabel = {
//        var titleLabel = UILabel.regular(size: 12, textColor: .black, text: "组标题", alignment: .left)
//        addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { (make) in
//            if #available(iOS 11.0, *) {
//                make.left.right.equalTo(self.safeAreaLayoutGuide).offset(12)
//            } else {
//                make.left.right.equalToSuperview().inset(12)
//            }
//            make.top.bottom.equalToSuperview()
//        }
//        return titleLabel
//    }()
    
    open override func setupUI() {
        super.setupUI()
        self.backgroundColor = .clear
    }

    var footerHeight: CGFloat = 10.0 {
        didSet {
            self.snp.remakeConstraints { (make) in
                make.width.equalTo(CGFloat.screenWidth)
                make.height.equalTo(footerHeight)
            }
        }
    }
    
//    func changeLableInset(_ inset: CGFloat) {
//        titleLabel.snp.remakeConstraints { (make) in
//            if #available(iOS 11.0, *) {
//                make.left.right.equalTo(self.safeAreaLayoutGuide).inset(inset)
//            } else {
//                make.left.right.equalToSuperview().inset(inset)
//            }
//            make.top.bottom.equalToSuperview()
//        }
//    }
}
