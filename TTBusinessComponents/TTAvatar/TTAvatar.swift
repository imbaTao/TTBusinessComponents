//
//  TTAvatar.swift
//  TTUIKit
//
//  Created by hong on 2022/12/10.
//

import Foundation
import Kingfisher
import RxSwift

open class TTAvatar: TTControll {
    open class Config: NSObject {
        public var avatarUrlPath: String?
        public var placeHolder: UIImage = TTAvatar.globalPlaceHolder
        public var cornerRadius: CGFloat = 0.0
        public var contentMode: UIView.ContentMode = .scaleAspectFill
        public var borderColor: UIColor?
        public var borderWidth = CGFloat.onePixel
        public var userEnable = false
    }
    
    // 默认全局占位图片
    static var globalPlaceHolder = TTIcons.test()
    public var config = Config()
    public let icon = UIImageView()
    
    public init(image: UIImage? = TTIcons.test(),configuration: ((TTAvatar.Config) -> ())? = nil) {
        super.init(frame: .zero)
        icon.image = image
        configuration?(config)
        setupUI()
    }
    
    open override func setupUI() {
        addSubviews([icon])
        
        // config
        layer.masksToBounds = true
        updateConfig()
        
        // layout
        icon.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // 刷新配置的时候重新加载UI
    public func updateConfig(_ configuration: ((TTAvatar.Config) -> ())? = nil) {
        configuration?(config)
        
        // content
        contentMode = config.contentMode
        
        // border
        if config.borderColor != nil {
            borderColor = config.borderColor
            borderWidth = config.borderWidth
        }
        
        // 是否可点击
//        icon.isUserInteractionEnabled = config.userEnable
        
        // avatar
        icon.loadRemoteImage(config.avatarUrlPath,config.placeHolder)
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        // 有尺寸了
        guard frame.size.width > 0 else {
            return
        }
        
        // 避免多次赋值
        if config.cornerRadius > 0,layer.cornerRadius != config.cornerRadius {
            layer.cornerRadius = config.cornerRadius
        }else if config.cornerRadius == 0,layer.cornerRadius != self.frame.size.width / 2.0 {
            layer.cornerRadius = self.frame.size.width / 2.0
        }
    }
    
    // 加载远端图片
   public func loadRemoteImage(_ urlStr: String?,_ placeHolder: UIImage? = nil) {
        icon.loadRemoteImage(urlStr,placeHolder)
    }
   public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension UIImageView {
    func loadRemoteImage(_ urlStr: String?,_ placeHolder: UIImage? = nil) {
        guard  let urlStr = urlStr,urlStr.count > 0,let avatarUrl = URL(string: urlStr) else {
            return
        }
        
        self.kf.setImage(with: avatarUrl, placeholder: placeHolder, options: nil) { result in
//                switch result {
//                case .success(let result):
//                    loadImageComplete?(0,"获取图片成功",result.image)
//                case .failure(let error):
////                    loadImageComplete?(error.errorCode,error.errorDescription,nil)
//                }
        }
    }
    
}

public extension Reactive where Base: UIImageView {
    var urlImage: Binder<(UIImage?,String)> {
        return Binder(
            self.base) { base,tuple in
                let placeholderImage = tuple.0
                let avatarUrl = URL.init(string: tuple.1)
                base.kf.setImage(
                    with: avatarUrl,
                    placeholder: placeholderImage,
                    options: [],
                    progressBlock: nil,
                    completionHandler: { (result) in })
            }
    }
}
