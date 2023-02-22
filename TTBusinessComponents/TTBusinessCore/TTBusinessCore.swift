//
//  TTBusinessCore.swift
//  ActiveLabel
//
//  Created by hong on 2023/1/7.
//

import Foundation
@_exported import TTUIKit

private struct TTBussinessBasicComponentsExtensionKeys {
    static var titleLabel = "titleLabel"
    static var subTitleLabel = "subTitleLabel"
    static var icon = "icon"
    static var subIcon = "subIcon"
    static var avatar = "avatar"
    static var segementLine = "segementLine"
}

public protocol TTBussinessBasicComponentsProtocol: NSObject  {
    var titleLabel: UILabel {set get}
    var subTitleLabel: UILabel {set get}
    var icon: UIImageView {set get}
    var subIcon: UIImageView {set get}
    var avatar: TTAvatar {set get}
    var segementLine: UIView {set get}
}

public extension TTBussinessBasicComponentsProtocol {
    var titleLabel: UILabel {
           get {
               if let oldValue = assosicatedObjectGetMethod(key: &TTBussinessBasicComponentsExtensionKeys.titleLabel, UILabel.self) {
                   return oldValue
               } else {
                   let newValue = UILabel.regular()
                   assosicatedObjectSetMethod(key: &TTBussinessBasicComponentsExtensionKeys.titleLabel, newValue: newValue)
                   return newValue
               }
           }
           set {
               assosicatedObjectSetMethod(key: &TTBussinessBasicComponentsExtensionKeys.titleLabel, newValue: newValue)
           }
    }
    
    var subTitleLabel: UILabel {
           get {
               if let oldValue = assosicatedObjectGetMethod(key: &TTBussinessBasicComponentsExtensionKeys.subTitleLabel, UILabel.self) {
                   return oldValue
               } else {
                   let newValue = UILabel.regular()
                   assosicatedObjectSetMethod(key: &TTBussinessBasicComponentsExtensionKeys.subTitleLabel, newValue: newValue)
                   return newValue
               }
           }
           set {
               assosicatedObjectSetMethod(key: &TTBussinessBasicComponentsExtensionKeys.subTitleLabel, newValue: newValue)
           }
    }

    var icon: UIImageView {
           get {
               if let oldValue = assosicatedObjectGetMethod(key: &TTBussinessBasicComponentsExtensionKeys.icon, UIImageView.self) {
                   return oldValue
               } else {
                   let newValue = UIImageView.idle()
                   assosicatedObjectSetMethod(key: &TTBussinessBasicComponentsExtensionKeys.icon, newValue: newValue)
                   return newValue
               }
           }
           set {
               assosicatedObjectSetMethod(key: &TTBussinessBasicComponentsExtensionKeys.icon, newValue: newValue)
           }
    }
    
    var subIcon: UIImageView {
           get {
               if let oldValue = assosicatedObjectGetMethod(key: &TTBussinessBasicComponentsExtensionKeys.subIcon, UIImageView.self) {
                   return oldValue
               } else {
                   let newValue = UIImageView.idle()
                   assosicatedObjectSetMethod(key: &TTBussinessBasicComponentsExtensionKeys.subIcon, newValue: newValue)
                   return newValue
               }
           }
           set {
               assosicatedObjectSetMethod(key: &TTBussinessBasicComponentsExtensionKeys.subIcon, newValue: newValue)
           }
    }
    
    var avatar: TTAvatar {
           get {
               if let oldValue = assosicatedObjectGetMethod(key: &TTBussinessBasicComponentsExtensionKeys.avatar, TTAvatar.self) {
                   return oldValue
               } else {
                   let newValue = TTAvatar()
                   assosicatedObjectSetMethod(key: &TTBussinessBasicComponentsExtensionKeys.avatar, newValue: newValue)
                   return newValue
               }
           }
           set {
               assosicatedObjectSetMethod(key: &TTBussinessBasicComponentsExtensionKeys.avatar, newValue: newValue)
           }
    }
    
    var segementLine: UIView {
           get {
               if let oldValue = assosicatedObjectGetMethod(key: &TTBussinessBasicComponentsExtensionKeys.segementLine, UIView.self) {
                   return oldValue
               } else {
                   let newValue = UIView.colorView(rgba(223, 223, 223, 0.5))
                   assosicatedObjectSetMethod(key: &TTBussinessBasicComponentsExtensionKeys.segementLine, newValue: newValue)
                   return newValue
               }
           }
           set {
               assosicatedObjectSetMethod(key: &TTBussinessBasicComponentsExtensionKeys.segementLine, newValue: newValue)
           }
    }
}



