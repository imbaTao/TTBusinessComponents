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

import SwiftDate

class ViewController: TTViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        injected()
    }
    
    override func setupUI() {
        super.setupUI()
        
    }
    
    // 热更
    @objc func injected() {
        view.removeSubviews()
        setupUI()
        
        dismissAllPresentVC(true)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            
            
//            let firstModel = TestModel()
//            firstModel.isSelected = true
//            firstModel.items = [
//                TestModel(),
//                TestModel(),
//                TestModel(),
//                TestModel(),
//                TestModel(),
//            ]
//
//            let secondModel = TestModel()
//            secondModel.items = [
//                TestModel(),
//                TestModel(),
//            ]
//
//
//            let alertVC = TTUserInfoEditAlertController.init(items: [
//                firstModel,
//                secondModel,
//            ])
//
//            self.presentAlertViewController(alertVC)
            
            
            let alertVC = TTDateAlertController()
            self.presentAlertViewController(alertVC)
        }
    }
}

class TTDateAlertViewModel<T: TTPickerModelProtocol>: TTPickerViewModel<T> {
    let selectedDateRelay = BehaviorRelay<Date>.init(value: Date())
    
    // 由于要满足18岁，顾-18
    let currentDate = Date.init(year: Date().year - 18, month: Date().month, day: Date().day, hour: Date().month, minute: Date().hour)
    
    // 默认选中的数据
    var defaultDate: Date!
    
    // 保存的时候要请求服务器地址
    override func savePickerResultRequest() -> Observable<Void> {
        return Observable<Void>.just(()).delay(.milliseconds(2000), scheduler: MainScheduler.instance)
    }
}

class TTDateAlertController: TTViewController, TTAlertControllerProtocol{
    var alert: TTUIKit.TTAlert
   
    init(_ defaultDate: Date = .init(year: Date().year - 18, month: Date().month, day: Date().day, hour: Date().month, minute: Date().hour)) {
        let alertViewModel = TTDateAlertViewModel<DateModel>()
        alertViewModel.defaultDate = defaultDate
        alertViewModel.selectedDateRelay.accept(defaultDate)
        
        // 准备数据源
        let currentDate =  Date()
        let currentYear = currentDate.year
        let minYear = 1900
        let maxYear = currentYear - 18
        
        let yearModels = Array(minYear...maxYear).map { year in
            let dateModel = DateModel()
            dateModel.year = year
            dateModel.title = "\(year)年"
            return dateModel
        }
        
        alertViewModel.items.accept(yearModels)
        alert = TTDatePickerAlert.init(alertViewModel,{ alertConfig in
            alertConfig.portraitSize = .init(width: .screenWidth, height: 300)
        }, { pickerConfig in
            pickerConfig.rowWidht = 50
            pickerConfig.rowHegiht = 50
        })
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAlert()
    }

    override func setupUI() {
        super.setupUI()
        let alert = alert as! TTDatePickerAlert<DateModel>
        
        // config
        alert.titleLabel.text = "你的生日"
        
        let alertViewModel = alert.viewModel as! TTDateAlertViewModel
        let year = alertViewModel.defaultDate.year
        let month = alertViewModel.defaultDate.month
        let day = alertViewModel.defaultDate.day
        
        if let yearIndex = alert.viewModel.items.value.firstIndex(where: { dateModel in
            return dateModel.year == year
        }) {
           alert.pickerView.selectRow(yearIndex, inComponent: 0, animated: false)
           alert.pickerView.selectRow(month - 1, inComponent: 1, animated: false)
           alert.pickerView.selectRow(day - 1, inComponent: 2, animated: false)
           
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                alert.pickerView.reloadAllComponents()
            }
       }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class TTDatePickerAlert<T: DateModel> : TTUserInfoEditPickerAlert<T> {
    override func setupUI() {
        super.setupUI()
    }
    
    
    // MARK: - delegate && dataSource
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let viewModel = viewModel as! TTDateAlertViewModel
        switch component {
        case 0:
            return viewModel.items.value.count
        case 1:
            let selctedYearRowIndex = pickerView.selectedRow(inComponent: 0)
            let year = viewModel.items.value[selctedYearRowIndex].year
            if year == viewModel.currentDate.year {
                return viewModel.currentDate.month
            }else{
                return 12
            }
        case 2:
            // 判断选中年
            let selctedYearRowIndex = pickerView.selectedRow(inComponent: 0)
            let year = viewModel.items.value[selctedYearRowIndex].year
            
            // 选中月
            let selctedMonthRowIndex = pickerView.selectedRow(inComponent: 1)
            let month = selctedMonthRowIndex + 1
            
            // 是当前年，当前月
            if year == viewModel.currentDate.year,month == viewModel.currentDate.month {
                return viewModel.currentDate.day
            }else{
                return 31
            }
        default:
            return 0
        }
    }
    
