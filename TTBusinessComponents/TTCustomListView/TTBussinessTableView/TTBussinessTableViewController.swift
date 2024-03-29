//
//  TTCustomTableView.swift
//  ActiveLabel
//
//  Created by hong on 2023/1/6.
//

import Foundation

open class TTBussinessTableViewController<T: TTBussinessListViewModel>: TTBussinessListBasicViewController<T>,UITableViewDelegate,UITableViewDataSource{
    open override func setupUI() {
        super.setupUI()
        let mainListView = TTTableView { config in
             config.cellTypes = [TTBussinessTableViewCell.self]
        }
        
        mainListView.delegate = self
        mainListView.dataSource = self
        self.mainListView = mainListView
        addSubview(mainListView)
        mainListView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 替换主列表
    public func replaceMainList(_ newList: TTTableView) {
        let oldList =  mainListView.asTTTableView()
        oldList.delegate = nil
        oldList.dataSource = nil
        oldList.removeFromSuperview()
        
        
        newList.delegate = self
        newList.dataSource = self
        mainListView = newList
    }
    
    open override func setupEvents() {
        super.setupEvents()
        
        // 数据源绑定
        viewModel.items.asDriver(onErrorJustReturn: []).drive(onNext: {[weak self] (_) in guard let self = self else { return }
            self.mainListView.asTTTableView().reloadData()
        }).disposed(by: rx.disposeBag)
    }
    
    
    // MARK: - dataSource
    open func numberOfSections(in tableView: UITableView) -> Int {
        if mainListView.asTTTableView().style == .plain {
            return 1
        }else {
            return viewModel.items.value.count
        }
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mainListView.asTTTableView().style == .plain {
            return viewModel.items.value.count
        }else {
            return 1
        }
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainListView = tableView.asTTTableView()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(mainListView.config.cellTypes.first!) as String, for: indexPath) as! TTBussinessTableViewCell
        
        
        let itemIndex = tableView.style == .plain ? indexPath.row : indexPath.section
        let cellViewModel = viewModel.items.value[itemIndex]
        
        
        
        cell.bind(to: cellViewModel)
        if cellViewModel.selecteStateRelay.value {
            tableView.selectRow(at: .init(row: indexPath.row, section: 0), animated: false, scrollPosition: .none)
        }
        return cell
    }
  
    
    // MARK: - delegate
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.items.value.count else {
            return
        }
        let itemIndex = tableView.style == .plain ? indexPath.row : indexPath.section
        let cellViewModel = viewModel.items.value[itemIndex]
        cellViewModel.selecteStateRelay.accept(true)
        viewModel.modelDeselectTrigger.onNext(cellViewModel)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.items.value.count else {
            return
        }

        let itemIndex = tableView.style == .plain ? indexPath.row : indexPath.section
        let cellViewModel = viewModel.items.value[itemIndex]
        cellViewModel.selecteStateRelay.accept(false)
        viewModel.modelSelectedTrigger.onNext(cellViewModel)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mainListView = tableView.asTTTableView()
        let config = mainListView.config
        return config.fixedRowHeight > 0.0 ? config.fixedRowHeight : UITableView.automaticDimension
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}


public extension UIScrollView {
    func asTTTableView() -> TTTableView {
        return self as! TTTableView
    }
    
    func asTTCollectionView() -> TTCollectionView {
        return self as! TTCollectionView
    }
}




public extension TTBussinessTableViewController {
    func insertDataToLast(_ cellViewModel: TTBussinessListCellViewModel,_ maxCount: Int = .max) {
        let mainListView = mainListView.asTTTableView()
        let isPlainStyle = mainListView.style == .plain
        var data = viewModel.items.value
        data.append(cellViewModel)
        
        
        let insetIndexPath = [IndexPath.init(row: isPlainStyle ? data.maxIndex : 0, section: isPlainStyle ? 0 : data.maxIndex)]
        
        let overMaxCount = data.count > maxCount
        
        if overMaxCount {
            // 移除第一个数据源
            data.removeFirst()
        }else {
            
        }
        viewModel.items.accept(data)
    }
    
    
}
