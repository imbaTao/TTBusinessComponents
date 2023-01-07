//
//  TTCustomTableView.swift
//  ActiveLabel
//
//  Created by hong on 2023/1/6.
//

import Foundation
import RxSwift
import RxRelay

open class TTSingleCellTypeTableView<T: TTTableViewCell>:TTTableView, UITableViewDelegate,UITableViewDataSource {
    // 数据源绑定
    public var items = BehaviorRelay<[TTTableViewCellViewModel]>.init(value: [])
    
    // 模型选中/未选中
    public var modelSelected = PublishSubject<TTTableViewCellViewModel>()
    public var modelDeselected = PublishSubject<TTTableViewCellViewModel>()
    
    open override func setupUI() {
        config.cellTypes.append(T.self)
        super.setupUI()
        
        // 设置tableView额外代理，可以自定义UI
        self.dataSource = self
        self.delegate = self
    }
    
    open override func setupEvents() {
        super.setupEvents()
        items.subscribe(onNext: {[weak self] (_) in guard let self = self else { return }
            self.reloadData()
        }).disposed(by: rx.disposeBag)
    }
    // MARK: - dataSource
    open override func numberOfRows(inSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.value.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(T.self) as String, for: indexPath) as! T
        let cellViewModel = items.value[indexPath.row]
        cell.bindViewModel(cellViewModel)
        // 选中状态变更
        if cellViewModel.selecteStateRelay.value {
            self.selectRow(at: .init(row: indexPath.row, section: 0), animated: false, scrollPosition: .none)
        }
        return cell
    }
    
    // MARK: - delegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < items.value.count else {
            return
        }

        let cellViewModel = items.value[indexPath.row]
        modelSelected.onNext(cellViewModel)
        cellViewModel.selecteStateRelay.accept(true)
    }
    
    
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard indexPath.row < items.value.count else {
            return
        }
        
        let cellViewModel = items.value[indexPath.row]
        cellViewModel.selecteStateRelay.accept(false)
        modelDeselected.onNext(cellViewModel)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return config.fixedRowHeight > 0.0 ? config.fixedRowHeight : UITableViewAutomaticDimension
    }
}


