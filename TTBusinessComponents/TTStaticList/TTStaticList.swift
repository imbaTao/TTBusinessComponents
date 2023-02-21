//
//  TTStaticList.swift
//  TTTemplate_Example
//
//  Created by 　hong on 2023/2/21.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import TTUIKit

private struct TTStaticListFeatureExtensionKey {
    static var stackRowListKey = "TTStaticListFeatureExtensionKey_stackRowListKey"
    static var stackRowListContainerKey = "TTStaticListFeatureExtensionKey_stackRowListContainerKey"
}

public protocol TTStaticListFeatureDelegate where Self: UIViewController {
    var stackRowList: TTStackView {set get}
    var listContainer: UIScrollView {set get}
    func setupList()
}

public extension TTStaticListFeatureDelegate {
    var stackRowList: TTStackView {
           get {
               if let stackRowList = objc_getAssociatedObject(self, &TTStaticListFeatureExtensionKey.stackRowListKey) as? TTStackView {
                   return stackRowList
               } else {
                   let stackRowList = TTStackView.verticalStack(0)
                   objc_setAssociatedObject(self, &TTStaticListFeatureExtensionKey.stackRowListKey, stackRowList, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                   return stackRowList
               }
           }
           set {
               objc_setAssociatedObject(self, &TTStaticListFeatureExtensionKey.stackRowListKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
           }
    }
    
    var listContainer: UIScrollView {
           get {
               if let listContainer = objc_getAssociatedObject(self, &TTStaticListFeatureExtensionKey.stackRowListContainerKey) as? UIScrollView {
                   return listContainer
               } else {
                   let listContainer = UIScrollView.init(frame: .zero)
                   objc_setAssociatedObject(self, &TTStaticListFeatureExtensionKey.stackRowListContainerKey, listContainer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                   return listContainer
               }
           }
           set {
               objc_setAssociatedObject(self, &TTStaticListFeatureExtensionKey.stackRowListContainerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
           }
    }
    
    
    init() {
        self.init(nibName: nil, bundle: nil)
        setupList()
    }
    
    func setupList() {
        addSubview(listContainer)
        listContainer.addSubview(stackRowList)
        listContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        stackRowList.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        // config
        stackRowList.axis = .vertical
        stackRowList.distribution = .fill
        stackRowList.alignment = .fill
        stackRowList.spacing = 0
        listContainer.showsVerticalScrollIndicator = false
        listContainer.isScrollEnabled = true
    }
    
    // 添加行数
    func addRows(_ rows: [TTStaticRow]) {
        guard rows.count > 0 else { return }
        stackRowList.addArrangedSubviews(rows)
    }

    func addRow(_ rows: TTStaticRow) {
        stackRowList.addArrangedSubview(rows)
    }

    // 获取行
    func row(_ index: Int) -> TTStaticRow {
        return stackRowList.arrangedSubviews[index] as! TTStaticRow
    }

    var rows: [TTStaticRow] {
        return stackRowList.arrangedSubviews as! [TTStaticRow]
    }
}


