//
//  TTBusinessCore.swift
//  ActiveLabel
//
//  Created by hong on 2023/1/7.
//

import Foundation
@_exported import TTUIKit

public protocol TTBussinessBasicComponentsProtocol {
    var titleLabel: UILabel {set get}
    var subTitleLabel: UILabel {set get}
    var icon: UIImageView {set get}
    var subIcon: UIImageView {set get}
    var arrowIcon: UIImageView {set get}
    var avatar: TTAvatar {set get}
    var segementLine: UIView {set get}
}
