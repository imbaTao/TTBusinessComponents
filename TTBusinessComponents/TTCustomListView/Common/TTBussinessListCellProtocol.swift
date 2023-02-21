//
//  TTBussinessListCellProtocol.swift
//  TTCustomListView
//
//  Created by 　hong on 2023/2/9.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

public protocol TTBussinessListCellProtocol where Self: UIView {
    var cellDisposeBag: DisposeBag{set get}
    var subTitleLabel: UILabel {set get}
    var icon: UIImageView {set get}
    var subIcon: UIImageView {set get}
    var arrowIcon: UIImageView {set get}
    var avatar: TTAvatar {set get}
    var segementLine: UIView {set get}

    /// 回收监听包
    func recycleRxDisposeBag()
}



public extension TTBussinessListCellProtocol {
    
    
    
//    public lazy var titleLabel: UILabel = {
//        var titleLabel = UILabel.regular(size: 16, textColor: .black0, text: "", alignment: .left)
//        return titleLabel
//    }()
//
//    public lazy var subTitleLabel: UILabel = {
//         var subTitleLabel = UILabel.regular()
//         return subTitleLabel
//     }()
//
//     public lazy var icon: UIImageView = {
//         var icon = UIImageView.idle()
//         return icon
//     }()
//
//     public lazy var subIcon: UIImageView = {
//         var subIcon = UIImageView.idle()
//         return subIcon
//     }()
//
//     public lazy var arrowIcon: UIImageView = {
//         var arrowIcon = UIImageView.idle()
//         return arrowIcon
//     }()
//
//     public lazy var avatar: TTAvatar = {
//         var avatar = TTAvatar()
//         return avatar
//     }()
//
//    public lazy var segementLine: UIView = {
//        let segementLine = UIView.colorView(rgba(223, 223, 223, 0.5))
//        return segementLine
//    }()
}











 
public extension TTBussinessListCellProtocol {
    func recycleRxDisposeBag() {
        self.cellDisposeBag = DisposeBag()
    }
}
