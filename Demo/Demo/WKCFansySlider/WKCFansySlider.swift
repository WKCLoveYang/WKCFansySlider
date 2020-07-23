//
//  WKCFansySlider.swift
//  SwiftFuck
//
//  Created by wkcloveYang on 2020/7/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

import UIKit

@objc public protocol WKCFansySliderDelegate: NSObjectProtocol {
    /// 点击了滑块
    /// - Parameters:
    ///   - slider: WKCFansySlider
    ///   - value: 值
    @objc optional func fansySliderDidTouchUpInside(slider: WKCFansySlider, value: CGFloat)
    
    /// 开始改变
    /// - Parameters:
    ///   - slider: WKCFansySlider
    ///   - value: 值
    @objc optional func fansySliderDidStartChange(slider: WKCFansySlider, value: CGFloat)
    
    /// 变化了
    /// - Parameters:
    ///   - slider: WKCFansySlider
    ///   - value: 值
    @objc optional func fansySliderDidValueChanged(slider: WKCFansySlider, value: CGFloat)
    
    /// 停止改变
    /// - Parameters:
    ///   - slider: WKCFansySlider
    ///   - value: 值
    @objc optional func fansySliderDidEndChange(slider: WKCFansySlider, value: CGFloat)
}


open class WKCFansySlider: UIView {
    
    // 水平对齐方式
    public enum Alignment: Int {
        case center = 0
        case left   = 1
        case right  = 2
    }

    public weak var delegate: WKCFansySliderDelegate?
    
    /// 水平对齐方式, 默认居中
    /// 左对齐或者右对齐时horizontalMagin才有效
    public var alignment: Alignment = .center {
        willSet {
            setupSunviewsFrame(alignment: newValue, progress: progress)
        }
    }
   
    /// 水平非中心对齐时距边界的间距
    public var horizontalMagin: CGFloat = 0.0 {
        willSet {
            if alignment == .center {
                return
            }
            
            setupSunviewsFrame(alignment: alignment, progress: progress)
        }
    }

    /// 主体slider部分的slider
    /*
     注: WKCFansySlider允许slider外也能响应滑块的相对位移, 所以WKCFansySlider的frame与主体slider的大小没有直接关系; 主体slider的大小需要通过sliderSize设置
     */
    public var sliderSize: CGSize = .zero {
        willSet {
            setupSunviewsFrame(alignment: alignment, progress: progress)
        }
    }
    
    /// 滑块thumb的大小
    public var thumbSize: CGSize = .zero {
        willSet {
            let thumbCenter: CGPoint = thumbImageView.center
            thumbImageView.frame = CGRect(origin: .zero, size: newValue)
            thumbImageView.center = thumbCenter
        }
    }
    
    /// 滑动条距底部间距
    /*
     注: 这里的间距是指滑块主体部分距离WKCFansySlider底部的间距
     */
    public var bottomMagin: CGFloat = 0.0 {
        willSet {
            setupSunviewsFrame(alignment: alignment, progress: progress)
        }
    }
    
    /// 滑块值
    /*
     注: 用于设置初始值或者获取当前值, 设置时无动画效果
     */
    public var progress: CGFloat = 0.0 {
        willSet {
            setThumbFrame(progress: newValue)
            
            if let d = delegate, d.responds(to: #selector(WKCFansySliderDelegate.fansySliderDidValueChanged(slider:value:))) {
                d.fansySliderDidValueChanged?(slider: self, value: newValue)
            }
        }
    }
    
    /// 进度部分的颜色
    public var progressColor: UIColor = .white {
        willSet {
            progressImageView.backgroundColor = newValue
        }
    }
    
    /// 未进度部分的颜色
    public var trackColor: UIColor = .lightText {
        willSet {
            trackImageView.backgroundColor = newValue
        }
    }
    
    /// thumb颜色
    public var thumbColor: UIColor = .white {
        willSet {
            thumbImageView.backgroundColor = newValue
        }
    }
    
    /// 中心点颜色
    public var centerColor: UIColor = .lightGray {
        willSet {
            centerImageView.backgroundColor = newValue
        }
    }
    
