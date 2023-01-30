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

open class TTSingleCellTypeCollectionView<T: TTCollectionViewCell>: TTConnectionView,UICollectionViewDelegate,UICollectionViewDataSource {

    
    // 数据源绑定
    public let items = BehaviorRelay<[TTCollectionViewCellViewModel]>.init(value: [])
    
    // 模型选中/未选中
    public let modelSelected = PublishSubject<TTCollectionViewCellViewModel>()
    public let modelDeselected = PublishSubject<TTCollectionViewCellViewModel>()
    
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
    func testData(_ data: [TTVersatileTableViewCellViewModel] = []) {
        
        if data.isEmpty {
            let data = [
                TestCellViewModel.init(.init()),
                TestCellViewModel.init(.init()),
                TestCellViewModel.init(.init())
            ]
            items.accept(data)
        }else {
            items.accept(data)
        }
  
    }
    #endif
    
}


#if DEBUG
class TestCellViewModel: TTVersatileTableViewCellViewModel {
    override init(_ model: NSObject) {
        super.init(model)
        
        titleRelay.accept("测试内容是\(arc4random()%100000)")
    }
}
#endif
