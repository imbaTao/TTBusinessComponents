//
//  TTListCellViewModel.swift
//  TTUIKit
//
//  Created by hong on 2023/1/7.
//

import Foundation
import RxSwift
import RxRelay

public protocol TTBussinessListCellViewModelProtocol {
    var titleRelay: RxRelay.BehaviorRelay<String?> { get set }
    var selecteStateRelay: RxRelay.BehaviorRelay<Bool> { get set }
    var subTitleRelay: RxRelay.BehaviorRelay<String?> { get set }
    var iconRelay: RxRelay.BehaviorRelay<UIImage?> { get set }
    var iconUrlRelay: RxRelay.BehaviorRelay<String?> { get set }
    var subIconRelay: RxRelay.BehaviorRelay<UIImage?> { get set }
    var subIconUrlRelay: RxRelay.BehaviorRelay<String?> { get set }
    var avatarUrlRelay: RxRelay.BehaviorRelay<String?> { get set }
    var isShowArrowIcon: RxRelay.BehaviorRelay<Bool?> { get set }
}


open class TTBussinessListCellViewModel: NSObject,TTBussinessListCellViewModelProtocol {
    public lazy var titleRelay: BehaviorRelay<String?> = {
        var titleRelay = BehaviorRelay<String?>.init(value: nil)
        return titleRelay
    }()
    
    public lazy var selecteStateRelay: BehaviorRelay<Bool> = {
        let selecteStateRelay = BehaviorRelay<Bool>(value: false)
        return selecteStateRelay
    }()
    
    public lazy var subTitleRelay: BehaviorRelay<String?> = {
        var subTitleRelay = BehaviorRelay<String?>.init(value: nil)
        return subTitleRelay
    }()
    
    public lazy var iconRelay: BehaviorRelay<UIImage?> = {
        var iconRelay = BehaviorRelay<UIImage?>.init(value: nil)
        return iconRelay
    }()
    
    public lazy var iconUrlRelay: BehaviorRelay<String?> = {
        var iconUrlRelay = BehaviorRelay<String?>.init(value: nil)
        return iconUrlRelay
    }()
    
    public lazy var subIconRelay: BehaviorRelay<UIImage?> = {
        var subIconRelay = BehaviorRelay<UIImage?>.init(value: nil)
        return subIconRelay
    }()
    
    public lazy var subIconUrlRelay: BehaviorRelay<String?> = {
        var subIconRelay = BehaviorRelay<String?>.init(value: nil)
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
   
    

    public var model: Any
    public init(_ model: Any) {
        self.model = model
        super.init()
        bindCellViewModel(model)
    }
    
    open func bindCellViewModel(_ model: Any) {
        
    }
}






