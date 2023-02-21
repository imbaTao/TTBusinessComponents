//
//  TTStaticListRow.swift
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

public protocol TTStaticRowProtocol where Self: TTStaticRow {
    func asSelf() -> Self
}

public extension TTStaticRowProtocol {
    func asSelf() -> Self {
        return self
    }
}

open class TTStaticRow: TTStackView, TTStaticRowProtocol,TTBussinessBasicComponentsProtocol {
    // 变更行高
    private var _rowHeight: CGFloat = 44.0
    public var rowHeight: CGFloat {
        get {
            return _rowHeight
        }
        
        set {
            _rowHeight = newValue
            contentView.snp.remakeConstraints { (make) in
                make.width.equalTo(CGFloat.screenWidth)
                make.height.equalTo(_rowHeight)
            }
        }
    }

    // 核心内容承载面板
    let contentView = TTControll()
    lazy var backgroundImageView: UIImageView = {
        let view = UIImageView.idle()
        return view
    }()

    public lazy var titleLabel: UILabel = {
        var titleLabel = UILabel.regular(size: 16, textColor: .black0, text: "", alignment: .left)
        return titleLabel
    }()
    
    public lazy var subTitleLabel: UILabel = {
         var subTitleLabel = UILabel.regular()
         return subTitleLabel
     }()
     
     public lazy var icon: UIImageView = {
         var icon = UIImageView.idle()
         return icon
     }()
     
     public lazy var subIcon: UIImageView = {
         var subIcon = UIImageView.idle()
         return subIcon
     }()
     
     public lazy var arrowIcon: UIImageView = {
         var arrowIcon = UIImageView.idle()
         return arrowIcon
     }()
     
     public lazy var avatar: TTAvatar = {
         var avatar = TTAvatar()
         return avatar
     }()
    
    public lazy var segementLine: UIView = {
        let segementLine = UIView.colorView(rgba(223, 223, 223, 0.5))
        return segementLine
    }()
    
    public lazy var switchButton: UISwitch = {
        let switchElement = UISwitch.init(frame: .zero)
//        onTintColor = QColorStyle.green
        return switchElement
    }()
    
    //  核心内容，都用字符串去表示，取值时转换
    public var value: Any = 0 {
        didSet {
            valueChangedNeedRefreshUI?(self,value)
            
            // 传递内容的变更
//            valueContentRelay.accept("\(value)")
        }
    }
    
    // 更新UIBlock
    public var valueChangedNeedRefreshUI: ((TTStaticRow,Any) -> ())? = nil
    
    open override func setupUI() {
        super.setupUI()
        addArrangedSubview(contentView)
        spacing = 0
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    func updateUI() {
        setNeedsDisplay()
    }
    
    open override func addSubview(_ view: UIView) {
        if view == contentView {
            super.addSubview(view)
        }else {
            contentView.addSubview(view)
        }
    }
    
    open override var backgroundColor: UIColor? {
        get {
            self.contentView.backgroundColor
        }
        set {
            self.contentView.backgroundColor = newValue
        }
    }
}


public extension TTStaticRow {
    
    convenience init(_ initializer: ((TTStaticRow) -> Void)? = nil) {
        self.init(frame: .zero)
        initializer?(self)
    }
    
    func updateUI(_ configuaration: ((TTStaticRow) -> Void)?) -> Self {
        configuaration?(self)
        return self
    }

    @discardableResult
    func selection(_ click: ((_ row: TTStaticRow) -> Void)?) -> Self {
        contentView.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            click?(self)
        }).disposed(by: rx.disposeBag)
        return self
    }

    func addHeader(_ header: TTStaticSectionHeader) {
        insertArrangedSubview(header, at: 0)
        header.snp.makeConstraints { (make) in
            make.height.equalTo(header.headerHeight)
        }
    }
    
    func addFooter(_ footer: TTStaticSectionFooter) {
        addArrangedSubview(footer)
        footer.snp.makeConstraints { (make) in
            make.height.equalTo(footer.footerHeight)
        }
    }
    
    func configSegementLine(left: CGFloat = 0,right: CGFloat = 0,bottom: CGFloat = 0,height: CGFloat = 1,color: UIColor) {
        segementLine.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottom)
            make.left.equalTo(left)
            make.right.equalTo(right)
            make.height.equalTo(height)
        }
        
        segementLine.backgroundColor = color
    }
}




// 常用静态行
open class TTNormalBussinessStaticRow: TTStaticRow {
    let leftStack = TTStackView.horizontalStack(12)
    let rightStack = TTStackView.horizontalStack(12)
    
    open override func setupUI() {
        super.setupUI()
        leftStack.addArrangedSubviews([icon,titleLabel])
        rightStack.addArrangedSubviews([subTitleLabel,switchButton,subIcon])
        addSubviews([leftStack,rightStack])
        
        
        // config
        icon.isHidden = true
        icon.setContentCompressionResistancePriority(.required, for: .horizontal)
        icon.setContentHuggingPriority(.required, for: .horizontal)
        
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



//let paddingInterval: CGFloat = 16
//titleLabel.snp.remakeConstraints { (make) in
//    make.centerY.equalToSuperview()
//    if #available(iOS 11.0, *) {
//        make.left.equalTo(safeAreaLayoutGuide).offset(paddingInterval)
//    } else {
//        make.left.equalToSuperview().offset(paddingInterval)
//    }
//
//    make.width.equalTo(100)
//    make.height.equalTo(30)
////            make.right.equalTo(-15)
//}

//        subTitleLabel.snp.remakeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.left.equalTo(titleLabel.snp.right).offset(15)
//            make.right.equalTo(icon.snp.left).offset(-15)
//        }
//
//        icon.snp.remakeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            if #available(iOS 11.0, *) {
//                make.right.equalTo(safeAreaLayoutGuide).offset(-paddingInterval)
//            } else {
//                make.right.equalToSuperview().offset(-paddingInterval)
//            }
//
//        }

//        responseBox.snp.makeConstraints { (make) in
//            make.right.equalTo(0)
//            make.left.right.equalToSuperview()
//            make.top.bottom.equalToSuperview()
//        }
