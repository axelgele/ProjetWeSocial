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
    
    @IBOutlet weak var notif: UISwitch!
    @IBOutlet weak var facebook: UISwitch!
    @IBOutlet weak var messenger: UISwitch!
    
    var sMoodMesage: String = ""
    var iChoixSexe: Int = 0
    var bNotif: Int = 0
    var bFacebook: Int = 0
    var bMessenger: Int = 0
    
    var iAgeMin: Int = 0
    var iAgeMax: Int = 0
    
    let userPreference = UserDefaults.standard
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
        
        rangeSlider.frame = CGRect(x: 5, y: (viewAge.frame.size.height / 2)  , width: (viewAge.frame.size.width ) - 20 , height: 20)
        rangeSlider.addTarget(self, action:#selector(sliderValueDidChange(sender:)), for: .valueChanged)
//        rangeSlider.minimumValue = 18
//        rangeSlider.maximumValue = 55
        viewAge.addSubview(rangeSlider)
        

        
        setSyle(view: viewAge)
        setSyle(view: viewVoir)
        setSyle(view: viewHumeur)
        setSyle(view: viewSwitch)
        setStyleMess(view: messageHumeur)
        getSettings()
    }
    
    func sliderValueDidChange(sender: UISlider){
        let minAgee = Int(rangeSlider.lowerValue)
        let maxAgee = Int(rangeSlider.upperValue)
        
        iAgeMin = minAgee
        iAgeMax = maxAgee
        
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
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //Homme
        if row == 0
        {
            iChoixSexe = 1
        }
        //Femme
        if row == 1
        {
            iChoixSexe = 2
        }
        //Les Deux
        if row == 2
        {
            iChoixSexe = 0
        }
        
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
    
    @IBAction func enregistrer(_ sender: Any) {
        
        
        //récupératin des valeurs des champs
        
        //Message
        sMoodMesage = messageHumeur.text
        
        //Notif
        var Notif: Bool = true
        
        if notif.isOn == true{
            Notif = true
        }
        else {
            Notif = false
        }
        
        if Notif == true{
        
            bNotif = 1
        }
        else{
            bNotif = 0
        }

        //Facebook
        
        var Facebook: Bool = true
        
        if facebook.isOn == true{
            Facebook = true
        }
        else {
            Facebook = false
        }
        
        if Facebook == true{
            
            bFacebook = 1
        }
        else{
            bFacebook = 0
        }
        
        //Messenger
        
        var Messenger: Bool = true
        
        if messenger.isOn == true{
            Messenger = true
        }
        else {
            Messenger = false
        }
        
        if Messenger == true{
            
            bMessenger = 1
        }
        else{
            bMessenger = 0
        }
        
        print("Min", iAgeMin, "Max", iAgeMax, "sexe", iChoixSexe, "Notif", bNotif, "Facebook", bFacebook, "Messenger", bMessenger)
        var myURL = URL(string: "http://www.julienattard.fr/projects/WeSocialApp/webservice/setSettings.php")
        
        var request = URLRequest(url:myURL!)
        
        request.httpMethod = "POST"
        
        //requete
       let postString = "id_user=\(65)&search_sexe=\(iChoixSexe)&mood_message=\(sMoodMesage)&allow_notification=\(bNotif)&allow_facebook=\(bFacebook)&allow_messenger=\(bMessenger)&search_birth_min=\(iAgeMin)&search_birth_max=\(iAgeMax)" as NSString
        
        request.httpBody = postString.data(using: String.Encoding.utf8.rawValue)
        
        let task = URLSession.shared.dataTask(with: request){ (data: Data?, reponse: URLResponse?, error: Error?) in
            
            if error != nil{
                
                print("error=\(error)")
                return
            }
            
            print("reponse=\(reponse)")
        }
        
        task.resume()
        
    }
   
    func getSettings(){
    //Requete Post

    //On se connecte à la BDD + mise en place de la requete
    var myURL = URL(string: "http://www.julienattard.fr/projects/WeSocialApp/webservice/getSettings.php")
    var request = URLRequest(url:myURL!)
    request.httpMethod = "POST"
    
    //requete
    let postString = "id_user=\(65)" as NSString
    request.httpBody = postString.data(using: String.Encoding.utf8.rawValue)
    let task = URLSession.shared.dataTask(with: request){ (data: Data?, reponse: URLResponse?, error: Error?) in
    if error != nil{
    
    print("error=\(error)")
    return
    }
    
    else{
    
    if let content = data{
    do{
    
    let json = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as? NSDictionary
    
    let pref = json?["result"] as! NSDictionary

    //récupération des données du json
    let sAgeMin = pref["search_birth_min"] as! String
        
    let sAgeMax = pref["search_birth_max"] as! String
        
    let sMessage = pref["mood_message"] as! String
    
    let sChoixSexe = pref["search_sexe"] as! String
    
    let sNotif = pref["allow_notification"] as! String
    
    let sFacebook = pref["allow_facebook"] as! String
    
    let sMessenger = pref["allow_messenger"] as! String
    
    print("test",sMessage, sChoixSexe, sNotif, sFacebook, sMessenger, sAgeMin, sAgeMax)

    //RangeBar
    var dAgeMin = Double(sAgeMin)!
    var dAgeMax = Double(sAgeMax)!
        
    DispatchQueue.main.async() {
            self.rangeSlider.lowerValue = dAgeMin
            self.rangeSlider.upperValue = dAgeMax
        
            self.minAge.text = sAgeMin
            self.maxAge.text = sAgeMax
    }
        
    //On met le text sur le textview
    DispatchQueue.main.async() {
    self.messageHumeur.text = sMessage
    }
    
    //Valeur pour le picker
    let iChoixSexe = Int(sChoixSexe)
    DispatchQueue.main.async() {
    
    //On met le pickerview à jour
    if iChoixSexe == 0{
    self.montreMoi.selectRow(iChoixSexe! , inComponent: 0, animated: true)
    }
    if iChoixSexe == 1{
    self.montreMoi.selectRow(iChoixSexe! , inComponent: 0, animated: true)
    }
    if iChoixSexe == 2{
    self.montreMoi.selectRow(iChoixSexe! , inComponent: 0, animated: true)
    }
    }
    //Changement d'etat des switchs en fonction des pref
    //convertion des sNotif ect en Int
    
    let iNotif = Int(sNotif)
    
    let iFacebook = Int(sFacebook)
    
    let iMesseneger = Int(sMessenger)
    
    DispatchQueue.main.async(){
    
    var bNotif: Bool
    if iNotif == 1
    {
    bNotif = true
    }
    else
    {
    bNotif = false
    }
    
    if bNotif == true
    {
    self.notif.setOn(bNotif, animated: true)
    }
    else
    {
    self.notif.setOn(bNotif, animated: true)
    }
    //sFacebook
    var bFacebook: Bool
    if iFacebook == 1
    {
    bFacebook = true
    }
    else
    {
    bFacebook = false
    }
    
    if bFacebook == true
    {
    self.facebook.setOn(bFacebook, animated: true)
    }
    else
    {
    self.facebook.setOn(bFacebook, animated: true)
    }
    //Smessengers
    var bMessenger: Bool
    if iMesseneger == 1
    {
    bMessenger = true
    }
    else
    {
    bMessenger = false
    }
    
    if bMessenger == true
    {
    self.messenger.setOn(bMessenger, animated: true)
    }
    else
    {
    self.messenger.setOn(bMessenger, animated: true)
    }
    
    }//Fin des switchs

        
    }//fin du do
    catch {
    print(error)
    }
    
    }//Fin du if global
    
    }//Fin du else
    
    
    }//Fin du task
    task.resume()
    }
    
}
