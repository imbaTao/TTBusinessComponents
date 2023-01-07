//
//  TTTabbarItemConfig.swift
//  TTBusinessComponents
//
//  Created by hong on 2023/1/7.
//

import Foundation
open class TTTabbarItemConfig: NSObject,TTTabbarItemConfigProtocol {
    // 全局配置
    static let basicConfig = TTTabbarItemConfig()
    public var titleNormalFont: UIFont  = UIFont.medium(10)
    public var titleSelectedFont: UIFont  = UIFont.medium(10)
    public var titleNormalColor: UIColor = UIColor.black
    public var titleSelectedColor: UIColor = UIColor.black
    public var iconSize = CGSize.init(width: 32, height: 32)
}
