//
//  TTVersatileCollectionViewCell.swift
//  ActiveLabel
//
//  Created by hong on 2023/1/6.
//

import Foundation
import RxSwift
import RxRelay
import TTUIKit

open class TTVersatileCollectionViewCell : TTCollectionViewCell {

    lazy var subTitleLabel: UILabel = {
        var subTitleLabel = UILabel.regular()
        return subTitleLabel
    }()
    
    lazy var icon: UIImageView = {
        var icon = UIImageView.idle()
        return icon
    }()
    
    lazy var subIcon: UIImageView = {
        var subIcon = UIImageView.idle()
        return subIcon
    }()
    
    lazy var arrowIcon: UIImageView = {
        var arrowIcon = UIImageView.idle()
        return arrowIcon
    }()
    
    lazy var avatar: TTAvatar = {
        var avatar = TTAvatar()
        return avatar
    }()

    open override func bindViewModel(_ viewModel: TTCollectionViewCellViewModel) {
        guard let cellViewModel = viewModel as? TTVersatileTableViewCellViewModel else {
            return
        }
        
        if self.responds(to: #selector(self.bindModel(_:))) {
            bindModel(cellViewModel.model)
        }else {
            super.bindViewModel(viewModel)
        }
    }

    @objc open func bindModel(_ model: NSObject) {
        
    }
}
