//
//  TTSingleCellTypeCollectionView.swift
//  TTUIKit
//
//  Created by hong on 2023/1/7.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import MJRefresh
import HandyJSON


open class TTSingleCellTypeCollectionView<T: TTCollectionViewCell>: TTConnectionView,UICollectionViewDelegate,UICollectionViewDataSource {

    // 数据源绑定
    public let items = BehaviorRelay<[TTCollectionViewCellViewModel]>.init(value: [])
    
    // 模型选中/未选中
    public let modelSelected = PublishSubject<TTCollectionViewCellViewModel>()
    public let modelDeselected = PublishSubject<TTCollectionViewCellViewModel>()
    
    
    // 头部刷新信号
    public let headerWillRefresh = PublishSubject<Void>()
    
    // 尾部刷新信号
    public let footerWillRefresh = PublishSubject<Void>()
    
    // 数据页码
    public private(set) var dataPageIndex = 0
    
    open override func setupUI() {
        config.cellTypes.append(T.self)
        super.setupUI()

        delegate = self
        dataSource = self
    }
    

    
    open override func setupEvents() {
        super.setupEvents()
        
        //绑定单元格数据
//        items.bind(to: collectionView.rx.items(dataSource: dataSource))
//                .disposed(by: disposeBag)
        
//        items.bind(to: self.rx.items(cellIdentifier: NSStringFromClass(T.self) as String, cellType: T.self)) { index,item,cell in
//            let cell: TTCollectionViewCell = cell as TTCollectionViewCell
//
//
//            // 选中状态变更
//            if item.selecteStateRelay.value {
//                self.selectRow(
//                    at: .init(row: index, section: 0), animated: false, scrollPosition: .none)
//            }
//        }.disposed(by: rx.disposeBag)
    
        items.subscribe(onNext: {[weak self] (_) in guard let self = self else { return }
            self.reloadData()
        }).disposed(by: rx.disposeBag)
    }
    
    
    // event
    open func headerAction() {
        headerWillRefresh.onNext(())
    }
    
    open func footerAction() {
        footerWillRefresh.onNext(())
    }
    
    // MARK: - dataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.value.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(T.self) as String, for: indexPath) as! T
        let cellViewModel = items.value[indexPath.row]
        cell.bindViewModel(cellViewModel)
        // 选中状态变更
        if cellViewModel.selecteStateRelay.value {
            self.selectItem(at: .init(row: indexPath.row, section: 0), animated: false, scrollPosition: .bottom)
        }
        return cell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < items.value.count else {
            return
        }

        let cellViewModel = items.value[indexPath.row]
        cellViewModel.selecteStateRelay.accept(true)
        modelSelected.onNext(cellViewModel)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard indexPath.row < items.value.count else {
            return
        }
        
        let cellViewModel = items.value[indexPath.row]
        cellViewModel.selecteStateRelay.accept(false)
        modelDeselected.onNext(cellViewModel)
    }
}


public extension TTSingleCellTypeCollectionView {
    #if DEBUG
//    func testData(_ data: [TTVersatileCollectionViewCellViewModel] = []) {
//        if data.isEmpty {
//            let data = [
//                TestCellViewModel.init(()),
//                TestCellViewModel.init(.init()),
//                TestCellViewModel.init(.init())
//            ]
//            items.accept(data)
//        }else {
//            items.accept(data)
//        }
//
//    }
    #endif
    
    
    func addHeader() {
        mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]  in guard let self = self else { return }
            self.headerAction()
        })
    }
    
    /// to flag complete
    func headerRefreshComplete(_ isError: Bool = false) {
        if !isError {
            dataPageIndex = 0
        }
        mj_header?.endRefreshing()
    }
    
  
    
    func addFooter() {
        mj_footer = MJRefreshAutoFooter(refreshingBlock: {[weak self]  in guard let self = self else { return }
            self.footerAction()
        })
    }
    
    
    func footerRefreshComplte(_ isError: Bool) {
        if !isError {
            dataPageIndex += 1
        }
    
        mj_footer?.endRefreshing()
    }
    
}


#if DEBUG
class TestCellViewModel: TTVersatileCollectionViewCellViewModel {
    override init(_ model: HandyJSON) {
        super.init(model)
        
        titleRelay.accept("测试内容是\(arc4random()%100000)")
    }
}
#endif
