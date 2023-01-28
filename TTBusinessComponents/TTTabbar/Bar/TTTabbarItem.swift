//
//  TTTabbarItem.swift
//  TTUIKit
//
//  Created by 　hong on 2022/12/16.
//

import Foundation
import TTUIKit

// itemCell
class TTTabbarItem: TTButton {

//    // 图标
//    let itemIcon = UIImageView.idle()
//
//    // 内容
//    let itemContent = UILabel()

//    // badage
//    lazy var badge: TTBadge = {
//        var badge = TTBadge.init(padding: .init(inset: 1))
//        addSubview(badge)
//        badge.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self.itemIcon.snp.right)
//            make.centerY.equalTo(self.itemIcon.snp.top)
//
//        }
//        return badge
//    }()

    // 突起视图
//    lazy var tuberView: TTTbbarItemTuberView = {
//        var tuberView = TTTbbarItemTuberView.init(
//            drawSourceRect: CGRect.init(x: 0, y: 0, width: self.bounds.width, height: 12),
//            drawFillColor: .white, drawBorderWidth: 0.5)
//        self.contentView.addSubview(tuberView)
//        tuberView.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.bottom.equalTo(self.contentView.snp.top)
//            make.height.equalTo(12)
//            make.width.equalTo(self.bounds.width)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            //            // 遮挡用的视图
//            //            var keepOutView = UIView.init()
//            //            keepOutView.backgroundColor = .white
//            //            self.contentView.addSubview(keepOutView)
//            //            self.contentView.sendSubviewToBack(keepOutView)
//            //            keepOutView.snp.makeConstraints { (make) in
//            //                make.top.equalTo(baseTabbar()!.segementLine)
//            //                make.left.right.equalToSuperview()
//            //                make.bottom.equalTo(baseTabbar()!.segementLine)
//            //            }
//        }
//
//        return tuberView
//    }()
    var itemMdodel: TTTabbarItemModel!
    init(itemMoel:TTTabbarItemModel) {
        super.init { config in
            if itemMoel.title.isEmpty {
                config.type = .justIcon
            }else {
                config.type = .iconOnTheTop
            }
            config.interval = 3
            config.titles = [
                .normal : itemMoel.title
            ]
            config.titleColors = [
                .normal : itemMoel.titleNormalColor,
                .selected : itemMoel.titleSelectedColor
            ]
            config.titleFonts = [
                .normal : itemMoel.titleNormalFont,
                .selected : itemMoel.titleSelectedFont
            ]
            config.images = [
                .normal : itemMoel.normalImage,
                .selected : itemMoel.selectedImage
            ]
        }
        self.itemMdodel = itemMoel
    }

    // 初始化UI,暂时只支持竖屏tabbar,横屏比较少见
    override func setupUI() {
        super.setupUI()
    }
    
    override func setupEvents() {
        super.setupEvents()
    }
    

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(_ configBlock: ((inout TTButtonConfig) -> ())? = nil) {
        fatalError("init(_:) has not been implemented")
    }
}

public protocol TTTabbarItemConfigProtocol {
    var titleNormalFont: UIFont {set get}
    var titleSelectedFont: UIFont  {set get}
    var titleNormalColor: UIColor  {set get}
    var titleSelectedColor: UIColor  {set get}
    var iconSize: CGSize {set get}
}

