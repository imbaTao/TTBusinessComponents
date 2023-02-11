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
    private lazy var headerRefreshTrigger: PublishSubject<Void> = {
        var headerRefreshTrigger = PublishSubject<Void>()
        return headerRefreshTrigger
    }()
    
    private lazy var footerRefreshTrigger: PublishSubject<Void> = {
        var footerRefreshTrigger = PublishSubject<Void>()
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
            self.headerRefreshTrigger.onNext(())
        }

        // 绑定刷新头事件
       let requestResult = viewModel.bindRefreshHeaderTrigger(headerRefreshTrigger)
        requestResult.subscribe(onNext: {[weak self] (requestDataSize) in guard let self = self else { return }
            self.viewModel.refreshPageNumber = 0
            if requestDataSize < self.viewModel.pageSize {
                self.mainListView.mj_footer?.endRefreshingWithNoMoreData()
            }
            
            self.mainListView.mj_header?.endRefreshing()
        },onCompleted: {[weak self]  in guard let self = self else { return }
            self.mainListView.mj_header?.endRefreshing()
        }).disposed(by: rx.disposeBag)
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
            self.footerRefreshTrigger.onNext(())
        })
        
        // 绑定刷新头事件
        let requestResult = viewModel.bindRefreshFooterTrigger(footerRefreshTrigger)
        requestResult.subscribe(onNext: {[weak self] (requestDataSize) in guard let self = self else { return }
            self.viewModel.refreshPageNumber += 1
            
            // 根据请求数据大小，决定刷新时机
            if requestDataSize < self.viewModel.pageSize {
                self.mainListView.mj_footer?.endRefreshing()
                self.mainListView.mj_footer?.endRefreshingWithNoMoreData()
            }else {
                self.mainListView.mj_footer?.endRefreshing()
            }
        }).disposed(by: rx.disposeBag)
    }
}
