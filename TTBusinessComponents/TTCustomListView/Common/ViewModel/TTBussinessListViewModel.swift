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
    public let lastModelSelectedTrigger = BehaviorRelay<TTBussinessListCellViewModel?>.init(value: nil)
    public let modelDeselectTrigger = PublishSubject<TTBussinessListCellViewModel>()
    public let items = BehaviorRelay<[TTBussinessListCellViewModel]>.init(value: [])
    
    // 刷新页码
    public var refreshPageNumber = 0
    public var pageSize = 24
    
    /// 添加头
    func bindRefreshHeaderTrigger(_ trigger: Observable<Void>,refreshEndItemsCount: @escaping(Int?) -> ()) {
        // 外部trigger是重复触发的
        Observable.merge(Observable<Void>.just(()),trigger).subscribe(onNext: {[weak self] (_) in
            //
            debugPrint("触发了刷新")
            
            // 内部重发发送，防止报错终止
            _ = self?.headerRefreshRequest().subscribe(onNext: {[weak self] (refreshViewModels) in
                refreshEndItemsCount(refreshViewModels.count)
                self?.items.accept(refreshViewModels)
            },onError: { _ in
                // 这个请求是需要报错的
                refreshEndItemsCount(nil)
            })
        }).disposed(by: rx.disposeBag)
    }
    
    /// 下拉刷新请求
    open func headerRefreshRequest() -> Observable<[TTBussinessListCellViewModel]> {
        return .empty()
    }
    
    /// 添加尾绑定
    func bindRefreshFooterTrigger(_ trigger: Observable<Void>,refreshEndItemsCount: @escaping(Int?) -> ()) {
        trigger.subscribe(onNext: {[weak self] (_) in
            _ = self?.footerRefreshRequest().subscribe(onNext: {[weak self] (refreshViewModels) in
                
                if var currentItems = self?.items.value {
                    refreshEndItemsCount(refreshViewModels.count)
                    
                    // 添加到尾部
                    currentItems.append(contentsOf: refreshViewModels)
                    self?.items.accept(currentItems)
                }
            },onError: { _ in
                refreshEndItemsCount(nil)
            })
        }).disposed(by: rx.disposeBag)
    }
    
    /// 尾部刷新请求
    open func footerRefreshRequest() -> Observable<[TTBussinessListCellViewModel]> {
        return .just([])
    }
    
}


