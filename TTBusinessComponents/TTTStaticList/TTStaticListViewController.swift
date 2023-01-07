//
//  TTStaticListViewController.swift
//  ActiveLabel
//
//  Created by hong on 2022/12/18.
//

import Foundation
open class TTStaticListViewController: TTViewController {
    private let listContainer = UIScrollView()
    private let stackList = TTStackView()
    open override func setupUI() {
        super.setupUI()
        addSubView(listContainer)
        listContainer.addSubview(stackList)
        
        listContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        stackList.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            //            make.width.equalTo(CGFloat.screenWidth)
            make.width.equalToSuperview()
        }
        
        // config
        stackList.axis = .vertical
        stackList.distribution = .fill
        stackList.alignment = .fill
        stackList.spacing = 0
        listContainer.showsVerticalScrollIndicator = false
        listContainer.isScrollEnabled = true
        listContainer.bounces = false
    }
    
}

public extension TTStaticListViewController {
     var rows: [TTStaticRow] {
        return stackList.arrangedSubviews as! [TTStaticRow]
    }
}


public extension TTStaticListViewController {
    // 添加行数
    func addRows(_ rows: [TTStaticRow]) {
        guard rows.count > 0 else { return }
        stackList.addArrangedSubviews(rows)
    }
    
    func addRow(_ rows: TTStaticRow) {
        stackList.addArrangedSubview(rows)
    }
    
    func removeAllRows() {
        stackList.removeSubviews()
    }
    
    // 获取行
    func row(_ index: Int) -> TTStaticRow {
        return stackList.arrangedSubviews[index] as! TTStaticRow
    }
    
    func operationRowDisplay(_ row: TTStaticRow,isDisplay: Bool,_ animate: Bool = true,_ animateDuration: TimeInterval = 0.25) {
        if animate {
            UIView.animate(withDuration: animateDuration, delay: 0) {
                row.isHidden = !isDisplay
            }
        }else {
            row.isHidden = !isDisplay
        }
    }
}
