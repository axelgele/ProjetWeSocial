//
//  AABlurtAlertController.swift
//  WeSocialSwift
//
//  Created by Axel GELE on 03/03/2017.
//

import UIKit

public enum popUpMoodStyle {
    case `default`}


open class AAMoodAction: UIButton {
    fileprivate var handler: ((AAMoodAction) -> Void)? = nil
    fileprivate var style: popUpMoodStyle = popUpMoodStyle.default
    fileprivate var parent: MoodController? = nil
    
    
    public init(title: String?, style: popUpMoodStyle, handler: ((AAMoodAction) -> Void)?) {
        super.init(frame: CGRect.zero)
        
        self.style = style
        self.handler = handler
        self.addTarget(self, action: #selector(buttonTapped), for: UIControlEvents.touchUpInside)
        self.setTitle(title, for: UIControlState.normal)
        
        switch self.style {
        default:
            self.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.backgroundColor = UIColor(red:0.31, green:0.57, blue:0.87, alpha:1.00)
            self.layer.borderColor = UIColor(red:0.17, green:0.38, blue:0.64, alpha:1.00).cgColor
            
        }
        self.setTitleColor(self.titleColor(for: UIControlState.normal)?.withAlphaComponent(0.5), for: UIControlState.highlighted)
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.1
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc fileprivate func buttonTapped(_ sender: AAMoodAction) {
        self.parent?.dismiss(animated: true, completion: {
            self.handler?(sender)
        })
    }
}

open class MoodController: UIViewController {
    open var blurEffectStyle: UIBlurEffectStyle = .light
    open var imageHeight: Float = 175
    
    
    
    fileprivate var backgroundImage : UIImageView = UIImageView()
    fileprivate var alertView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
        view.layer.cornerRadius = 2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 15)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.22
        return view
    }()
    
    open var viewBlue : UIView = {
       let viewBlue = UIView()
        viewBlue.backgroundColor = UIColor(red:0.00, green:0.55, blue:0.85, alpha:1.0)
        return viewBlue
        
    }()
    
    open var alertImage : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.backgroundColor = UIColor.black
        return imgView
    }()
    
    open let titleInfo : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 11)
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        return lbl
    }()

    
    open let alertTitle : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.textColor = UIColor(red:0.20, green:0.22, blue:0.26, alpha:1.00)
        lbl.textAlignment = .center
        return lbl
    }()
    open let alertSubtitle : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textColor = UIColor.black
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    fileprivate let buttonsStackView : UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillProportionally
        sv.spacing = 80
        return sv
    }()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) n'a pas etait implemente")
    }
    
    fileprivate func setup() {
        self.view.subviews.forEach{ $0.removeFromSuperview() }
        self.backgroundImage.subviews.forEach{ $0.removeFromSuperview() }
        self.view.frame = UIScreen.main.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        self.backgroundImage.frame = self.view.bounds
        self.backgroundImage.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.addSubview(backgroundImage)
        self.alertView.addSubview(viewBlue)
        self.viewBlue.addSubview(titleInfo)
        self.view.addSubview(alertView)
        self.viewBlue.addSubview(alertImage)
        self.alertView.addSubview(alertTitle)
        self.alertView.addSubview(alertSubtitle)
        self.alertView.addSubview(buttonsStackView)
        if buttonsStackView.arrangedSubviews.count <= 1 {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnBackground))
            self.backgroundImage.isUserInteractionEnabled = true
            self.backgroundImage.addGestureRecognizer(tapGesture)
        }
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        let userPref = UserDefaults.standard
        
        let viewsDict: [String: Any] = [
            "alertView": alertView,
            "alertImage": alertImage,
            "titleInfo" : titleInfo, //test
            "alertTitle": alertTitle,
            "viewBlue" : viewBlue, //Test
            "alertSubtitle": alertSubtitle,
            "buttonsStackView": buttonsStackView
        ]
        let spacing = 0
        
        
        let screenWidth = userPref.value(forKey: "screenWidth") as! Float
        let dividedWidth = screenWidth / 8 * 7
        
        let viewMetrics: [String: Any] = [
            "margin": spacing * 2,
            "spacing": spacing,
            "alertViewWidth" : dividedWidth,
            "alertImageHeight": (alertImage.image != nil) ? imageHeight : 0,
            "alertTitleHeight": 50,
            "alertSubtitleheight" :50,
            "buttonsStackViewHeight": 60 //Modifier taille button
        ]
        
        let alertSubtitleVconstraint = (alertSubtitle.text != nil) ? "spacing-[alertSubtitle]-" : ""
        [NSLayoutConstraint(item: alertView, attribute: .centerX, relatedBy: .equal,
                            toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
         NSLayoutConstraint(item: alertView, attribute: .centerY, relatedBy: .equal,
                            toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            ].forEach { self.view.addConstraint($0)}
                [NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[alertImage(alertImageHeight)]-spacing-[alertTitle(alertTitleHeight)][alertTitle(alertTitleHeight)]-spacing-[alertSubtitle(alertSubtitleheight)]-[buttonsStackView(buttonsStackViewHeight)]|",
                    options: [], metrics: viewMetrics, views: viewsDict),
                 
                 
         NSLayoutConstraint.constraints(withVisualFormat: "H:[alertView(alertViewWidth)]",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[alertImage]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[alertTitle]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-80-[alertSubtitle]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[viewBlue]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
 
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[buttonsStackView]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict)
            ].forEach { NSLayoutConstraint.activate($0) }
    }
    
        
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
        
        // Set up blur effect
        backgroundImage.image = snapshot()
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = backgroundImage.bounds
        vibrancyEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        backgroundImage.addSubview(blurEffectView)
    }
    
    open func addAction(action: AAMoodAction) {
        action.parent = self
        buttonsStackView.addArrangedSubview(action)
    }
    
    fileprivate func snapshot() -> UIImage? {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, window.screen.scale)
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    
    func tapOnBackground(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
