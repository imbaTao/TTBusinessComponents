//
//  TTListCellViewModel.swift
//  TTUIKit
//
//  Created by hong on 2023/1/7.
//

import Foundation
import RxSwift
import RxRelay


open class TTBussinessListCellViewModel: NSObject {
    public var model: Any
    public lazy var titleRelay: BehaviorRelay<String?> = {
        var titleRelay = BehaviorRelay<String?>.init(value: nil)
        return titleRelay
    }()
    
    public lazy var selecteStateRelay: BehaviorRelay<Bool> = {
        let selecteStateRelay = BehaviorRelay<Bool>(value: false)
        return selecteStateRelay
    }()
    
    public init(_ model: Any) {
        self.model = model
        super.init()
        bindCellViewModel(model)
    }
    
    open func bindCellViewModel(_ model: Any) {
        
    }
  
}

