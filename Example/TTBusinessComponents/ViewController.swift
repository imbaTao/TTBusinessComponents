//
//  ViewController.swift
//  TTUIKit
//
//  Created by imbatao@outlook.com on 12/07/2022.
//  Copyright (c) 2022 imbatao@outlook.com. All rights reserved.
//

import UIKit
import TTUIKit
import TTBusinessComponents

import RxSwift

class CreatLiveViewModel: TTViewModel,TTViewModelOperationProtocol {
    typealias TTModel = DataModel
    
    struct Input {
        let creatRoomTrigger: Observable<Void>
    }
    
    struct Output {
        let creatRoomResult: Observable<NSObject>
    }
    
    func transform(input: Input) -> Output {
        let creatResult = input.creatRoomTrigger.map { _ in
            return NSObject()
        }
        
        return .init(creatRoomResult: creatResult)
    }
    
    func creatRoomRequest() -> Observable<NSObject> {
        return Observable<Void>.empty().map { _ in
            return NSObject()
        }
    }

}

class CreatLive: TTViewModelController<CreatLiveViewModel> {
    
}




























class DataModel: NSObject {
    var name = "名称\(arc4random()%1000)"
}

class ViewControlerViewModel: TTBussinessListViewModel,TTViewModelOperationProtocol {
    struct Input {
        let joinAction: Observable<Void>
        let roomSelection: Observable<TTBussinessListCellViewModel>
    }
    
    struct Output{
        let joinActionEnd: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let joinActionEnd = input.joinAction.flatMap({ _ -> Observable<String>  in
            return  Observable<String>.just("123")
        })
        
        return .init(joinActionEnd: joinActionEnd)
    }
    
    override func headerRefreshRequest() -> Observable<[TTBussinessListCellViewModel]> {
        return Observable<[TTBussinessListCellViewModel]>.just([
            .init(DataModel()),
            .init(DataModel()),
            .init(DataModel()),
            .init(DataModel()),
            .init(DataModel()),
            .init(DataModel()),
            .init(DataModel()),
        ])
    }
}

class ViewController: TTBussinessCollectionController<ViewControlerViewModel> {
    var tempView1: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        let mainListView = mainListView as! TTConnectionView
        mainListView.updateConfig { config in
            let cellWidth = (CGFloat.screenWidth - 12 * 2 - 8) / 2
            let cellHeight = cellWidth
            config.itemSize = .init(width: cellWidth, height: cellHeight)
            config.horizotalSpacing = 5
            config.verticalSpacing = 5
            config.cellTypes = [TTBussinessCollectionViewCell.self]
        }
        
        tempView1 = UIButton.regular(size: 18, textColor: .white, text: "我是测试按钮")
        tempView1.backgroundColor = .gray
        self.view.addSubview(tempView1)
        tempView1.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
        
        
        // 添加头
        addRefreshHeader()
        addRefreshFooter()
    }
    
    override func setupEvents() {
        super.setupEvents()
        
        // 加入事件
        let joinActon = tempView1.rx.controlEvent(.touchUpInside).asObservable()
        
        
        let mainListView = mainListView as! TTConnectionView
        let intput = ViewControlerViewModel.Input.init(joinAction: joinActon, roomSelection: viewModel.modelSelectedTrigger)
        let output = viewModel.transform(input: intput)
        output.joinActionEnd.subscribe(onNext: {[weak self] (_) in guard let self = self else { return }
            print("输出了")
        }).disposed(by: rx.disposeBag)
        
    }
    
//    @objc func injected() {
//        view.backgroundColor = .white
//        view.removeSubviews()
//
////        let inputBar = TTAuthCodeInputBar<MyInputItem>(inputItemCount: 5)
////        inputBar.inputComplete = { _ in
////            print("输入完成了！")
////        }
////        inputBar.backgroundColor = .orange
////        addSubView(inputBar)
////        inputBar.snp.makeConstraints { (make) in
////            make.centerX.equalToSuperview()
//////            make.width.equalTo(300)
////            make.centerY.equalToSuperview()
////        }
////
////        let view = UITextField()
////        view.backgroundColor = .red
////        addSubView(view)
////
////        view.snp.makeConstraints { (make) in
////            make.top.equalTo(200)
////            make.centerX.equalToSuperview()
////            make.size.equalTo(100)
////        }
//    }
    
    
//    class MyInputItem: TTAuthCodeInputBarInputItem {
//        override func didChangeState(_ state: TTAuthCodeInputBarInputItem.InputState) {
//            super.didChangeState(state)
//            switch state {
//            case .inputing:
//                addBorder(color: .blue,width: 5)
//            default:
//                borderWidth = 0
//                break
//            }
//        }
//    }
//
//
//
//    override func setupEvents() {
//        super.setupEvents()
//
////        myList.modelSelected.subscribe(onNext: {[weak self] (model) in guard let self = self else { return }
////            print(model.titleRelay.value)
////        }).disposed(by: rx.disposeBag)
////
////        myList.modelDeselected.subscribe(onNext: {[weak self] (model) in guard let self = self else { return }
////            print("反选" + (model.titleRelay.value ?? ""))
////        }).disposed(by: rx.disposeBag)
//    }
    
}

//class MyCell: TTCollectionViewCell {
//    let titleLable = UILabel.regular()
//    override func setupUI() {
//        super.setupUI()
//        contentView.addSubview(titleLable)
//        titleLable.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//        }
//
//        backgroundColor = .random
//
////        titleLabel.backgroundColor = .random
////
////        let tempButton = TTButton.singleStatus()
////        tempButton.setTitle("123", state: .normal)
////
////        addSubview(tempButton)
////        tempButton.snp.makeConstraints { (make) in
////            make.center.equalToSuperview()
////            make.size.equalTo(CGSizeMake(50, 50))
////        }
////        tempButton.backgroundColor = .red
////
////        tempButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in guard let self = self else { return }
////            print("输出了11")
////        }).disposed(by: rx.disposeBag)
//
//
//    }
//
//    override func bindViewModel(_ viewModel: TTListCellViewModel) {
//        super.bindViewModel(viewModel)
//        viewModel.titleRelay.bind(to: titleLable.rx.text).disposed(by: cellDisposeBag);
//    }
//}

//class MyCell: TTTableViewCell {
//    override func setupUI() {
//        super.setupUI()
//        titleLabel.backgroundColor = .random
//
//        let tempButton = TTButton.singleStatus()
//        tempButton.setTitle("123", state: .normal)
//
//        addSubview(tempButton)
//        tempButton.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//            make.size.equalTo(CGSizeMake(50, 50))
//        }
//        tempButton.backgroundColor = .red
//
//        tempButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in guard let self = self else { return }
//            print("输出了11")
//        }).disposed(by: rx.disposeBag)
//
//        titleLabel.snp.remakeConstraints { (make) in
//            make.centerY.equalToSuperview()
//
//            make.height.equalTo(150);
//        }
//    }
//}


struct TestModel {
    var name = ""
}
