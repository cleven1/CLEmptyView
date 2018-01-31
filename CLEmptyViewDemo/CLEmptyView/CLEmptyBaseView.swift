//
//  CLEmptyBaseView.swift
//  CLEmptyViewDemo
//
//  Created by cleven on 2018/1/8.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit

public protocol CLEmptyBaseViewDelegate:NSObjectProtocol {
    func clickEmptyView()
    func clickFirstButton()
    func clickSecondButton()
}

public class CLEmptyBaseView: UIView {
    fileprivate let rotationAnimKey = "rotationAnimKey"
    
    /// 内容物背景视图
    fileprivate var contentView:UIView?
    /// loading view
    fileprivate var loadingView:UIView?
    fileprivate var loadingTitleLabel:UILabel?
    fileprivate var emptyImage:UIButton?
    fileprivate var titleLabel:UILabel?
    fileprivate var detailTitleLabel:UILabel?
    fileprivate var firstButton:UIButton?
    fileprivate var secondButton:UIButton?
    fileprivate var loadingImage:UIImageView?
    fileprivate var firstBtnWidth:CGFloat = 0.35
    fileprivate var secondBtnWidth:CGFloat = 0.35
    fileprivate var isGroupAnimation:Bool = false
    
    public var isLoading:Bool = true {
        didSet{
            setIsHiddenLoading = isLoading
        }
    }
    fileprivate var emptyTips:NSAttributedString?
    fileprivate var emptyImageName:String = ""
    fileprivate var loadingImageName:[String] = []
    fileprivate var loadingTips:NSAttributedString?
    fileprivate var loadingDuration:Double = 1.0
    fileprivate var detailTips:NSAttributedString?
    fileprivate var firstBtnTitle:String?
    fileprivate var firstBtnTitleColor:UIColor?
    fileprivate var firstBtnCornerRadius:CGFloat = 0
    fileprivate var firstBtnBorderColor:UIColor?
    fileprivate var firstBtnBorderWidth:CGFloat = 0
    fileprivate var firstBtnBackGroundColor:UIColor?
    fileprivate var secondBtnTitle:String?
    fileprivate var secondBtnTitleColor:UIColor?
    fileprivate var secondBtnCornerRadius:CGFloat = 0
    fileprivate var secondBtnBorderColor:UIColor?
    fileprivate var secondBtnBorderWidth:CGFloat = 0
    fileprivate var secondBtnBackGroundColor:UIColor?
    // 记录占位图的约束
    fileprivate var emptyImageX:NSLayoutConstraint!
    fileprivate var emptyImageY:NSLayoutConstraint!
    
    
    /// 事件回调
    weak public var delegate:CLEmptyBaseViewDelegate?
    
    /// 是否显示加载中动画
    public var setIsHiddenLoading:Bool = false {
        didSet{
            contentView?.isHidden = isLoading
            loadingView?.isHidden = !isLoading
            configAnmation(isGroupAnim: isGroupAnimation, isStratAnim: isLoading)
        }
    }
    
    /// 设置空界面占位图,可根据网络状态,配置不同图片
    public func setEmptyImage(imageName:String?,tips:NSAttributedString?) {
        
        emptyImage?.setImage(UIImage(named: imageName ?? emptyImageName), for: .normal)
        titleLabel?.attributedText = tips
    }
    
    
    /// 配置空界面显示信息
    ///
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - title: title
    ///   - text: 描述
    ///   - firstBtn: 如果只有一个按钮,居中显示
    ///   - secondBtn: 如果有两个按钮,左右分布
    open func setUpEmpty(imageName: String?,
                         title: NSAttributedString?,
                         text: NSAttributedString?,
                         firstBtn:UIButton?,
                         firstBtnWidth:CGFloat,
                         secondBtn:UIButton?,
                         secondBtnWidth:CGFloat) {
        config(imageName: imageName,
               title: title,
               detailTitle: text,
               firstBtn: firstBtn,
               secondBtn: secondBtn)
    }
    
    
    /// 配置loading显示信息
    ///
    /// - Parameters:
    ///   - imageName: 图片名,默然是旋转动画
    ///   - titleAttr: title
    ///   - duration: 动画时间
    open func setUpEmptyLoading(imageNames:[String],
                                titleAttr:NSAttributedString?,
                                duration:Double = 1.0){
        
        loadingView = UIView(frame: bounds)
        addSubview(loadingView!)
        
        loadingImage = UIImageView(image: UIImage(named: imageNames.first ?? ""))
        loadingImage?.contentMode = .center
        if imageNames.count > Int(1) {
            isGroupAnimation = true
            loadingImage?.animationImages = imageNames.flatMap{UIImage(named: $0)}
        }else{
            isGroupAnimation = false
        }
        loadingView?.addSubview(loadingImage!)
        
        loadingTitleLabel = UILabel()
        loadingTitleLabel?.textAlignment = .center
        loadingTitleLabel?.attributedText = titleAttr
        loadingTitleLabel?.translatesAutoresizingMaskIntoConstraints = false
        loadingView?.addSubview(loadingTitleLabel!)
        
        configLoadingViewConstraint()
    }
    
}
//MARK: 配置
public extension CLEmptyBaseView {
    
