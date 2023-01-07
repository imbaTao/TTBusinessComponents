//
//  TTTabbarController.swift
//  TTUIKit
//
//  Created by 　hong on 2022/12/16.
//

import Foundation


open class TTTabbarViewController: UITabBarController {
    // item点击事件
    var tabbarItemSelectedBlock: ((Int,TTTabbarItem) -> ())? = nil
    
    // 自定义导航栏
    var myTabbar: TTTabbar?
    
    public required init(_ itemModelsAndControllers: [TTTabbarItemModel : UIViewController],defaultSelectedIndex: Int = 0) {
        super.init(nibName: nil, bundle: nil)
        guard itemModelsAndControllers.keys.count != 0 else {
            assert(false,"TTTabbarViewController配置模型不能为空！")
        }
        
        let viewControllers = itemModelsAndControllers.map({$0.value})
        
        let itemModels = itemModelsAndControllers.map{$0.key}
        self.viewControllers = viewControllers
       
        
        myTabbar = TTTabbar.init(items: itemModels.compactMap({ model in
            return .init(itemMoel: model)
        }))
        
        myTabbar?.barStack.arrangedSubviews.forEach { barItem in
            let item = barItem as! TTTabbarItem
            item.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
        }
       
       // 替换系统tabbar
       self.setValue(myTabbar, forKey: "tabBar")
    
        // set defaultSelectedIndex
        itemModels.forEach { model in
            model.selectStateChanged = { [weak self] cIsSelcted in guard let self = self else { return }
                if let index = itemModels.firstIndex(of: model),cIsSelcted,let tabbarItem = self.myTabbar?.barStack.arrangedSubviews[index] as? TTTabbarItem {
                    tabbarItem.isSelected = cIsSelcted
                    self.selectedIndex = index
                    self.tabbarItemSelectedBlock?(index,tabbarItem)
                }
            }
        }
        
        itemModels[defaultSelectedIndex].isSelcted = true
       
        
    }
    
    @objc func clickAction(_ sender: TTTabbarItem) {
        guard let myTabbar = myTabbar else {
            return
        }
        var index = 0
        myTabbar.barStack.arrangedSubviews.forEach { item in
            let item = item as! TTTabbarItem
            if sender == item {
                item.isSelected = true
            }else {
                item.isSelected = false
            }
            index += 1
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 把图层移到最上层,否则会被系统层的UITabbarButton挡住
        if let tabbar = myTabbar {
            tabbar.bringSubviewToFront(tabbar.barContainer)
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
