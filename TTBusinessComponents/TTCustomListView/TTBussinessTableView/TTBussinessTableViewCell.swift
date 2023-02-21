//
//  TTBussinessTableViewCell.swift
//  TTBusinessComponents
//
//  Created by 　hong on 2023/2/10.
//

import Foundation
import RxSwift

open class TTBussinessTableViewCell: TTTableViewCell,TTBussinessBasicComponentsProtocol,TTBussinessListCellProtocol {
    public var cellDisposeBag = DisposeBag()
    
    public lazy var titleLabel: UILabel = {
        var titleLabel = UILabel.regular(size: 16, textColor: .black0, text: "", alignment: .left)
        return titleLabel
    }()
    
    public lazy var subTitleLabel: UILabel = {
         var subTitleLabel = UILabel.regular()
         return subTitleLabel
     }()
     
     public lazy var icon: UIImageView = {
         var icon = UIImageView.idle()
         return icon
     }()
     
     public lazy var subIcon: UIImageView = {
         var subIcon = UIImageView.idle()
         return subIcon
     }()
     
     public lazy var arrowIcon: UIImageView = {
         var arrowIcon = UIImageView.idle()
         return arrowIcon
     }()
     
     public lazy var avatar: TTAvatar = {
         var avatar = TTAvatar()
         return avatar
     }()
    
    public lazy var segementLine: UIView = {
        let segementLine = UIView.colorView(rgba(223, 223, 223, 0.5))
        return segementLine
    }()
  
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
        }).bind(to: avatar.rx.urlImage).disposed(by: cellDisposeBag)
    }
}
