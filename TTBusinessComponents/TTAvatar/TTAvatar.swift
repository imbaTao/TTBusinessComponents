//
//  TTAvatar.swift
//  TTUIKit
//
//  Created by hong on 2022/12/10.
//

import Foundation
import Kingfisher

open class TTAvatar: UIImageView {
    private var iRadius: CGFloat = 0.0
    public init(image: UIImage? = TTIcons.test(),avatarUrlPath: String? = nil,placeHolder: UIImage? = nil,radius: CGFloat = 0.0,contentMode: UIViewContentMode = .scaleAspectFill,loadImageComplete: ((Int,String?,UIImage?) -> ())? = nil) {
        super.init(image: image)
        iRadius = radius
        self.contentMode = contentMode
        self.layer.masksToBounds = true
        
        // if have url,then kingfisher request
        if let avatarUrlPath = avatarUrlPath,let avatarUrl = URL(string: avatarUrlPath) {
            kf.setImage(with: avatarUrl, placeholder: placeHolder, options: nil) { result in
                switch result {
                case .success(let result):
                    loadImageComplete?(0,"获取图片成功",result.image)
                case .failure(let error):
                    loadImageComplete?(error.errorCode,error.errorDescription,nil)
                }
            }
        }
    }
    
    func test() {
        let v = UIImageView()
       
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        // 有尺寸了
        guard frame.size.width > 0 else {
            return
        }
        
        // 避免多次赋值
        if iRadius > 0,layer.cornerRadius != iRadius {
            layer.cornerRadius = iRadius
        }else if layer.cornerRadius != self.frame.size.width / 2.0 {
            layer.cornerRadius = self.frame.size.width / 2.0
        }
    }
    
   public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