    /// 进度部分图片
    public var progressImage: UIImage? {
        willSet {
            progressImageView.backgroundColor = nil
            progressImageView.image = newValue
        }
    }
    
    /// 未进度部分图片
    public var trackImage: UIImage? {
        willSet {
            trackImageView.backgroundColor = nil
            trackImageView.image = newValue
        }
    }
    
    /// thumb图片
    public var thumbImage: UIImage? {
        willSet {
            thumbImageView.backgroundColor = nil
            thumbImageView.image = newValue
        }
    }
    
    /// 中心点图片
    public var centerImage: UIImage? {
        willSet {
            centerImageView.backgroundColor = nil
            centerImageView.image = newValue
        }
    }
    
    /// 圆角
    public var cornerRadius: CGFloat = 0 {
        willSet {
            progressImageView.layer.cornerRadius = newValue
            trackImageView.layer.cornerRadius = newValue
        }
    }
    
    /// thumb圆角
    public var thumbCornerRadius: CGFloat = 0 {
        willSet {
            thumbImageView.layer.cornerRadius = newValue
        }
    }
    
    /// 是否展示进度label
    /*
     注: 进度label位于Thumb的正上方, 间距可调
     */
    public var shouldShowProgressLabel: Bool = true {
        willSet {
            progressLabel.isHidden = !newValue
            progressLabelBackgroundImageView.isHidden = !newValue
        }
    }
    
    /// 进度label大小
    public var progressLabelSize: CGSize = .zero {
        willSet {
            let maxY: CGFloat = progressLabel.frame.maxY
            progressLabel.frame = CGRect(origin: .zero, size: newValue)
            progressLabel.fansy_centerY = maxY - newValue.height / 2.0
            progressLabelBackgroundImageView.frame = progressLabel.frame
        }
    }
    
    /// 进度label距离thumb顶端的间距
    public var progressLabelBottomMagin: CGFloat = 0 {
        willSet {
            progressLabel.fansy_centerY = thumbImageView.frame.origin.y - progressLabelBottomMagin - progressLabel.frame.height / 2.0
            progressLabelBackgroundImageView.center = progressLabel.center
        }
    }
    
    /// 进度label背景图
    public var progressLabelBackgroundImage: UIImage? {
        willSet {
            progressLabelBackgroundImageView.image = newValue
        }
    }
    
    /// 进度label背景颜色
    public var progressLabelBackgroundColor: UIColor = .clear {
        willSet {
            progressLabel.backgroundColor = newValue
        }
    }
    
    /// 进度label字体
    public var progressLabelFont: UIFont? {
        willSet {
            progressLabel.font = newValue
        }
    }
    
    /// 进度label字体颜色
    public var progressLabelTextColor: UIColor = .black {
        willSet {
            progressLabel.textColor = newValue
        }
    }
    
    /// 是否进度条能拖拽
    /*
     注: 针对某些特殊情况, 需要限制滑块的滑动性时使用
     */
    public var isSliderCouldDrag: Bool = true
    
    /// 点击切换progress时是否动画
    public var isTouchMoveAnimate: Bool = false
    
    /// 动画时间
    /*
     注: 进度从0到1, 一个全路程的耗时. (有动画时有效)
     */
    public var animationDuration: TimeInterval = 2.0
    
    
    public lazy var progressImageView: UIImageView = setupImageView(backgroundColor: progressColor)
    public lazy var trackImageView: UIImageView = setupImageView(backgroundColor: trackColor)
    public lazy var thumbImageView: UIImageView = setupImageView(backgroundColor: thumbColor)
    public lazy var centerImageView: UIImageView = setupImageView(backgroundColor: centerColor)
    
