//
//  TTTabbarItemModel.swift
//  TTBusinessComponents
//
//  Created by hong on 2023/1/7.
//

import Foundation

// 导航栏模型
open class TTTabbarItemModel: NSObject,TTTabbarItemConfigProtocol {
    public var titleNormalFont: UIFont = TTTabbarItemConfig.basicConfig.titleNormalFont
    public var titleSelectedFont: UIFont = TTTabbarItemConfig.basicConfig.titleSelectedFont
    public var titleNormalColor: UIColor = TTTabbarItemConfig.basicConfig.titleNormalColor
    public var titleSelectedColor: UIColor = TTTabbarItemConfig.basicConfig.titleSelectedColor
    public var iconSize = TTTabbarItemConfig.basicConfig.iconSize
    
    
    // 标题
    public var title = ""
    
    // 未选中图片名字
    public var normalImage: UIImage!

    // 选中item时的图片的名字
    public var selectedImage: UIImage!

    // 是否突起
    public var isTuber = false
    
    // 是否选中了
    var isSelcted = false {
        didSet {
            selectStateChanged?(isSelcted)
        }
    }
    
    var selectStateChanged: ((_ isSelected: Bool) -> ())? = nil
    public init(title: String,normalImage: UIImage,selectedImage: UIImage) {
        super.init()
        self.title = title
        self.normalImage = normalImage
        self.selectedImage = selectedImage
    }
}
