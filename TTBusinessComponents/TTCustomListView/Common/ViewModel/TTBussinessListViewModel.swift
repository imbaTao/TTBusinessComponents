//
//  TTListViewModel.swift
//  TTUIKit
//
//  Created by 　hong on 2023/2/9.
//

import Foundation
import RxSwift
import RxRelay
import RxOptional

open class TTBussinessListViewModel: TTViewModel{
    public let modelSelectedTrigger = PublishSubject<TTBussinessListCellViewModel>()
    public let modelDeselectTrigger = PublishSubject<TTBussinessListCellViewModel>()
    public let items = BehaviorRelay<[TTBussinessListCellViewModel]>.init(value: [])
    
    // 刷新页码
    public var refreshPageNumber = 0
    public var pageSize = 24
    
    /// 添加头
    public func bindRefreshHeaderTrigger(_ trigger: Observable<Void>) -> Observable<Int> {
       let requestObserverble = trigger.flatMap(headerRefreshRequest)
        requestObserverble.bind(to: items).disposed(by: rx.disposeBag)
        return requestObserverble.flatMap { requestElements -> Observable<Int> in
            return .just(requestElements.count)
        }
    }
    
    /// 下拉刷新请求
    open func headerRefreshRequest() -> Observable<[TTBussinessListCellViewModel]> {
        return .just([])
    }
    
    /// 添加尾
    public func bindRefreshFooterTrigger(_ trigger: Observable<Void>) -> Observable<Int> {
        let requestObserverble = trigger.flatMap(footerRefreshRequest)
        requestObserverble.bind(to: items).disposed(by: rx.disposeBag)
        return requestObserverble.flatMap { requestElements -> Observable<Int> in
            return .just(requestElements.count)
        }
    }
    
    /// 尾部刷新请求
    open func footerRefreshRequest() -> Observable<[TTBussinessListCellViewModel]> {
        return .just([])
    }
    
}


