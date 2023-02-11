//
//  TTBussinessCollectionViewCell.swift
//  TTBusinessComponents
//
//  Created by 　hong on 2023/2/10.
//

import Foundation
import RxSwift

open class TTBussinessCollectionViewCell: TTCollectionViewCell,TTBussinessListCellProtocol {
    public var cellDisposeBag = DisposeBag()
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
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        recycleRxDisposeBag()
    }
    
    open func bind(to viewModel: TTBussinessListCellViewModel) {
        //f 每次绑定，释放上一次绑定
        cellDisposeBag = DisposeBag()
        viewModel.titleRelay.bind(to: titleLabel.rx.text).disposed(by: cellDisposeBag);
    }
}


