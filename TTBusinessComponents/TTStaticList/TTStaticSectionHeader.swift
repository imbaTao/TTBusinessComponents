//
//  TTStaticSectionHeader.swift
//  TTTemplate_Example
//
//  Created by 　hong on 2023/2/21.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import TTUIKit

open class TTStaticSectionHeader: TTView {
//   public lazy var titleLabel: UILabel = {
//        var titleLabel = UILabel.regular(size: 12, textColor: .black, text: "", alignment: .left)
//        addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview().inset(12)
//            make.top.bottom.equalToSuperview()
//        }
//        return titleLabel
//    }()
    
    public var headerHeight: CGFloat = 12 {
        didSet {
            self.changeHeaderHeight(headerHeight)
        }
    }

    init(_ _headerHeight: CGFloat,content: String = "",lableInset: CGFloat = 12) {
        super.init(frame: .zero)
        headerHeight = _headerHeight
//        titleLabel.text = content
        
        
//        changeLableInset(lableInset)
        changeHeaderHeight(headerHeight)
    }
    
    private func changeHeaderHeight(_ height: CGFloat) {
        snp.remakeConstraints { (make) in
            make.height.equalTo(headerHeight)
        }
    }
    
    open override func setupUI() {
        super.setupUI()
        self.backgroundColor = .clear
    }

   public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public extension TTStaticSectionHeader {
//    public func changeLableInset(_ inset: CGFloat) {
//        titleLabel.snp.remakeConstraints { (make) in
//            if #available(iOS 11.0, *) {
//                make.left.right.equalTo(safeAreaLayoutGuide).inset(inset)
//            } else {
//                make.left.right.equalTo(inset)
//            }
//            make.top.bottom.equalToSuperview()
//        }
//    }
}
