//
//  TTBussinessListCellProtocol.swift
//  TTCustomListView
//
//  Created by 　hong on 2023/2/9.
//

import Foundation
import RxSwift
import RxRelay

public protocol TTBussinessListCellProtocol where Self: UIView {
    var cellDisposeBag: DisposeBag{set get}
    var subTitleLabel: UILabel {set get}
    var icon: UIImageView {set get}
    var subIcon: UIImageView {set get}
    var arrowIcon: UIImageView {set get}
    var avatar: TTAvatar {set get}
    
    /// 回收监听包
    func recycleRxDisposeBag()
}
 
public extension TTBussinessListCellProtocol {
    func recycleRxDisposeBag() {
        self.cellDisposeBag = DisposeBag()
    }
}
