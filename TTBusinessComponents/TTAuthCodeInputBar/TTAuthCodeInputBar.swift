//
//  TTBusinessComponents.swift
//  TTBusinessComponents
//
//  Created by hong on 2023/1/7.

import Foundation
import TTUIKit
import RxSwift
import RxCocoa

open class TTAuthCodeInputBar: TTStackView {
    /// 内容
    public let contentChanged = PublishSubject<String>()
    
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
    
    public init(inputItemCount: Int) {
        super.init(frame: .zero)
        createItems(inputItemCount: inputItemCount)
        
    }
    
    open override func setupUI() {
        super.setupUI()
        axis = .horizontal
    }
    
    func createItems(inputItemCount: Int) {
        for _ in 0..<inputItemCount {
            let item = TTAuthCodeInputBarInputItem()
            
            // 点击选中item
            item.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in guard let self = self else { return }
                self.selecteInputItem(item)
            }).disposed(by: item.rx.disposeBag)
            
            // 监听item的状态
            item.stateRelay.subscribe(onNext: {[weak self] (state) in guard let self = self else { return }
                switch state {
                case .complte:
                    self.switchNextInputItem(item)
                    
                    // 同步外部
                    self.contentChanged.onNext(self.content)
                default:
                    break
                }
            }).disposed(by: item.rx.disposeBag)
            
            
            item.inputTF.rx.sentMessage(#selector(UIKeyInput.deleteBackward)).subscribe(onNext: {
                [weak self] (_) in guard let self = self else { return }
                // 点击删除键
                self.switchLastInputItem(item)

                // 同步外部
                self.contentChanged.onNext(self.content)
            }).disposed(by: item.rx.disposeBag)

            
            item.backgroundColor = .random
            addArrangedSubview(item)
        }
    }
    
    /// 选中当前输入框
    func selecteInputItem(_ selectedItem: TTAuthCodeInputBarInputItem) {
        // 选中下标
        guard let selectedItemIndex = arrangedSubviews.firstIndex(of: selectedItem) else {
            return
        }
        
        // 上一个有内容的item
        if  let lastHasContentItem = arrangedSubviews.first(where: { item in
            if let item = item as? TTAuthCodeInputBarInputItem {
                return item.inputTF.text?.isNotEmpty ?? false
            }
            return false
        }) {
            guard let lastHasContentItemIndex = arrangedSubviews.firstIndex(of: lastHasContentItem) else {
                return
            }
            
            // 下标相等可以允许选中
            let isNextIndex = (selectedItemIndex - lastHasContentItemIndex == 1)
            if selectedItemIndex == lastHasContentItemIndex || isNextIndex  {
                selectedItem.changeState(.inputing)
            }
        }else {
            // 是第一个
            selectedItem.changeState(.inputing)
        }
    }

    // 切换上一个
    func switchLastInputItem(_ currentItem: TTAuthCodeInputBarInputItem) {
        guard let currentIndex = arrangedSubviews.firstIndex(of: currentItem) else {
            return
        }
        let lastIndex = currentIndex - 1
        
        if lastIndex >= 0 {
            // 如果当前item是最后一个,内容不为空，就先清空自己
            if currentIndex == arrangedSubviews.maxIndex, currentItem.inputTF.text != "" {
                currentItem.inputTF.text = ""
                return
            }

            let lastItem = arrangedSubviews[lastIndex] as! TTAuthCodeInputBarInputItem
            // 清空上一个
            lastItem.inputTF.text = ""
            lastItem.changeState(.inputing)
            currentItem.changeState(.unInput)
        } else {
            // 是第一个不做处理
        }
    }

    // 切换下一个
    func switchNextInputItem(_ currentItem: TTAuthCodeInputBarInputItem) {
        guard let currentIndex = arrangedSubviews.firstIndex(of: currentItem) else {
            return
        }
        
        let nextIndex = currentIndex + 1
        if nextIndex <= arrangedSubviews.maxIndex {
            let nextItem = arrangedSubviews[nextIndex] as! TTAuthCodeInputBarInputItem
            nextItem.changeState(.inputing)

            // 当前输入完毕
            currentItem.changeState(.complte)
        } else {
            // 是最后一个停止输入,收起键盘
            //            currentItem.inputTF.resignFirstResponder()
        }
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