    // MARK: - 每个选项卡多高
    override func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.bounds.size.width / 3.0
    }
    
    // MARK: - 每个选项卡多高
    override func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerConfig.rowHegiht
    }
    
    // MARK: - 选中了哪行
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var month = 0
        var day = 0
        
        pickerView.reloadComponent(1)
        pickerView.reloadComponent(2)
        
        let selctedYearRowIndex = pickerView.selectedRow(inComponent: 0)
        let year = viewModel.items.value[selctedYearRowIndex].year
        
        let selctedMonthRowIndex = pickerView.selectedRow(inComponent: 1)
        month = selctedMonthRowIndex + 1
        
        let selctedDayRowIndex = pickerView.selectedRow(inComponent: 2)
        day = selctedDayRowIndex + 1
        
    
//        switch component {
//        case 0:
//
//        case 1:
//            pickerView.reloadComponent(2)
//        default:
//            break
//        }
        
        print("选中的年月日是\(year)--\(month)--\(day)")
    }
   
    // MARK: - picker详细内容
    override func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let reusingView = view {
            return reusingView
        } else {
            let label = UILabel()
            label.config(font: pickerConfig.textFont, textColor: pickerConfig.textColor, text: "", alignment: pickerConfig.textAlignment, numberOfline: 1)
            
            switch component {
            case 0:
                label.text = viewModel.items.value[row].title
            case 1:
                label.text = "\(row + 1)月"
            case 2:
                label.text = "\(row + 1)日"
            default:
                break
            }
            return label
        }
    }
}

class DateModel: HandyJSON,TTPickerModelProtocol {
    var items: [TTPickerModelProtocol] = []
    var year = 0
    var title = "年份"
    var isSelected = false
    required init() {
    
    }
}

class TestModel: HandyJSON,TTPickerModelProtocol {
    var items: [TTPickerModelProtocol] = []
    var title = "\(arc4random()%1000) + 名字"
    var isSelected = false

    required init() {
        
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
    
    // 行宽
    var rowWidht = 50.0
    
    // 行高
    var rowHegiht = 18.0
}


protocol TTPickerModelProtocol: HandyJSON {
    var title: String {set get}
    var isSelected: Bool {set get}
    var items: [TTPickerModelProtocol] {set get}
}

class TTUserInfoEditAlertViewModel<T: TTPickerModelProtocol>: TTPickerViewModel<T> {
    // 保存的时候要请求服务器地址
    override func savePickerResultRequest() -> Observable<Void> {
        return Observable<Void>.just(()).delay(.milliseconds(2000), scheduler: MainScheduler.instance)
    }
}

class TTUserInfoEditAlertController<T: TTPickerModelProtocol>: TTViewController, TTAlertControllerProtocol{
    var alert: TTUIKit.TTAlert
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAlert()
    }
    
    init(items: [T]) {
        let alertViewModel = TTUserInfoEditAlertViewModel<T>()
        // 先传输数据源
        alertViewModel.items.accept(items)
        self.alert = TTUserInfoEditPickerAlert<T>.init(alertViewModel,{ alertConfig in
            alertConfig.portraitSize = .init(width: .screenWidth, height: 300)
        }, { pickerConfig in
            pickerConfig.rowWidht = 50
            pickerConfig.rowHegiht = 50
        })
        super.init(nibName: nil, bundle: nil)
    }
    
    override func setupUI() {
        super.setupUI()
    }
    
