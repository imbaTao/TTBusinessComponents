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
    
    public func replaceMainList(_ newList: TTTableView) {
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
        
//        viewModel.items.asDriver(onErrorJustReturn: [])
//            .drive((mainListView as! TTTableView).rx.items(cellIdentifier:TTBussinessTableViewCell.className, cellType: TTBussinessTableViewCell.self)) { tableView, viewModel, cell in
//                cell.backgroundColor = .random
//                cell.bind(to: viewModel)
//            }.disposed(by: rx.disposeBag)
    }
    
    
    // MARK: - dataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        if mainListView.asTTTableView().style == .plain {
            return 1
        }else {
            return viewModel.items.value.count
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mainListView.asTTTableView().style == .plain {
            return viewModel.items.value.count
        }else {
            return 1
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainListView = tableView.asTTTableView()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(mainListView.config.cellTypes.first!) as String, for: indexPath) as! TTBussinessTableViewCell
        let cellViewModel = viewModel.items.value[indexPath.row]
        cell.bind(to: cellViewModel)
        if cellViewModel.selecteStateRelay.value {
            tableView.selectRow(at: .init(row: indexPath.row, section: 0), animated: false, scrollPosition: .none)
        }
        return cell
    }
  
    
    // MARK: - delegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.items.value.count else {
            return
        }

        let cellViewModel = viewModel.items.value[indexPath.row]
        cellViewModel.selecteStateRelay.accept(false)
        viewModel.modelDeselectTrigger.onNext(cellViewModel)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.items.value.count else {
            return
        }

        let cellViewModel = viewModel.items.value[indexPath.row]
        cellViewModel.selecteStateRelay.accept(true)
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
//    func insertData(_ cellViewModel: TTBussinessListCellViewModel,_ indexPath: IndexPath) {
//        let mainListView = mainListView.asTTTableView()
//        if #available(iOS 11.0, *) {
//            mainListView.performBatchUpdates({
//                var data = viewModel.items.value
//                  data.insert(cellViewModel, at: 0)
//                viewModel.items.accept(data)
//                mainListView.insertRows(at: [indexPath], with: .bottom)
//              }, completion: { [weak self]  (_) in guard let self = self else { return }
//                  mainListView.reloadData();
//              })
//        } else {
//              // Fallback on earlier versions
//            mainListView.beginUpdates();
//            mainListView.insertRows(at: [indexPath], with: UITableView.RowAnimation.bottom)
//            mainListView.endUpdates();
//            mainListView.reloadData();
//        }
//    }

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
            
//                if isPlainStyle {
//                    mainListView.deleteRows(at: [.init(row: 0, section: 0)], with: .none)
//                }else {
//                    mainListView.deleteSections(IndexSet(integer: 0), with: .none)
//                }
//
//
//                if isPlainStyle {
//                    mainListView.insertRows(at: insetIndexPath, with: .bottom)
//                }else {
//                    mainListView.insertSections(IndexSet(integer: data.maxIndex), with: .bottom)
//                }
        }else {
//                if isPlainStyle {
//                    mainListView.insertRows(at: insetIndexPath, with: .bottom)
//                }else {
//                    mainListView.insertSections(IndexSet(integer: data.maxIndex), with: .bottom)
//                }
        }
        viewModel.items.accept(data)
//        func disposeData() {
//
//        }
        
        // 末尾添加
//        if #available(iOS 11.0, *) {
//            mainListView.performBatchUpdates({
//                disposeData()
//              }, completion: { [weak self]  (_) in guard let self = self else { return }
////                  mainListView.reloadData();
//              })
//        } else {
//              // Fallback on earlier versions
//            mainListView.beginUpdates();
//            disposeData()
//            mainListView.insertRows(at: insetIndexPath, with: UITableView.RowAnimation.bottom)
//            mainListView.endUpdates();
//            mainListView.reloadData();
        }
        
        
        
//        if #available(iOS 11.0, *) {
//              performBatchUpdates({
//                  var data = items.value
//                  data.insert(viewModel, at: indexPath.row)
//                  if data.count > maxCount {
//                      deleteRows(at: [.init(row: 0, section: 0)], with: .bottom)
//                      data = data.suffix(maxCount)
//                  }
//
//                  items.accept(data)
//                  insertRows(at: [indexPath], with: .bottom)
//              }, completion: { [weak self]  (_) in guard let self = self else { return }
//                  self.reloadData();
//              })
//        } else {
//              // Fallback on earlier versions
//              beginUpdates();
//              insertRows(at: [indexPath], with: UITableView.RowAnimation.bottom)
//              endUpdates();
//              reloadData();
//        }
//    }
}
