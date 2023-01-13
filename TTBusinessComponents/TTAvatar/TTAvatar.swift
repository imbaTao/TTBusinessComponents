//
//  TTAvatar.swift
//  TTUIKit
//
//  Created by hong on 2022/12/10.
//

import Foundation
import Kingfisher

open class TTAvatar: UIImageView {
    public struct Config {
        public var avatarUrlPath: String?
        public var placeHolder: UIImage?
        public var cornerRadius: CGFloat = 0.0
        public var contentMode: UIView.ContentMode = .scaleAspectFill
        public init(avatarUrlPath: String? = nil, placeHolder: UIImage? = nil, cornerRadius: CGFloat, contentMode: UIView.ContentMode) {
            self.avatarUrlPath = avatarUrlPath
            self.placeHolder = placeHolder
            self.cornerRadius = cornerRadius
            self.contentMode = contentMode
        }
    }
    
//    private(set)
    public var config = Config.init(cornerRadius: 0, contentMode: .scaleAspectFill) {
        didSet {
            print("我被变更了")
        }
    }
    
    public init(image: UIImage? = TTIcons.test(),configuration: ((inout TTAvatar.Config) -> ())? = nil,loadImageComplete: ((Int,String?,UIImage?) -> ())? = nil) {
        super.init(image: image)
        configuration?(&self.config)
        setupUI()
        

        // if have url,then kingfisher request
        if let avatarUrlPath = config.avatarUrlPath,let avatarUrl = URL(string: avatarUrlPath) {
            
            self.kf.setImage(with: avatarUrl, placeholder: config.placeHolder, options: nil) { result in
                switch result {
                case .success(let result):
                    loadImageComplete?(0,"获取图片成功",result.image)
                case .failure(let error):
                    loadImageComplete?(error.errorCode,error.errorDescription,nil)
                }
            }
            
//            self.kf.setImage(with: avatarUrl, placeholder: config.placeHolder, options: nil) {
//            }
        }
    }
    
    func setupUI() {
        self.layer.masksToBounds = true
        contentMode = config.contentMode
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