    func addEmptyImage(imageNmae:String) -> CLEmptyBaseView {
        emptyImageName = imageNmae
        return self
    }
    func addEmptyTis(tips:NSAttributedString) -> CLEmptyBaseView {
        emptyTips = tips
        return self
    }
    func addEmptyDetailTips(tips:NSAttributedString) -> CLEmptyBaseView {
        detailTips = tips
        return self
    }
    func addFirstBtnTitle(title:String) -> CLEmptyBaseView {
        firstBtnTitle = title
        return self
    }
    func addFirstBtnTitleColor(color:UIColor) -> CLEmptyBaseView {
        firstBtnTitleColor = color
        return self
    }
    func addFirstBtnCornerRadius(radius:CGFloat) -> CLEmptyBaseView {
        firstBtnCornerRadius = radius
        return self
    }
    func addFirstBtnBorderColor(color:UIColor) -> CLEmptyBaseView {
        firstBtnBorderColor = color
        return self
    }
    func addFirstBtnBorderWidth(w:CGFloat) -> CLEmptyBaseView {
        firstBtnBorderWidth = w
        return self
    }
    func addFirstBtnBgColor(color:UIColor) -> CLEmptyBaseView {
        firstBtnBackGroundColor = color
        return self
    }
    /// 基于屏幕宽度的比例
    func addFirstBtnWidth(multiplier:CGFloat) -> CLEmptyBaseView {
        firstBtnWidth = multiplier
        return self
    }
    func addSecondBtnTitle(title:String) -> CLEmptyBaseView {
        secondBtnTitle = title
        return self
    }
    func addSecondBtnTitleColor(color:UIColor) -> CLEmptyBaseView {
        secondBtnTitleColor = color
        return self
    }
    func addSecondBtnCornerRadius(radius:CGFloat) -> CLEmptyBaseView {
        secondBtnCornerRadius = radius
        return self
    }
    func addSecondBtnBorderColor(color:UIColor) -> CLEmptyBaseView {
        secondBtnBorderColor = color
        return self
    }
    func addSecondBtnBorderWidth(w:CGFloat) -> CLEmptyBaseView {
        secondBtnBorderWidth = w
        return self
    }
    func addSecondBtnBgColor(color:UIColor) -> CLEmptyBaseView {
        secondBtnBackGroundColor = color
        return self
    }
    /// 基于屏幕宽度的比例
    func addSecondBtnWidth(multiplier:CGFloat) -> CLEmptyBaseView {
        secondBtnWidth = multiplier
        return self
    }
    func addLoadingImage(imageNames:[String]) -> CLEmptyBaseView {
        loadingImageName = imageNames
        return self
    }
    func addLoadingTips(tips:NSAttributedString) -> CLEmptyBaseView {
        loadingTips = tips
        return self
    }
    func addLoadingDuration(duration:Double) -> CLEmptyBaseView {
        loadingDuration = duration
        return self
    }
    /// 配置结束,必须调用endConfig()函数
    func endConfig(){
        let firstBtn = initButton(title: firstBtnTitle, titleColor: firstBtnTitleColor, cornerRadius: firstBtnCornerRadius, borderWidth: firstBtnBorderWidth, borderColor: firstBtnBorderColor,bgColor: firstBtnBackGroundColor)
        var secondBtn:UIButton? = nil
        if secondBtnTitle != nil ||
            secondBtnBackGroundColor != nil {
            secondBtn = initButton(title: secondBtnTitle, titleColor: secondBtnTitleColor, cornerRadius: secondBtnCornerRadius, borderWidth: secondBtnBorderWidth, borderColor: secondBtnBorderColor,bgColor: secondBtnBackGroundColor)
        }
        setUpEmpty(imageName: emptyImageName, title: emptyTips, text: detailTips, firstBtn: firstBtn, firstBtnWidth: firstBtnWidth, secondBtn: secondBtn, secondBtnWidth: secondBtnWidth)
        setUpEmptyLoading(imageNames: loadingImageName, titleAttr: loadingTips, duration: loadingDuration)
        self.setIsHiddenLoading = isLoading
    }
    
