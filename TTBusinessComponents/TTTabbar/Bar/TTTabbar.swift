//
//  TTTabbar.swift
//  TTUIKit
//
//  Created by 　hong on 2022/12/16.
//

import Foundation

// 外层只是个容器，包裹着bar,这样bar可以动态调整位置
class TTTabbar: UITabBar {
    
    // 分割线
    lazy var segementLine: UIView = {
        var line = UIView()
        line.backgroundColor = .gray102
        self.addSubview(line)
        self.layer.insertSublayer(line.layer, at: 0)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(CGFloat.onePixel)
        }
        return line
    }()

    // 自定义导航栏
    let barStack = TTStackView.horizontalStack()
    
    // container要拉满
    let barContainer = UIView()
    
    init(items: [TTTabbarItem],hasSegementLine: Bool = true) {
        super.init(frame: .zero)
        addSubviews([barContainer])
        if hasSegementLine {
            barContainer.addSubviews([segementLine,barStack])
        }else {
            barContainer.addSubviews([barStack])
        }
        
        barContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        barStack.snp.makeConstraints { (make) in
            make.top.equalTo(hasSegementLine ? segementLine.snp.bottom : 0).offset(2)
            make.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.safeAreaLayoutGuide)
            } else {
                make.bottom.equalTo(0)
            }
        }
        
        // 添加items
        barStack.addArrangedSubviews(items)
        
        // config
        backgroundColor = .white
        barStack.spacing = 0
        barStack.distribution = .fillEqually
        barStack.alignment = .fill
        
        // 去掉横线
        shadowImage = UIImage()
        backgroundImage = UIImage()
        
        // 设置tabbar 不透明
        UITabBar.appearance().isTranslucent = false
    }

    // 获取点击的cell
    func fetchBarItem(index: Int) -> TTTabbarItem {
        return barStack.arrangedSubviews[index] as! TTTabbarItem
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
