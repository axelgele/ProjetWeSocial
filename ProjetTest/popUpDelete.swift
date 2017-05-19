//
//  popUpDelete.swift
//  WeSocial
//
//  Created by GELE Axel on 03/05/2017.
//  Copyright © 2017 LPDAM. All rights reserved.
//


import UIKit

public enum popUpDeleteActionStyle {
    case `default`
}


open class popUpDeleteAction: UIButton {
    fileprivate var handler: ((popUpDeleteAction) -> Void)? = nil
    fileprivate var style: popUpDeleteActionStyle = popUpDeleteActionStyle.default
    fileprivate var parent: popUpDeleteController? = nil
    
    
    public init(title: String?, style: popUpDeleteActionStyle, handler: ((popUpDeleteAction) -> Void)?) {
        super.init(frame: CGRect.zero)
        
        self.style = style
        self.handler = handler
        
        
        self.setTitleColor(self.titleColor(for: UIControlState.normal)?.withAlphaComponent(0.5), for: UIControlState.highlighted)
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.1
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc fileprivate func buttonTapped(_ sender: popUpDeleteAction) {
        self.parent?.dismiss(animated: true, completion: {
            self.handler?(sender)
        })
    }
}

open class popUpDeleteController: UIViewController, UITextViewDelegate {
    open var blurEffectStyle: UIBlurEffectStyle = .light
    open var imageHeight: Float = 175
    
    
    
