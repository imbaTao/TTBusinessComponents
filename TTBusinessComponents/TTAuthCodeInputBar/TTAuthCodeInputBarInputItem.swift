//
//  TTAuthCodeInputBarInputItem.swift
//  TTBusinessComponents
//
//  Created by 　hong on 2023/1/28.
//

import Foundation
import TTUIKit
import RxRelay

// 控件功能需求
/**
 1.适用场景，验证码，授权码输入
 2.输入一个弹到下一个输入框格子
 3.点击格子开始输入,只可以输入当前格子或者下一个格子(可不做限制)
 4.状态变更可以不用rx去做
 */

open class TTAuthCodeInputBarInputItem: TTControll {
    public enum InputState: Equatable {
        case inputing  // 输入中
        case complte  // 输入完成
        case freeze // 输入完成后外部冻结
        case unInput  // 还未输入
    }
    
    // 状态变更
    public var inputStateDidChange: ((InputState) -> ())? = nil
    private var inputState: InputState = .unInput {
        didSet {
//           if inputState != oldValue {
                didChangeState(inputState)
                inputStateDidChange?(inputState)
//            }
        }
    }

    public let inputTF = TTTextInput.init { config in
        config.caretColor = .black
        config.textFont = .bold(30)
        config.textColor = .black
        config.padding = .init(top: 8, left: 0, bottom: 0, right: 0)
        config.maxTextCount = 1
        config.filter = .onlyNumber
    }
    
    public private(set) var index = 0
    public required init(_ index: Int) {
        super.init(frame: .zero)
        self.index = index
    }
    

    open override func setupUI() {
        super.setupUI()
        addSubviews([inputTF])

        inputTF.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 42, height: 52))
        }

        // config
        addBorder(color: rgba(197, 198, 201, 0.53), width: .halfAPixel)
        inputTF.keyboardType = .numberPad
        inputTF.textAlignment = .center
        cornerRadius = 4
        inputTF.backgroundColor = .clear
    }

    open override func setupEvents() {
        super.setupEvents()
        
        // 监听文字变更
        inputTF.rx.text.filterNil().subscribe(onNext: {[weak self] (text) in guard let self = self,text.count > 0 else { return }
            self.changeState(.complte)
        }).disposed(by: rx.disposeBag)
    }
    
    open func didChangeState(_ state: InputState) {
        switch state {
        case .inputing:
            self.isUserInteractionEnabled = true
            self.backgroundColor = rgba(250, 250, 250, 1)
            self.inputTF.becomeFirstResponder()
        case .complte:
            self.layer.shadowOpacity = 0
            self.backgroundColor = rgba(250, 250, 250, 1)
        case .unInput:
            self.layer.shadowOpacity = 0
            self.inputTF.text = ""
            self.inputTF.resignFirstResponder()
        case .freeze:
            self.isUserInteractionEnabled = false
            self.inputTF.resignFirstResponder()
            break
        }
    }
    
    public func changeState(_ state: InputState) {
        inputState = state
    }
    
    public func resetContent() {
        inputTF.text = ""
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