    public lazy var progressLabelBackgroundImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    public lazy var progressLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = progressLabelTextColor
        view.textAlignment = .center
        return view
    }()
    
    
    
    
    private var startLocationX: CGFloat = 0
    private var startValue: CGFloat = 0
    private var preferredValue: CGFloat = 0
    private var wantProgress: CGFloat = 0
    private var shouldStop: Bool = false
    private var displayLink: CADisplayLink?
    private var completionBlock: (() -> ())?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(trackImageView)
        addSubview(progressImageView)
        addSubview(centerImageView)
        addSubview(thumbImageView)
        addSubview(progressLabelBackgroundImageView)
        addSubview(progressLabel)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        setupSunviewsFrame(alignment: alignment, progress: progress)
    }
    
    public func setProgress(value: CGFloat,
                            animated: Bool,
                            delay: TimeInterval = 0.0,
                            completion: (() -> ())? = nil) {
        if animated {
            wantProgress = value
            preferredValue = value > progress ? abs(preferredValue) : -abs(preferredValue)
            completionBlock = completion
            perform(#selector(startAnimation), with: nil, afterDelay: delay)
        } else {
            progress = value
        }
    }
    
    public func stopProgressAnimation() {
        shouldStop = true
        displayLink?.invalidate()
        displayLink = nil
    }
}



extension WKCFansySlider {
    
    private func setupImageView(backgroundColor: UIColor) -> UIImageView {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.backgroundColor = backgroundColor
        return view
    }
    
    private func setupSunviewsFrame(alignment: Alignment,
                                    progress: CGFloat) {
        let sliderFrame: CGRect = getSliderFrame(alignment: alignment)
        trackImageView.frame = sliderFrame
        progressImageView.frame = sliderFrame
        
        let sliderHeight: CGFloat = sliderFrame.height
        let centerHeight: CGFloat = sliderHeight - 1.5 * 2
        centerImageView.frame = CGRect(origin: .zero, size: CGSize(width: centerHeight, height: centerHeight))
        centerImageView.center = progressImageView.center
        centerImageView.layer.cornerRadius = centerHeight / 2.0
        
        let thumbSize: CGSize = self.thumbSize.equalTo(.zero) ? CGSize(width: 12, height: 12) : self.thumbSize
        thumbImageView.frame = CGRect(origin: .zero, size: thumbSize)
        thumbImageView.center = CGPoint(x: 0, y: progressImageView.center.y)
        
        if shouldShowProgressLabel {
            let progressLabelSize: CGSize = self.progressLabelSize.equalTo(.zero) ? CGSize(width: 30, height: 30) : self.progressLabelSize
            progressLabel.frame = CGRect(origin: .zero, size: progressLabelSize)
            progressLabel.center = CGPoint(x: 0, y: thumbImageView.frame.origin.y - progressLabelBottomMagin - progressLabelSize.height / 2.0)
            progressLabelBackgroundImageView.frame = progressLabel.frame
        }
        
        setThumbFrame(progress: progress)
    }
    
    private func getSliderFrame(alignment: Alignment) -> CGRect {
        let width: CGFloat = frame.width
        let height: CGFloat = frame.height
        let sliderSize: CGSize = self.sliderSize.equalTo(.zero) ? CGSize(width: width - 30 * 2, height: 8) : self.sliderSize
        let y: CGFloat = height - sliderSize.height - bottomMagin
        var x: CGFloat = 0
        
        switch alignment {
        case .center:
            x = (width - sliderSize.width) / 2.0
            
        case .left:
            x = horizontalMagin
            
        case .right:
            x = width - horizontalMagin - sliderSize.width
        }
        
        return CGRect(origin: CGPoint(x: x, y: y), size: sliderSize)
    }
    
    private func setThumbFrame(progress: CGFloat) {
        let sliderWidth: CGFloat = trackImageView.frame.width
        let progressImageWidth: CGFloat = sliderWidth * progress
        let thumbCenterX: CGFloat = progressImageWidth + trackImageView.frame.origin.x
        
        progressImageView.fansy_width = progressImageWidth
        thumbImageView.fansy_centerX = thumbCenterX
        
        if shouldShowProgressLabel {
            progressLabel.isHidden = false
            progressLabel.layer.opacity = 1.0
            progressLabel.fansy_centerX = thumbCenterX
            progressLabel.text = NSString(format: "%1.f", progress * 100) as String
            
            progressLabelBackgroundImageView.isHidden = false
            progressLabelBackgroundImageView.layer.opacity = 1.0
            progressLabelBackgroundImageView.center = progressLabel.center
        }
    }
    
