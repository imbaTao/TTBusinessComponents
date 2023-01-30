//
//  TTVersatileListProtocol.swift
//  ActiveLabel
//
//  Created by hong on 2023/1/6.
//

import Foundation
import RxSwift
import RxRelay

public protocol TTVersatileListCellViewModelProtocol {

    var subTitleRelay: RxRelay.BehaviorRelay<String?> { get set }

    var iconRelay: RxRelay.BehaviorRelay<UIImage?> { get set }

    var subIconRelay: RxRelay.BehaviorRelay<UIImage?> { get set }

    var avatarUrlRelay: RxRelay.BehaviorRelay<String?> { get set }

    var isShowArrowIcon: RxRelay.BehaviorRelay<Bool?> { get set }
    
    
}
