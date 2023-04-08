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

import RxRelay
import RxSwift
import HandyJSON
import RxCocoa

class ViewController: TTViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        
    }
    
    // 热更
    @objc func injected() {
        view.removeSubviews()
        setupUI()
    }
}


// 根据配置对象去设置TextView
class TTPickerViewConfig: NSObject {

    // 文本字体
    var textFont = UIFont.regular(16)

    // 光标颜色
    var textColor = UIColor.black

    // 文本排列方式,默认居中
    var textAlignment = NSTextAlignment.center
    
    // 选中背景色
    var selectedBackGroundColor = UIColor.gray
    
    // 行高
    var rowHegiht = 18.0
    
    var rowWidht = 50.0
}



// 弹框控制器
class TTUserInfoEditAlertController: TTAlertController {
    
}



// 用户信息弹框
class TTUserInfoEditPickerAlert<T: HandyJSON>: TTAlert,TTBussinessBasicComponentsProtocol,UIPickerViewDataSource,UIPickerViewDelegate {
    
    let viewModel: TTPickerViewModel<T>
    let pickerView = UIPickerView()
    var pickerConfig = TTPickerViewConfig()
    
    init(_ customViewModel: TTPickerViewModel<T>?,_ alertCustomize: ((TTAlertCustomizeConfig) -> Void)? = nil,_ pickerConfigure: ((_ config: TTPickerViewConfig) -> Void)? = nil) {
        if let customViewModel = customViewModel {
            self.viewModel = customViewModel
        }else {
            self.viewModel = .init()
        }
        
        // 传入配置
        pickerConfigure?(pickerConfig)
        super.init(alertCustomize, eventHandler: nil)
    }
    
    
    override func setupUI() {
        super.setupUI()
        
        // 添加子视图
        addSubviews([titleLabel,pickerView,segementLine,subButton,mainButton])
        
        // config
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    override func setupEvents() {
        super.setupEvents()
        let sureTrigger = mainButton.rx.controlEvent(.touchUpInside).asDriver()
        let input = TTPickerViewModel<T>.Input(sureTrigger: sureTrigger)
        let output = viewModel.transform(input: input)
    }
    
    
    // MARK: - delegate && dataSource
    // MARK: - 几列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.items.value.count
    }
    
    // 几行
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let rowItems = viewModel.items.value[component]
        return rowItems.count
    }
    
    // MARK: - 没个选项卡多高
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100.0
    }
    
    // MARK: - 选中了哪行
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let rowItems = viewModel.items.value[component]
        guard rowItems.count > row else {
            return
        }
        
        // 设置当前选中的modelItem
        viewModel.currentItem = rowItems[row]
    }
    
    // MARK: - picker详细内容
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let reusingView = view {
            return reusingView
        } else {
            let rowItems = viewModel.items.value[component]
            guard rowItems.count > row else {
                return UIView()
            }
            
            let item = rowItems[row] as! TTPickerModel
            let label = UILabel()
            label.config(font: pickerConfig.textFont, textColor: pickerConfig.textColor, text: item.title, alignment: pickerConfig.textAlignment, numberOfline: 1)
            return label
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}








class TTPickerModel: HandyJSON {
    let title = "标题"
    
    required init() {
        
    }
}

class TTPickerViewModel<T: HandyJSON>: TTViewModel,TTViewModelOperationProtocol {
    // 数据源,默认都是二维数组的
    let items = BehaviorRelay<[[T]]>.init(value: [[]])
    
    // 当前选中
    let currentItemRelay = BehaviorRelay<T?>.init(value: nil)
    var currentItem: T? {
        set {
            currentItemRelay.accept(newValue)
        }
        get {
            return currentItemRelay.value
        }
    }
    
    // 保存完毕
    let saveComplete = PublishSubject<T>.init()
    
    
    // 输入事件信号
    struct Input {
        let sureTrigger: Driver<Void>
    }
    
    // 输出信号
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        input.sureTrigger.drive(onNext: {[weak self] (_) in
            // 点击保存按钮发送保存请求
            _ = self?.savePickerResultRequest().subscribe(onNext: {[weak self] (_) in
                guard let currentItem = self?.currentItem else {
                    return
                }
                self?.saveComplete.onNext(currentItem)
            })
        }).disposed(by: rx.disposeBag)
        
        return Output()
    }
    
    // MARK: - 保存picker的选择结果
    func savePickerResultRequest() -> Observable<Void> {
        return .empty()
    }
}