    fileprivate func initButton(title:String?,titleColor:UIColor?,cornerRadius:CGFloat,borderWidth:CGFloat,borderColor:UIColor?,bgColor:UIColor?) -> UIButton{
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = bgColor
        if cornerRadius > 0 {
            button.layer.cornerRadius = cornerRadius
            button.layer.masksToBounds = true
        }
        if borderWidth > 0 {
            button.layer.borderWidth = borderWidth
            button.layer.borderColor = borderColor?.cgColor
        }
        return button
    }
}

//MARK:emptyView 约束
extension CLEmptyBaseView {
    
    fileprivate func config(imageName: String?,
                            title: NSAttributedString?,
                            detailTitle: NSAttributedString?,
                            firstBtn:UIButton?,
                            secondBtn:UIButton?){
        
        contentView = UIView(frame: bounds)
        addSubview(contentView!)
        
        if let imageName = imageName {
            emptyImage = UIButton()
            guard let emptyImage = emptyImage else {return}
            emptyImage.setImage(UIImage(named:imageName), for: .normal)
            emptyImage.addTarget(self, action: #selector(self.clickEmptyView), for: .touchUpInside)
            emptyImage.sizeToFit()
            emptyImage.imageView?.contentMode = .scaleAspectFill
            contentView?.addSubview(emptyImage)
            emptyImage.translatesAutoresizingMaskIntoConstraints = false
            emptyImageX = NSLayoutConstraint(item: emptyImage, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
            emptyImageY = NSLayoutConstraint(item: emptyImage, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: -50)
            contentView?.addConstraints([emptyImageX,emptyImageY])
        }
        
        if let title = title {
            titleLabel = UILabel()
            guard let titleLabel = titleLabel else {return}
            titleLabel.attributedText = title
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            titleLabel.sizeToFit()
            contentView?.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            let lay1 = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
            let lay3 = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: emptyImage, attribute: .bottom, multiplier: 1, constant: 15)
            let lay2 = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 0.8, constant: 0)
            contentView?.addConstraints([lay1,lay2,lay3])
        }
        
        if let detailTitle = detailTitle {
            detailTitleLabel = UILabel()
            detailTitleLabel?.numberOfLines = 0
            guard let detailTitleLabel = detailTitleLabel else {return}
            detailTitleLabel.attributedText = detailTitle
            detailTitleLabel.textAlignment = .center
            detailTitleLabel.sizeToFit()
            contentView?.addSubview(detailTitleLabel)
            detailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            let lay1 = NSLayoutConstraint(item: detailTitleLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
            let lay3 = NSLayoutConstraint(item: detailTitleLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel ?? emptyImage, attribute: .bottom, multiplier: 1, constant: 15)
            let lay2 = NSLayoutConstraint(item: detailTitleLabel, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 0.8, constant: 0)
            contentView?.addConstraints([lay1,lay2,lay3])
        }
        
        if firstBtn?.titleLabel?.text != nil && secondBtn?.titleLabel?.text == nil {
            self.firstButton = firstBtn
            guard let btn = firstButton else {return}
            btn.addTarget(self, action: #selector(self.clickFirstButton), for: .touchUpInside)
            contentView?.addSubview(btn)
            btn.translatesAutoresizingMaskIntoConstraints = false
            let lay1 = NSLayoutConstraint(item: btn, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
            let lay3 = NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: detailTitleLabel ?? titleLabel ?? emptyImage, attribute: .bottom, multiplier: 1, constant: 18)
            let lay2 = NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: self.firstBtnWidth, constant: 0)
            contentView?.addConstraints([lay1,lay2,lay3])
        }
        
        if firstBtn?.titleLabel?.text != nil && secondBtn?.titleLabel?.text != nil {
            self.secondButton = secondBtn
            self.firstButton = firstBtn
            guard let firstBtn = firstButton else {return}
            guard let secondBtn = secondButton else {return}
            firstBtn.addTarget(self, action: #selector(self.clickFirstButton), for: .touchUpInside)
            secondBtn.addTarget(self, action: #selector(self.clickSecondButton), for: .touchUpInside)
            contentView?.addSubview(firstBtn)
            contentView?.addSubview(secondBtn)
            firstBtn.translatesAutoresizingMaskIntoConstraints = false
            secondBtn.translatesAutoresizingMaskIntoConstraints = false
            
            let first1 = NSLayoutConstraint(item: firstBtn, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: -15)
            let first3 = NSLayoutConstraint(item: firstBtn, attribute: .top, relatedBy: .equal, toItem: detailTitleLabel ?? titleLabel ?? emptyImage, attribute: .bottom, multiplier: 1, constant: 18)
            let first2 = NSLayoutConstraint(item: firstBtn, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: self.firstBtnWidth, constant: 0)
            contentView?.addConstraints([first1,first2,first3])
            
            let second1 = NSLayoutConstraint(item: secondBtn, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 15)
            let second3 = NSLayoutConstraint(item: secondBtn, attribute: .centerY, relatedBy: .equal, toItem: firstBtn, attribute: .centerY, multiplier: 1, constant: 0)
            let second2 = NSLayoutConstraint(item: secondBtn, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: self.secondBtnWidth, constant: 0)
            contentView?.addConstraints([second1,second2,second3])
        }
        
    }
    
    @objc fileprivate func clickEmptyView(){
        delegate?.clickEmptyView()
    }
    @objc fileprivate func clickFirstButton(){
        delegate?.clickFirstButton()
    }
    @objc fileprivate func clickSecondButton(){
        delegate?.clickSecondButton()
    }
}

//MARK:LoadingView 约束
extension CLEmptyBaseView {
    
    fileprivate func configLoadingViewConstraint(){
        loadingImage?.translatesAutoresizingMaskIntoConstraints = false
        /// 约束loadingImage
        let loadingCenterX = NSLayoutConstraint(item: loadingImage!, attribute: .centerX, relatedBy: .equal, toItem: loadingView!, attribute: .centerX, multiplier: 1, constant: 0)
        let loadingCenterY = NSLayoutConstraint(item: loadingImage!, attribute: .bottom, relatedBy: .equal, toItem: loadingView!, attribute: .centerY, multiplier: 1, constant: -50)
        var loadingW:NSLayoutConstraint = NSLayoutConstraint()
        var loadingH:NSLayoutConstraint = NSLayoutConstraint()
        /// 如果图片宽度大于屏幕宽度一半,设置宽高为屏幕的一半
        if loadingImage!.bounds.width > (loadingView!.bounds.width * 0.5) {
            loadingW = NSLayoutConstraint(item: loadingImage!, attribute: .width, relatedBy: .equal, toItem: loadingView, attribute: .width, multiplier: 0.5, constant: 0)
            loadingH = NSLayoutConstraint(item: loadingImage!, attribute: .height, relatedBy: .equal, toItem: loadingView, attribute: .width, multiplier: 0.5, constant: 0)
        }
        
        loadingTitleLabel?.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelCenterX = NSLayoutConstraint(item: loadingTitleLabel!, attribute: .centerX, relatedBy: .equal, toItem: loadingView!, attribute: .centerX, multiplier: 1, constant: 0)
        let titleLabelCenterY = NSLayoutConstraint(item: loadingTitleLabel!, attribute: .top, relatedBy: .equal, toItem: loadingImage, attribute: .bottom, multiplier: 1, constant: 20)
        let titleLabelW = NSLayoutConstraint(item: loadingTitleLabel!, attribute: .width, relatedBy: .equal, toItem: loadingImage, attribute: .width, multiplier: 1, constant: 0)
        loadingView?.addConstraints([loadingCenterX,loadingCenterY,loadingW,loadingH,titleLabelCenterX,titleLabelCenterY,titleLabelW])
    }
    
}

extension CLEmptyBaseView {
    
    fileprivate func setUpRotationAnimation(imageView:UIImageView,isAnim:Bool){
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.fromValue = 0.0
        anim.toValue = Double.pi * 2.0
        anim.duration = self.loadingDuration
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false
        imageView.layer.add(anim, forKey: rotationAnimKey)
        isAnim ? (imageView.layer.speed = 1.0) : (imageView.layer.speed = 0.0)
    }
    
    fileprivate func setUpGroupAnimation(imageView:UIImageView,isAnim:Bool){
        imageView.animationDuration = self.loadingDuration
        imageView.animationRepeatCount = Int(INTMAX_MAX)
        isAnim ? imageView.startAnimating() : imageView.stopAnimating()
    }
    
    fileprivate func configAnmation(isGroupAnim:Bool,isStratAnim:Bool){
        guard let imageView = loadingImage else {return}
        if isGroupAnim {
            setUpGroupAnimation(imageView: imageView, isAnim: isStratAnim)
        }else {
            setUpRotationAnimation(imageView: imageView, isAnim: isStratAnim)
        }
    }
}

