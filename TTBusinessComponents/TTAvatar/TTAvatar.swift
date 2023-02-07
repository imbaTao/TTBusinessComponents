//
//  TTAvatar.swift
//  TTUIKit
//
//  Created by hong on 2022/12/10.
//

import Foundation
import Kingfisher

open class TTAvatar: UIImageView {
    open class Config: NSObject {
        public var avatarUrlPath: String?
        public var placeHolder: UIImage?
        public var cornerRadius: CGFloat = 0.0
        public var contentMode: UIView.ContentMode = .scaleAspectFill
        public var borderColor: UIColor?
        public var borderWidth = CGFloat.onePixel
    }

    public var config = Config()
    public init(image: UIImage? = TTIcons.test(),configuration: ((TTAvatar.Config) -> ())? = nil) {
        super.init(image: image)
        configuration?(config)
        setupUI()
    }
    
    func setupUI() {
        self.layer.masksToBounds = true
        refreshConfig()
    }
    
    // 刷新配置的时候重新加载UI
    public func refreshConfig(_ configuration: ((TTAvatar.Config) -> ())? = nil) {
        configuration?(config)
        
        // content
        contentMode = config.contentMode
        
        // border
        if config.borderColor != nil {
            borderColor = config.borderColor
            borderWidth = config.borderWidth
        }
        
        // avatar
        loadRemoteImage(config.avatarUrlPath)
    }
    
    public func loadRemoteImage(_ url: String?) {
        guard let url = url,let avatarUrl = URL(string: url) else {
            return
        }
        self.kf.setImage(with: avatarUrl, placeholder: config.placeHolder, options: nil) { result in
//                switch result {
//                case .success(let result):
//                    loadImageComplete?(0,"获取图片成功",result.image)
//                case .failure(let error):
////                    loadImageComplete?(error.errorCode,error.errorDescription,nil)
//                }
        }
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
    
   public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

