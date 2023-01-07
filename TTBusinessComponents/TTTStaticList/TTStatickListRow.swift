//
//  TTStatickListRow.swift
//  TTUIKit
//
//  Created by hong on 2022/12/18.
//

import Foundation

public protocol TTStaticRowProtocol: AnyObject {
    // 子类写block
    //    func update(_ config: (Self) -> ()) -> Self
    func asSelf() -> Self
}

public extension TTStaticRowProtocol {
    //    func update(_ config: (Self) -> ()) -> Self {
    //        return self
    //    }

    func asSelf() -> Self {
        return self
    }
}

open class TTStaticRow: TTAutoSizeView, TTStaticRowProtocol {
    // 让内从
    let rowContentView = UIView()
    let clickEventBoard = UIButton()
    
    public var contentPadding: UIEdgeInsets = .zero {
        didSet {
            rowContentView.snp.remakeConstraints { (make) in
                make.edges.equalTo(contentPadding)
            }
        }
    }

    @discardableResult
    public func padding(_ edges: UIEdgeInsets) -> Self {
        contentPadding = edges
        return self
    }

    
    // 变更行高
    private(set) var rowHeight: CGFloat = 44.0 {
        didSet {
            contentView.snp.remakeConstraints { (make) in
                make.height.greaterThanOrEqualTo(rowHeight)
            }
        }
    }
    
    @discardableResult
    public func rowHeight(_ height: CGFloat) -> Self {
        rowHeight = height
        return self
    }
         

    public lazy var backgroundImageView: UIImageView = {
        let view = UIImageView.idle()
        return view
    }()

    public lazy var leftImageView: UIImageView = {
        let view = UIImageView.idle()
        return view
    }()

    public lazy var titleLabel: UILabel = {
        let view = UILabel.regular(size: 16, textColor: .black, text: "", alignment: .left)
        return view
    }()

    public lazy var subTitleLabel: UILabel = {
        let view = UILabel.regular(size: 14, textColor: .black, text: "", alignment: .right)
        return view
    }()
    
    public lazy var rightImageView: UIImageView = {
        let view = UIImageView.idle()
        var uiImage = TTIcons.backArrowBlack().flipImage()
        uiImage = uiImage.scaled(toHeight: 25)!
        view.image = uiImage
        return view
    }()
    
    
//    public lazy var rightContentStatck: TTStackView = {
//        var rightContentStatck = TTStackView.horizontalStack()
//        rightContentStatck.spacing = 4
//        return rightContentStatck
//    }()

    public lazy var avatar: TTAvatar = {
        var avatar = TTAvatar()
        return avatar
    }()
    
    
    
    public var header: TTStaticSectionHeader? {
        didSet {
            guard let header = header else { return }
            stackView.insertArrangedSubview(header, at: 0)
            header.snp.makeConstraints { (make) in
                make.height.equalTo(header.headerHeight)
            }
        }
    }
    
    public var footer: TTStaticSectionFooter? {
        didSet {
            guard let footer = footer else { return }
            stackView.addArrangedSubview(footer)
            footer.snp.makeConstraints { (make) in
                make.height.equalTo(footer.footerHeight)
            }
        }
    }

    public lazy var segementLine: UIView = {
        let view = UIView.colorView(rgba(223, 223, 223, 0.5))
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(CGFloat.onePixel)
        }
        return view
    }()

    //  核心内容，都用字符串去表示，取值时转换
    public var value: Any = 0 {
        didSet {
            refreshUI?(self)
        }
    }

    // 更新UIBlock
    var refreshUI: ((TTStaticRow) -> Void)? = nil
//    public init () {
//        super.init(frame: .zero)
//       
//    }

    open override func setupUI() {
        super.setupUI()
        rowContentView.addSubview(clickEventBoard)
        addSubview(rowContentView)
        
        clickEventBoard.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        rowContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // config
        stackView.spacing = 0
        
    }
    
    
    open override func setupEvents() {
        clickEventBoard.addTarget(self, action: #selector(clickEvent), for: .touchUpInside)
    }
    
    private var eventBlock: (() -> Void)? = nil
    @objc func clickEvent() {
        eventBlock?()
    }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    
    }
    
    // MARK: - func
    @discardableResult
    public func selected(_ click: @escaping () -> Void) -> Self {
        eventBlock = click
        return self
    }

    public func configUI(_ block: ((TTStaticRow) -> Void)?) -> Self {
        block?(self)
        return self
    }
    
    public override func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { view in
            if view == rowContentView {
                super.addSubview(view)
            }else {
                rowContentView.addSubview(view)
            }
        }
    }
    
