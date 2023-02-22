//
//  TTBusinessComponents.swift
//  TTBusinessComponents
//
//  Created by hong on 2023/1/7.

import Foundation
import TTUIKit
import RxSwift
import RxCocoa

open class TTAuthCodeInputBar<T: TTAuthCodeInputBarInputItem>: TTStackView {
    
    /// 汇总多个textField
    public var content: String {
        var str = ""
        for item in arrangedSubviews {
            if let item = item as? TTAuthCodeInputBarInputItem {
                str += item.inputTF.text ?? ""
            }
        }
        return str
    }
    
    // complete
    public var inputComplete: ((String) -> ())? = nil
    
    public init(inputItemCount: Int) {
        super.init(frame: .zero)
        createItems(inputItemCount: inputItemCount)
        
    }
    
    open override func setupUI() {
        super.setupUI()
        axis = .horizontal
    }

    func createItems(inputItemCount: Int) {
        for index in 0..<inputItemCount {
            let item = T(index)
            
            // stateChanged
            item.inputStateDidChange = { [weak self] inputState in guard let self = self else { return }
                switch inputState {
                case .complte:
                    self.switchNextInputItem(item)
                default:
                    break
                }
            }
    
            // deleteButton
            item.inputTF.rx.sentMessage(#selector(UIKeyInput.deleteBackward)).subscribe(onNext: {
                    [weak self] (_) in guard let self = self else { return }
                self.switchLastInputItem()
            }).disposed(by: rx.disposeBag)
            
            item.backgroundColor = .random
            addArrangedSubview(item)
        }
    }

    func fetchCurrentInputItem() -> TTAuthCodeInputBarInputItem? {
         let currentItem = arrangedSubviews.first(where: { subView in
            if let subView = subView as? TTAuthCodeInputBarInputItem {
                return subView.inputTF.isFirstResponder
            }
            return false
        }) as? TTAuthCodeInputBarInputItem
        return currentItem
    }
    
    // 切换下一个
    func switchNextInputItem(_ beforeItem: TTAuthCodeInputBarInputItem) {
        guard let currentItem = fetchCurrentInputItem() else {
            return
        }
        
        // isLastItem
        if beforeItem.index == arrangedSubviews.maxIndex {
            // 输入完成
            inputComplete?(content)
        }else {
            currentItem.changeState(.freeze)
            let nextItem = arrangedSubviews[currentItem.index + 1] as! TTAuthCodeInputBarInputItem
            nextItem.changeState(.inputing)
        }
    }
    
    // 切换上一个
    func switchLastInputItem() {
        guard let currentItem = fetchCurrentInputItem() else {
            return
        }
        
        func next() {
            let lastItem = arrangedSubviews[currentItem.index - 1] as! TTAuthCodeInputBarInputItem
            currentItem.changeState(.unInput)
            lastItem.resetContent()
            lastItem.changeState(.inputing)
        }
        
        
        if currentItem.index == 0 {
            // firstOne nothing
        }else if currentItem.index == arrangedSubviews.maxIndex {
            if currentItem.inputTF.text?.isNotEmpty ?? false {
                currentItem.resetContent()
            }else {
                next()
            }
        }else {
            next()
        }
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



