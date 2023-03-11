//
//  TTCountDownButton.swift
//  TTUIKit
//
//  Created by hong on 2022/12/10.
//

import Foundation
import RxSwift
import RxRelay


open class TTCountDownButton: TTButton {
    // 原始数
    let sourceCountDown: Int
    
    // 倒计时数
    var countDown = 0
    
    // 倒计时过程
    public let countDownAction = PublishSubject<Int>()
    required public init(_ configBlock: ((inout TTButtonConfig) -> ())? = nil,countDown: Int) {
        sourceCountDown = countDown
        super.init(configBlock)
        countDownAction.map{$0 == 0}.bind(to: rx.isEnabled).disposed(by: rx.disposeBag)
//        startCountDown()
    }
    
    open override func setupEvents() {
        super.setupEvents()
        rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in guard let self = self else { return }
            self.startCountDown()
        }).disposed(by: rx.disposeBag)
    }
    
    var timerDisposeBag = DisposeBag()
   public final func startCountDown() {
        timerDisposeBag = DisposeBag()
        countDown = sourceCountDown
        TTTimer.shared.creatCustomTimer(milliseconds: 1000).subscribe(onNext: {[weak self] (_) in guard let self = self else { return }

            // 倒计时
            self.countDown -= 1
            
            // 报告时间
            self.countDownAction.onNext(self.countDown)
            
            if self.countDown == 0 {
                self.timerDisposeBag = DisposeBag()
            }
        }).disposed(by: timerDisposeBag)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required public init(_ configBlock: ((inout TTButtonConfig) -> ())? = nil) {
        fatalError("init(_:) has not been implemented")
    }
}

