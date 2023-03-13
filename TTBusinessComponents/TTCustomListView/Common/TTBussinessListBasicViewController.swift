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
    
    // Use a button to Tips,whoooo!
    private lazy var emptyTipsView: TTButton = {
        var emptyTipsView = TTButton { config in
            config.type = .iconOnTheTop
            config.interval = 12
            config.titleFonts = [.normal : .medium(14)]
            config.titleColors = [.normal : .gray102]
        }
        return emptyTipsView
    }()
}

// MARK: - header & footer
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

// MARK: - emptyTipsView
public extension TTBussinessListBasicViewController {
    // 添加控提示
    func addEmtyTips(_ configBlock: (_ config: TTButtonConfig) -> (),_ selection: (() -> ())? = nil) {
        if emptyTipsView.superview == nil {
            mainListView.addSubview(emptyTipsView)
            
            // bind
            viewModel.items.skip(1).map{$0.count > 0}.bind(to: emptyTipsView.rx.isHidden).disposed(by: rx.disposeBag)
            
            // update
            emptyTipsView.updateConfig(configBlock)
            
            // 设置约束
            emptyTipsView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(0)
            }
            
            emptyTipsView.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in guard let self = self else { return }
                selection?()
            }).disposed(by: rx.disposeBag)
        }
    }
    
    // 移除控件
    func removeEmptyTips() {
        emptyTipsView.removeFromSuperview()
    }
    
    /// 设置纵向水平更新
    func setEmptyViewVerticalOffSet(_ offset: CGFloat) {
        guard emptyTipsView.superview != nil else {
           return
        }
        
        emptyTipsView.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview().offset(offset)
        }
    }
}