    override func setupEvents() {
        super.setupEvents()
        let alert = alert as! TTUserInfoEditPickerAlert<T>
        
        // 取消按钮
        alert.mainButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in guard let self = self else { return }
            self.dismissAlert()
        }).disposed(by: rx.disposeBag)
        
        // 保存完毕
        alert.viewModel.saveComplete.subscribe(onNext: {[weak self] (_) in guard let self = self else { return }
            self.dismissAlert()
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class TTBasicPickerAlert: TTAlert,TTBussinessBasicComponentsProtocol {
    let headerBar = TTView()
    var pickerView = UIPickerView()
    
    override func setupUI() {
        super.setupUI()
        headerBar.backgroundColor = .blue
        
        mainButton.backgroundColor = .red
        headerBar.addSubviews([mainButton,titleLabel,subButton])
        addSubviews([headerBar,pickerView])
        
        // config
        // config
        mainButton.updateConfig { config in
            config.titles = [.normal : "取消"]
            config.titleColors = [.normal : .black]
        }
        
        
        subButton.updateConfig { config in
            config.type = .justText
            config.titles = [.normal : "确定"]
            config.titleColors = [.normal : .black]
        }
        
        titleLabel.text = "我是标题啊"
        
        // layout
        headerBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        mainButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
        }
        
        subButton.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
        }

        pickerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerBar.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    
    override func setupEvents() {
        super.setupEvents()
        
    }
}

// 用户信息弹框
class TTUserInfoEditPickerAlert<T: TTPickerModelProtocol>: TTBasicPickerAlert,UIPickerViewDataSource,UIPickerViewDelegate {
    typealias PikerType = UIPickerView
    let viewModel: TTPickerViewModel<T>
    
    var pickerConfig = TTPickerViewConfig()
    init(_ customViewModel: TTPickerViewModel<T>? = nil,_ alertCustomize: ((TTAlertCustomizeConfig) -> Void)? = nil,_ pickerConfigure: ((_ config: TTPickerViewConfig) -> Void)? = nil) {
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
        
        // config
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // 遍历
        var selctedComponentIndex = 0
        var selectedRowIndex = 0
        for (componentIndex, rowItem) in viewModel.items.value.enumerated() {
            if let rowIndex = rowItem.items.firstIndex(where: { item in
                return item.isSelected
            }) {
                selctedComponentIndex = componentIndex
                selectedRowIndex = rowIndex
                break
            }
        }
        pickerView.selectRow(selectedRowIndex, inComponent: selctedComponentIndex, animated: false)
    }
    
    override func setupEvents() {
        super.setupEvents()
        let sureTrigger = confirmButton.rx.controlEvent(.touchUpInside).asDriver()
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
        if component == 0 {
            return viewModel.items.value.count
        }else {
            let selectedProvince = pickerView.selectedRow(inComponent: 0)
            return viewModel.items.value[selectedProvince].items.count
        }
    }
    
    // MARK: - 每个选项卡多高
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.bounds.size.width / 2.0
    }
    
    // MARK: - 每个选项卡多高
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerConfig.rowHegiht
    }
    
    // MARK: - 选中了哪行
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 定位列下标
        let selectedConpentRowIndex = pickerView.selectedRow(inComponent: 0)
        guard selectedConpentRowIndex <= viewModel.items.value.maxIndex else { return}
        
        // 先取到列item
        let componentItem = viewModel.items.value[selectedConpentRowIndex]
        guard row <= componentItem.items.maxIndex else {
            return
        }
        
        // 首列特殊处理
        if component == 0 {
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            
            // 默认选中第一行
            self.viewModel.currentItem = componentItem.items[0] as? T
        }else {
            self.viewModel.currentItem = componentItem.items[row] as? T
        }
        
     
        
        print("\(viewModel.currentItem?.title)")
    }
   
    // MARK: - picker详细内容
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let reusingView = view {
            return reusingView
        } else {
            // 先定位列
            let selectedConpentRowIndex = pickerView.selectedRow(inComponent: 0)
            guard selectedConpentRowIndex <= viewModel.items.value.maxIndex else { return UIView()}
            
            // 先取到列item
            let componentItem = viewModel.items.value[selectedConpentRowIndex]
            guard row <= componentItem.items.maxIndex  else {
                return UIView()
            }
            
            // 再对应行item
            let rowItem = componentItem.items[row]
            let label = UILabel()
            label.config(font: pickerConfig.textFont, textColor: pickerConfig.textColor, text: rowItem.title, alignment: pickerConfig.textAlignment, numberOfline: 1)
            return label
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class TTPickerViewModel<T: TTPickerModelProtocol>: TTViewModel,TTViewModelOperationProtocol {
    // 数据源,默认都是二维数组的
    let items = BehaviorRelay<[T]>.init(value: [])
    
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
