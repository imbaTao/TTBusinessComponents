//
//  TTAuthCodeInputBarInputItem.swift
//  TTBusinessComponents
//
//  Created by 　hong on 2023/1/28.
//

import Foundation
import TTUIKit
import RxRelay

open class TTAuthCodeInputBarInputItem: TTControll {
   public enum InputState {
        case inputing  // 输入中
        case complte  // 输入完成
        case unInput  // 还未输入
    }
    
    // state
    public let stateRelay = BehaviorRelay<InputState>.init(value: .unInput)
    public let inputTF = TTTextFiled.init { config in
        config.caretColor = .black
        config.textFont = .bold(30)
        config.textColor = .black
        config.contentEdges = .init(top: 8, left: 0, bottom: 0, right: 0)
        config.maxTextCount = 1
        config.filter = .onlyNumber
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
//        stateRelay.map { $0 != .unInput }.bind(to: backGroundImageView.rx.isHidden).disposed(
//            by: rx.disposeBag)
        stateRelay.map { $0 == .inputing }.bind(to: inputTF.rx.isUserInteractionEnabled).disposed(
            by: rx.disposeBag)
        
        stateRelay.subscribe(onNext: { [weak self] (state) in guard let self = self else { return }
            switch state {
            case .inputing:
                self.backgroundColor = rgba(250, 250, 250, 1)
                self.inputTF.becomeFirstResponder()
            case .complte:
                self.layer.shadowOpacity = 0
                self.backgroundColor = rgba(250, 250, 250, 1)
                self.resignFirstResponder()
            case .unInput:
                self.layer.shadowOpacity = 0
                self.resignFirstResponder()
            default:
                break
            }
        }).disposed(by: rx.disposeBag)
        
        
        // 监听文字变更
        inputTF.rx.text.filter({$0?.int != nil}).subscribe(onNext: {[weak self] (_) in guard let self = self else { return }
            self.stateRelay.accept(.complte)
        }).disposed(by: rx.disposeBag)
    }
    
    
    public func changeState(_ state: InputState) {
        stateRelay.accept(state)
    }
}


 
