//
//  TTCustomTableView.swift
//  ActiveLabel
//
//  Created by hong on 2023/1/6.
//

import Foundation

open class TTBussinessTableViewController<T: TTBussinessListViewModel>: TTBussinessListBasicViewController<T>{
    open override func setupUI() {
        super.setupUI()
        mainListView = TTTableView { config in
             config.cellTypes = [TTBussinessTableViewCell.self]
         }
        addSubView(mainListView)
        mainListView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    open override func setupEvents() {
        super.setupEvents()
        
        // 数据源绑定
        viewModel.items.asDriver(onErrorJustReturn: [])
            .drive((mainListView as! TTTableView).rx.items(cellIdentifier:TTBussinessTableViewCell.className, cellType: TTBussinessTableViewCell.self)) { tableView, viewModel, cell in
                cell.backgroundColor = .random
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)
    }
}



//extension TTBussinessTableViewController: UITableViewDelegate,UITableViewDataSource {
//    // MARK: - dataSource
//    public func numberOfRows(inSection section: Int) -> Int {
//        return 1
//    }
//
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.viewModel.items.value.count
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(mainListView.config.cellTypes.first!) as String, for: indexPath) as! TTBussinessTableViewCell
//        let cellViewModel = viewModel.items.value[indexPath.row]
//        cell.bindViewModel(cellViewModel)
//        // 选中状态变更
//        if cellViewModel.selecteStateRelay.value {
//            mainListView.selectRow(at: .init(row: indexPath.row, section: 0), animated: false, scrollPosition: .none)
//        }
//        return cell
//    }


// MARK: - delegate
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard indexPath.row < viewModel.items.value.count else {
//            return
//        }
//
//        let cellViewModel = viewModel.items.value[indexPath.row]
//        modelSelected.onNext(cellViewModel)
//        cellViewModel.selecteStateRelay.accept(true)
//    }
//
//    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        guard indexPath.row < viewModel.items.value.count else {
//            return
//        }
//
//        let cellViewModel = viewModel.items.value[indexPath.row]
//        cellViewModel.selecteStateRelay.accept(false)
//        modelDeselected.onNext(cellViewModel)
//    }
//
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.tableView.config.fixedRowHeight > 0.0 ? self.tableView.config.fixedRowHeight : UITableView.automaticDimension
//    }
//}

//
//public extension TTSingleCellTypeTableView {
//    func insertData(_ viewModel: TTVersatileTableViewCellViewModel,_ indexPath: IndexPath) {
//        if #available(iOS 11.0, *) {
//              performBatchUpdates({
//                  var data = items.value
//                  data.insert(viewModel, at: 0)
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
//
//    func insertData(_ viewModel: TTVersatileTableViewCellViewModel,_ indexPath: IndexPath,_ maxCount: Int) {
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
//}
