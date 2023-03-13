//
//  TTBussinessTableViewCell.swift
//  TTBusinessComponents
//
//  Created by 　hong on 2023/2/10.
//

import Foundation
import RxSwift

open class TTBussinessTableViewCell: TTTableViewCell,TTBussinessBasicComponentsProtocol {
    public var cellDisposeBag = DisposeBag()
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        cellDisposeBag = DisposeBag()
    }
    
    open func bind(to viewModel: TTBussinessListCellViewModel) {
        cellDisposeBag = DisposeBag()
        viewModel.titleRelay.filterNil().bind(to: titleLabel.rx.text).disposed(by: cellDisposeBag)
        viewModel.subTitleRelay.filterNil().bind(to: subTitleLabel.rx.text).disposed(by: cellDisposeBag)
        
        // 主图
        viewModel.iconRelay.filterNil().bind(to: icon.rx.image).disposed(by: cellDisposeBag)
        viewModel.iconUrlRelay.filterNil().map({ urlStr in
            return (nil,urlStr)
        }).bind(to: icon.rx.urlImage).disposed(by: cellDisposeBag)
        
        // 子图片
        viewModel.subIconRelay.filterNil().bind(to: subIcon.rx.image).disposed(by: cellDisposeBag)
        viewModel.subIconUrlRelay.filterNil().map({ urlStr in
            return (nil,urlStr)
        }).bind(to: subIcon.rx.urlImage).disposed(by: cellDisposeBag)
        
        // 头像
        viewModel.avatarUrlRelay.filterNil().map({ urlStr in
            return (nil,urlStr)
        }).bind(to: avatar.icon.rx.urlImage).disposed(by: cellDisposeBag)
    }
}
