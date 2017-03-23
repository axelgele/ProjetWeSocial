//
//  PreferenceViewController.swift
//  WeSocialSwift
//
//  Created by CURNIER Pierre on 27/01/2017.
//  Copyright © 2017 LPDAM. All rights reserved.
//

import QuartzCore
import UIKit
import WARangeSlider


class PreferenceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    let limitLength = 1
    let sizeCorner = 2
    
    var pickerDataSource = ["Homme", "Femme", "Les Deux"]
    var rangeSlider = RangeSlider()

    //    @IBOutlet weak var messageHumeur: UITextView!
    @IBOutlet weak var maxAge: UILabel!
    //    @IBOutlet weak var montrezMoi: UIPickerView!
    @IBOutlet weak var messageHumeur: UITextView!
    @IBOutlet weak var montreMoi: UIPickerView!
    @IBOutlet weak var viewAge: UIView!
    @IBOutlet weak var minAge: UILabel!
    @IBOutlet weak var viewVoir: UIView!
    @IBOutlet weak var viewSwitch: UIView!
    @IBOutlet weak var viewHumeur: UIView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.montreMoi.dataSource = self
        self.montreMoi.delegate = self
        
        
        //        messageHumeur.textContainer.maximumNumberOfLines = 4
        //        messageHumeur.layer.cornerRadius = 5
        //        messageHumeur.text="Wesh le 100"
        //        messageHumeur.layer.cornerRadius = 5
        
        //imageView.layer.cornerRadius = 5
        
        //        imageView.layer.shadowColor = UIColor.black.cgColor
        //        imageView.layer.shadowOpacity = 1
        //        imageView.layer.shadowOffset = CGSize.init(width: 1, height: 2)
        //        imageView.layer.shadowRadius = 5
        //        imageView.layer.shadowPath = UIBezierPath(rect: imageView.bounds).cgPath
        //        imageView.layer.shouldRasterize = true
        
        //        layoutSwift.layer.cornerRadius = 8
        
        rangeSlider.frame = CGRect(x: 5, y: (viewAge.frame.size.height / 2) - 10 , width: (viewAge.frame.size.width ) - 10 , height: 20)
        rangeSlider.addTarget(self, action:#selector(sliderValueDidChange(sender:)), for: .valueChanged)
        rangeSlider.minimumValue = 18
        rangeSlider.maximumValue = 55
        viewAge.addSubview(rangeSlider)
        

        
        setSyle(view: viewAge)
        setSyle(view: viewVoir)
        setSyle(view: viewHumeur)
        setSyle(view: viewSwitch)
        setStyleMess(view: messageHumeur)
    }
    
    func sliderValueDidChange(sender: UISlider){
        let minAgee = Int(rangeSlider.lowerValue)
        let maxAgee = Int(rangeSlider.upperValue)
        minAge.text = String(minAgee)
        if(maxAgee == 55) {
            maxAge.text = "55+"
        }
        else {
            maxAge.text = String(maxAgee)
        }
        
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    //MARK: Delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setSyle(view : UIView)  {
        
        var monImageView : UIView
        monImageView = view
        monImageView.layer.cornerRadius = 2
        
        monImageView.layer.shadowColor = UIColor.black.cgColor
        monImageView.layer.shadowOpacity = 0.5
        monImageView.layer.shadowOffset = CGSize.init(width: 1, height: 2)
        monImageView.layer.shouldRasterize = true
        //
        //
        //        monImageView.layer.cornerRadius = 8
        //
        //        monImageView.layer.borderColor = UIColor.black.cgColor
        
        
        
    }
    
    
    func setStyleMess( view : UITextView) {
        var monMess : UITextView
        monMess = view
        monMess.layer.cornerRadius = 5
        monMess.textContainer.maximumNumberOfLines = 4
        
    }
    
    
    
}