    fileprivate var backgroundImage : UIImageView = UIImageView()
    fileprivate var alertView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 15)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.22
        view.layer.borderColor = UIColor(red:0.00, green:0.55, blue:0.85, alpha:1.0).cgColor
        view.layer.borderWidth = 2.0
        return view
    }()
    
    open var alertImage : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    open let alertTitle : UILabel = {
        let lbl = UILabel()
        lbl.text = "Votre date de naissance ?"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.textColor = UIColor(red:0.00, green:0.55, blue:0.85, alpha:1.0)
        lbl.textAlignment = .center
        return lbl
    }()
    
    open let edittextDD : UITextField = {
        let userPref = UserDefaults.standard
        var screenWidth = userPref.value(forKey: "screenWidth") as! Float
        screenWidth = screenWidth / 6
        let rect        = CGRect(x: 20, y: 60, width: Double(screenWidth) , height: 50.2)
        let textView    = UITextField(frame: rect)
        textView.font               = UIFont(name: "Helvetica", size: 15)
        textView.textColor          = UIColor.lightGray
        textView.backgroundColor    = UIColor.white
        textView.layer.borderColor  = UIColor.lightGray.cgColor
        textView.layer.borderWidth  = 1.0
        textView.text               = "DD"
        textView.textAlignment      = .center
        textView.layer.borderColor  = UIColor(red:0.00, green:0.55, blue:0.85, alpha:1.0).cgColor
        return textView
    }()
    

    open let labelMail  : UILabel = {
        let userPref = UserDefaults.standard
        var screenWidth = userPref.value(forKey: "screenWidth") as! Float
        let rect        = CGRect(x: 30, y: 110, width: 100 , height: 50.2)
        let textView    = UILabel(frame: rect)
        textView.font  = UIFont(name: "Helvetica", size: 15)
        textView.font = UIFont.boldSystemFont(ofSize: 17)
        textView.textColor = UIColor(red:0.00, green:0.55, blue:0.85, alpha:1.0)
        textView.text               = "Votre Mail ?"
        textView.textAlignment      = .center
        return textView
    }()
    
    
    open let edittextMail : UITextField = {
        let userPref = UserDefaults.standard
        var screenWidth = userPref.value(forKey: "screenWidth") as! Float
        screenWidth = screenWidth / 6
        let rect        = CGRect(x: 20, y: 160, width: 200 , height: 50.2)
        let textView    = UITextField(frame: rect)
        textView.font               = UIFont(name: "Helvetica", size: 15)
        textView.textColor          = UIColor.lightGray
        textView.backgroundColor    = UIColor.white
        textView.layer.borderColor  = UIColor.lightGray.cgColor
        textView.layer.borderWidth  = 1.0
        textView.text               = "exemple@mail.com"
        textView.textAlignment      = .center
        textView.layer.borderColor  = UIColor(red:0.00, green:0.55, blue:0.85, alpha:1.0).cgColor
        return textView
    }()

    
    open let labelsupprimer : UILabel = {
        let userPref = UserDefaults.standard
        var screenWidth = userPref.value(forKey: "screenWidth") as! Float
        screenWidth = screenWidth / 2
        let rect        = CGRect(x: 20, y: 20, width: Double(screenWidth) , height: 50.2)
        let textView    = UILabel(frame: rect)
        textView.font               = UIFont(name: "Helvetica", size: 15)
//        textView.text               = "Votre date de naissance ?"
        textView.textAlignment      = .center
        textView.textColor = UIColor.black
        textView.layer.borderColor  = UIColor(red:0.00, green:0.55, blue:0.85, alpha:1.0).cgColor
        return textView

    }()
    
    open let edittextYYYY : UITextField = {
        let userPref = UserDefaults.standard
        var screenWidth = userPref.value(forKey: "screenWidth") as! Float
        screenWidth = screenWidth / 6
        let rect        = CGRect(x: 140, y: 60, width: Double(screenWidth) , height: 50.2)
        let textView    = UITextField(frame: rect)
        textView.font               = UIFont(name: "Helvetica", size: 15)
        textView.textColor          = UIColor.lightGray
        textView.backgroundColor    = UIColor.white
        textView.layer.borderColor  = UIColor.lightGray.cgColor
        textView.layer.borderWidth  = 1.0
        textView.text               = "YYYY"
        textView.textAlignment      = .center
        textView.layer.borderColor  = UIColor(red:0.00, green:0.55, blue:0.85, alpha:1.0).cgColor
        return textView
    }()

    
    open let edittextMM : UITextField = {
        let userPref = UserDefaults.standard
        var screenWidth = userPref.value(forKey: "screenWidth") as! Float
        screenWidth = screenWidth / 6
        let rect        = CGRect(x: 80, y: 60, width: Double(screenWidth) , height: 50.2)
        let textView    = UITextField(frame: rect)
        textView.font               = UIFont(name: "Helvetica", size: 15)
        textView.textColor          = UIColor.lightGray
        textView.backgroundColor    = UIColor.white
        textView.layer.borderColor  = UIColor.lightGray.cgColor
        textView.layer.borderWidth  = 1.0
        textView.text               = "MM"
        textView.textAlignment      = .center
        textView.layer.borderColor  = UIColor(red:0.00, green:0.55, blue:0.85, alpha:1.0).cgColor
        return textView
    }()

    
    open let button : UIButton = {
        
        let monBoutton = UIButton()
        monBoutton.setTitle("Publier", for: .normal)
        monBoutton.setTitleColor(UIColor.blue, for: .normal)
        monBoutton.layer.borderColor  = UIColor(red:0.00, green:0.55, blue:0.85, alpha:1.0).cgColor

        return monBoutton
    }()
    
    
    
    fileprivate let buttonsStackView : UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillEqually
        sv.spacing = 30
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
        self.view.addSubview(alertView)
        self.alertView.addSubview(alertImage)
        self.alertView.addSubview(alertTitle)
        self.alertView.addSubview(edittextDD)
        self.alertView.addSubview(edittextMM)
        self.alertView.addSubview(edittextYYYY)
        self.alertView.addSubview(labelsupprimer)
        self.alertView.addSubview(edittextMail)
        self.alertView.addSubview(button)
        self.alertView.addSubview(labelMail)
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
            "alertTitle": alertTitle,
            "editTextMM": edittextMM,
            "editTextDD" : edittextDD,
            "edittextYYYY" : edittextYYYY,
            "labelsupprimer" : labelsupprimer,
            "edittextMail" : edittextMail,
            "labelMail" : labelMail,
            "buttonsStackView": buttonsStackView
        ]
        let spacing = 5
        
        
        let screenWidth = userPref.value(forKey: "screenWidth") as! Float
        let screenHeight = userPref.value(forKey: "screenHeight") as! Float
        
        let dividedHeight = screenHeight / 8 * 2
        let dividedWidth = screenWidth / 8 * 7
        
        let viewMetrics: [String: Any] = [
            "margin": spacing * 2,
            "spacing": spacing,
            "alertViewWidth" : dividedWidth,
            "alertImageHeight": (alertImage.image != nil) ? imageHeight : 0,
            "alertTitleHeight": 50,
            "screenWidth" : dividedHeight,
            "buttonsStackViewHeight":  150
            ]
        
        let alertSubtitleVconstraint = (edittextMM.text != nil) ? "spacing-[edittextYYYY]-" : "5"
        let alertSubtitleV = (edittextMM.text != nil) ? "spacing-[edittextMail]-" : "5"

        [NSLayoutConstraint(item: alertView, attribute: .centerX, relatedBy: .equal,
                            toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
         NSLayoutConstraint(item: alertView, attribute: .centerY, relatedBy: .equal,
                            toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            ].forEach { self.view.addConstraint($0)}
        
        
        
       [NSLayoutConstraint.constraints(withVisualFormat: "V:|-margin-[alertImage(alertImageHeight)]-spacing-[alertTitle(alertTitleHeight)]-\(alertSubtitleVconstraint)margin-[buttonsStackView(buttonsStackViewHeight)]-margin-|",
            options: [], metrics: viewMetrics, views: viewsDict),
         
         NSLayoutConstraint.constraints(withVisualFormat: "H:[alertView(alertViewWidth)]",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[alertImage]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[alertTitle]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[editTextMM]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[labelsupprimer]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[editTextDD]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[edittextYYYY]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[labelsupprimer]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[edittextMail]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[labelMail]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[buttonsStackView]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict)
            ].forEach { NSLayoutConstraint.activate($0) }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
        
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
    
    open func addAction(action: popUpDeleteAction) {
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
