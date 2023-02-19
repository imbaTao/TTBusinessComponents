//
//  TTBussinessListBasicController.swift
//  TTBusinessComponents
//
//  Created by 　hong on 2023/2/10.
//

import Foundation
import RxSwift
import RxRelay
import TTUIKit
import MJRefresh

open class TTBussinessListBasicViewController<T: TTBussinessListViewModel>:TTViewModelController<T> {
    public var mainListView: UIScrollView!
    private lazy var headerRefreshTrigger: BehaviorRelay<Void> = {
        var headerRefreshTrigger = BehaviorRelay<Void>(value: ())
        return headerRefreshTrigger
    }()
    
    private lazy var footerRefreshTrigger: BehaviorRelay<Void> = {
        var footerRefreshTrigger = BehaviorRelay<Void>(value: ())
        return footerRefreshTrigger
    }()
}

/// Method
public extension TTBussinessListBasicViewController {
    /// 添加头
    func addRefreshHeader() {
        guard mainListView.mj_header == nil else {
            return
        }

        // 设置头
        mainListView.mj_header = MJRefreshNormalHeader {[weak self]  in guard let self = self else { return }
            self.headerRefreshTrigger.accept(())
        }

        // 绑定刷新头事件
        viewModel.bindRefreshHeaderTrigger(headerRefreshTrigger.asObservable(),refreshEndItemsCount: { [weak self] itemsCount in guard let self = self else { return }
            if let itemsCount = itemsCount {
                self.viewModel.refreshPageNumber = 0
                if itemsCount < self.viewModel.pageSize {
                    self.mainListView.mj_footer?.endRefreshingWithNoMoreData()
                }
                
                self.mainListView.mj_header?.endRefreshing()
            }else {
                self.mainListView.mj_header?.endRefreshing()
            }
        })
    }
    
    /// 添加尾
    func addRefreshFooter() {
//        view.backgroundColor = .gray
//        mainListView.backgroundColor = .orange
        guard mainListView.mj_footer == nil else {
            return
        }
        // 设置头
        mainListView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {[weak self]  in guard let self = self else { return }
            self.footerRefreshTrigger.accept(())
        })
        
        // 绑定刷新头事件
        viewModel.bindRefreshFooterTrigger(footerRefreshTrigger.asObservable(),refreshEndItemsCount: { [weak self] itemsCount in guard let self = self else { return }
            if let itemsCount = itemsCount {
                self.viewModel.refreshPageNumber += 1
                if itemsCount < self.viewModel.pageSize {
                    self.mainListView.mj_footer?.endRefreshingWithNoMoreData()
                }
                self.mainListView.mj_header?.endRefreshing()
            }else {
                self.mainListView.mj_header?.endRefreshing()
            }
        })
    }
}
