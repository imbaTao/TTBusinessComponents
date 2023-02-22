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

//public protocol TTStaticRowProtocol {
//    associatedtype RowType: TTStaticRow
//    var toSelf: RowType {get}
//}
//
//public extension TTStaticRowProtocol {
//    var toSelf: RowType {
//        return self
//    }
//}
//

open class TTStaticRow: TTStackView,TTBussinessBasicComponentsProtocol {
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


    public lazy var switchButton: UISwitch = {
        let switchElement = UISwitch.init(frame: .zero)
//        switchElement.onTintColor = .red
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
