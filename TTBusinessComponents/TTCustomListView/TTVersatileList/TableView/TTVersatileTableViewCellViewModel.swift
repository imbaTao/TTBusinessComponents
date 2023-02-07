//
//  TTVersatileTableViewCellViewModel.swift
//  ActiveLabel
//
//  Created by hong on 2023/1/6.
//

import Foundation
import RxSwift
import RxRelay
import UIKit

open class TTVersatileTableViewCellViewModel:TTTableViewCellViewModel,TTVersatileListCellViewModelProtocol {
    public lazy var subTitleRelay: BehaviorRelay<String?> = {
        var subTitleRelay = BehaviorRelay<String?>.init(value: nil)
        return subTitleRelay
    }()
    
    public lazy var iconRelay: BehaviorRelay<UIImage?> = {
        var iconRelay = BehaviorRelay<UIImage?>.init(value: nil)
        return iconRelay
    }()
    
    public lazy var subIconRelay: BehaviorRelay<UIImage?> = {
        var subIconRelay = BehaviorRelay<UIImage?>.init(value: nil)
        return subIconRelay
    }()
    
    public lazy var avatarUrlRelay: BehaviorRelay<String?> = {
        var avatarUrlRelay = BehaviorRelay<String?>.init(value: nil)
        return avatarUrlRelay
    }()
    
    public lazy var isShowArrowIcon: BehaviorRelay<Bool?> = {
        var isShowArrowIcon = BehaviorRelay<Bool?>.init(value: nil)
        return isShowArrowIcon
    }()
    
    public private(set) var model: NSObject!
    
    public init(_ model: NSObject) {
        self.model = model
    }
}