    private func autoDismissProgressLabel() {
        if !shouldShowProgressLabel {
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 1, options: .curveLinear, animations: {
            self.progressLabel.layer.opacity = 0.0
            self.progressLabelBackgroundImageView.layer.opacity = 0.0
        }) { (finished) in
            if finished {
                self.progressLabel.isHidden = true
                self.progressLabelBackgroundImageView.isHidden = true
            }
        }
    }
    
    @objc private func startAnimation() {
        shouldStop = false
        displayLink?.invalidate()
        displayLink = nil
        displayLink = CADisplayLink(target: self, selector: #selector(displayAnimation(sender:)))
        displayLink?.preferredFramesPerSecond = 60
        displayLink?.add(to: RunLoop.current, forMode: .common)
    }
    
    @objc private func displayAnimation(sender: CADisplayLink) {
        var stepValue: CGFloat = progress
        stepValue += preferredValue / 100.0
        if stepValue >= 1.0 { stepValue = 1.0 }
        if stepValue <= 0.0 { stepValue = 0.0 }
        progress = stepValue
        
        if preferredValue < 0 {
            if progress <= wantProgress {
                progress = wantProgress
                sender.invalidate()
                if let com = completionBlock, !shouldStop {
                    com()
                }
            }
        } else {
            if progress >= wantProgress {
                progress = wantProgress
                sender.invalidate()
                if let com = completionBlock, !shouldStop {
                    com()
                }
            }
        }
    }
}



// MARK: Touch
extension WKCFansySlider {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let startPoint = touches.first?.location(in: self)
        guard let start = startPoint else { return }
        
        let movePoint = start
        let movePointX: CGFloat = movePoint.x - thumbImageView.center.x
        let width: CGFloat = trackImageView.frame.width
        let scale: CGFloat = movePointX / width
        var value: CGFloat = progress + scale
        
        if value <= 0 {
            value = 0
        }
        if value >= 1 {
            value = 1
        }
        
        if let d = delegate, d.responds(to: #selector(WKCFansySliderDelegate.fansySliderDidTouchUpInside(slider:value:))) {
            d.fansySliderDidTouchUpInside?(slider: self, value: value)
        }
        
        if !isSliderCouldDrag {
            return
        }
        
        setProgress(value: value, animated: false)
        startLocationX = start.x
        startValue = progress
        
        if let d = delegate, d.responds(to: #selector(WKCFansySliderDelegate.fansySliderDidStartChange(slider:value:))) {
            d.fansySliderDidStartChange?(slider: self, value: progress)
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isSliderCouldDrag {
            return
        }
        
        let movePoint = touches.first?.location(in: self)
        guard let moveP = movePoint else { return }
        
        let movePointX: CGFloat = moveP.x - startLocationX
        let width: CGFloat = trackImageView.frame.width
        let scale: CGFloat = movePointX / width
        var value: CGFloat = startValue + scale
        if value <= 0 {
            value = 0
        }
        if value >= 1 {
            value = 1
        }
        
        progress = value
        setThumbFrame(progress: value)
        
        if let d = delegate, d.responds(to: #selector(WKCFansySliderDelegate.fansySliderDidValueChanged(slider:value:))) {
            d.fansySliderDidValueChanged?(slider: self, value: value)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isSliderCouldDrag {
            return
        }
        
        if let d = delegate, d.responds(to: #selector(WKCFansySliderDelegate.fansySliderDidEndChange(slider:value:))) {
            d.fansySliderDidEndChange?(slider: self, value: progress)
        }
        
        autoDismissProgressLabel()
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isSliderCouldDrag {
            return
        }
        
        if let d = delegate, d.responds(to: #selector(WKCFansySliderDelegate.fansySliderDidEndChange(slider:value:))) {
            d.fansySliderDidEndChange?(slider: self, value: progress)
        }
        
        autoDismissProgressLabel()
    }
}