//    func configSegementLine(left: CGFloat = 0,right: CGFloat = 0,bottom: CGFloat = 0,height: CGFloat = 1,color: UIColor) {
//        segementLine.snp.remakeConstraints { (make) in
//            make.bottom.equalToSuperview().offset(-bottom)
//            make.left.equalTo(left)
//            make.right.equalTo(right)
//            make.height.equalTo(height)
//        }
//
//        segementLine.backgroundColor = color
//    }

}

public extension TTStaticRow {
    @discardableResult
    func title(_ text: String) -> Self {
        titleLabel.text = text
        return self
    }
    
    @discardableResult
    func titleFont(_ font: UIFont) -> Self {
        titleLabel.font = font
        return self
    }
    
    @discardableResult
    func titleColor(_ color: UIColor) -> Self {
        titleLabel.textColor = color
        return self
    }
    
    @discardableResult
    func subTitle(_ text: String) -> Self {
        subTitleLabel.text = text
        return self
    }
    
    @discardableResult
    func subTitleFont(_ font: UIFont) -> Self {
        subTitleLabel.font = font
        return self
    }
    
    @discardableResult
    func subTitleColor(_ color: UIColor) -> Self {
        subTitleLabel.textColor = color
        return self
    }
    
    
    @discardableResult
    func addHeader(_ headerConfig: (TTStaticSectionHeader) -> Void) -> Self {
        let header = TTStaticSectionHeader(headerHeight: 10)
        headerConfig(header)
        self.header = header
        return self
    }
    
    @discardableResult
    func addHeader(_ customHeader: TTStaticSectionHeader) -> Self {
        self.header = header
        return self
    }
    
    @discardableResult
    func addFooter(_ footerConfig: (TTStaticSectionFooter) -> Void) -> Self {
        let header = TTStaticSectionFooter(footerHeight: 10)
        footerConfig(header)
        self.header = header
        return self
    }
    
    func addFooter(_ footerConfig: TTStaticSectionFooter) -> Self {
        self.footer = footer
        return self
    }
    
    
    func segmentLine(_ edges: UIEdgeInsets,height: CGFloat = .onePixel,color: UIColor = .gray0) {
        segementLine.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(edges.left)
            make.bottom.equalToSuperview().offset(edges.bottom * ( edges.bottom < 0 ? 1 : -1))
            make.right.equalToSuperview().offset(edges.right * ( edges.right < 0 ? 1 : -1))
            make.height.equalTo(height)
        }
        segementLine.backgroundColor = color
    }
}


// MARK: - Header
open class TTStaticSectionHeader: TTView {

   public lazy var titleLabel: UILabel = {
        var titleLabel = UILabel.regular(size: 12, textColor: .black, text: "组标题", alignment: .left)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview()
        }
        return titleLabel
    }()
    
    public func changeLableInset(_ inset: CGFloat) {
        titleLabel.snp.remakeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.left.right.equalTo(safeAreaLayoutGuide).inset(inset)
            } else {
                make.left.right.equalTo(inset)
            }
            make.top.bottom.equalToSuperview()
        }
    }

    public init(headerHeight: CGFloat,content: String = "",lableInset: CGFloat = 12) {
        super.init(frame: .zero)
        self.headerHeight = headerHeight
        self.titleLabel.text = content
        
        
        changeLableInset(lableInset)
        changeHeaderHeight(headerHeight)
    }
    
    public func changeHeaderHeight(_ height: CGFloat) {
        snp.remakeConstraints { (make) in
            make.height.equalTo(headerHeight)
        }
    }
    
    
    public override func setupUI() {
        super.setupUI()
        self.backgroundColor = .clear
    }

    public var headerHeight: CGFloat = 12 {
        didSet {
            self.changeHeaderHeight(headerHeight)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - Footer
open class TTStaticSectionFooter: TTStaticSectionHeader {
   public var footerHeight: CGFloat {
        set {
            headerHeight = newValue
        }
        get {
            return headerHeight
        }
    }
    
    public init(footerHeight: CGFloat, content: String = "", lableInset: CGFloat = 12) {
        super.init(headerHeight: footerHeight, content: content, lableInset: lableInset)
        
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

