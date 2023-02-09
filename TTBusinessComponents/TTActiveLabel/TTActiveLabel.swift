//
//  TTActiveswift
//  TTUIKit
//
//  Created by 　hong on 2022/12/12.
//

import Foundation
import ActiveLabel

open class TTActiveLabel: ActiveLabel {
    public required init(contents: [NSString],globalTextColor: UIColor = .black,hilightTextColor: UIColor = rgba(119, 145, 226, 1),_ underLine: Bool = false,font: UIFont = .regular(16),_ clickContent: @escaping (String,Int) -> ()) {
        super.init(frame: .zero)
        numberOfLines = 1
        textColor = globalTextColor
        self.font = font
        let parttenStr = NSMutableString()
        contents.forEach { subStr in
            parttenStr.append((subStr as String) + ((subStr == contents.last) ? "" : "|"))
        }
        let customType = ActiveType.custom(pattern: parttenStr as String) //Regex that looks for "with"
        enabledTypes = [customType]
        customColor[customType] = hilightTextColor
        configureLinkAttribute = {type,_,_ in
            var attDic = [NSAttributedString.Key : Any]()
            attDic[NSAttributedString.Key.font] = font
            attDic[NSAttributedString.Key.foregroundColor] = hilightTextColor
            if underLine {
                attDic[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
            }
            return attDic
        }
        
        handleCustomTap(for: customType) { element in
            let index = contents.firstIndex(of: element as NSString)!
            clickContent(element,index)
        }
    }
   
   public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
