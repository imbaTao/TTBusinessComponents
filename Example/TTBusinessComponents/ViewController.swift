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
class ViewController: TTViewController {
    
    let dataSource = [1,2,3]
    
//    var myTableView: TTTableView!
    var myList = TTSingleCellTypeTableView<MyCell> { config in
        config.fixedRowHeight = 300
    }
//
//    let myList = TTSingleCellTypeCollectionView<MyCell>.init { config in
//        config.itemSize = CGSize(width: 350, height: 350)
//
//    }

    lazy var cellModels: PublishSubject<[TTTableViewCellViewModel]> = {
 
        let cellModels = PublishSubject<[TTTableViewCellViewModel]>()
        return cellModels
    }()
    override func setupUI() {
        super.setupUI()
        
        addSubView(myList)
        myList.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        cellModels.bind(to: myList.items).disposed(by: rx.disposeBag);
    }
    
    override func setupEvents() {
        super.setupEvents()
        
        let model1 = TTTableViewCellViewModel()
        model1.titleRelay.accept("我是标题1")
        
        let model2 = TTTableViewCellViewModel()
        model2.titleRelay.accept("我是标题2")
        
        let model3 = TTTableViewCellViewModel()
        model3.titleRelay.accept("我是标题2")
        
        let model4 = TTTableViewCellViewModel()
        model4.titleRelay.accept("我是标题2")
        let model5 = TTTableViewCellViewModel()
        model5.titleRelay.accept("我是标题2")
        
        cellModels.onNext([model1,model2,model3,model4,model5])
        
        myList.modelSelected.subscribe(onNext: {[weak self] (model) in guard let self = self else { return }
            print(model.titleRelay.value)
        }).disposed(by: rx.disposeBag)
        
        myList.modelDeselected.subscribe(onNext: {[weak self] (model) in guard let self = self else { return }
            print("反选" + (model.titleRelay.value ?? ""))
        }).disposed(by: rx.disposeBag)
    }
    
    
    
//    @objc func injected() {
//        print("123123");
//
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
//    override func bindViewModel(_ viewModel: TTTableViewCellViewModel) {
//        super.bindViewModel(viewModel)
//        viewModel.titleRelay.bind(to: titleLable.rx.text).disposed(by: cellDisposeBag);
//    }
//}

class MyCell: TTTableViewCell {
    override func setupUI() {
        super.setupUI()
        titleLabel.backgroundColor = .random

        let tempButton = TTButton.singleStatus()
        tempButton.setTitle("123", state: .normal)

        addSubview(tempButton)
        tempButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSizeMake(50, 50))
        }
        tempButton.backgroundColor = .red

        tempButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in guard let self = self else { return }
            print("输出了11")
        }).disposed(by: rx.disposeBag)

        titleLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()

            make.height.equalTo(150);
        }
    }
}
