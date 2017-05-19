//
//  AgeViewController.swift
//  WeSocial
//
//  Created by GRISERI Pierre on 17/05/2017.
//  Copyright © 2017 LPDAM. All rights reserved.
//

import UIKit

class AgeViewController: UIViewController {

    let userPref = UserDefaults.standard
    @IBOutlet weak var agePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Background WeSocial
        let backgroundImage = UIImageView (frame: view.bounds)
        backgroundImage.image = UIImage(named:"background.png")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at:0)
        //

    }

    @IBAction func registerClick(_ sender: Any) {
        //DateFormatter permettant de récupérer la date au format YYYY-MM-dd
        let dateBDFormatter = DateFormatter()
        dateBDFormatter.dateFormat = "YYYY-MM-dd"
        //

        
        //On récupère la date du jour.
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        
        let currentYear = components.year
        let currentMonth = components.month
        let currentDay = components.day
        //
        
        //
        let pickedComponents = calendar.dateComponents([.year, .month, .day], from: agePicker.date)
        let pickedDay = pickedComponents.day
        let pickedMonth = pickedComponents.month
        let pickedYear = pickedComponents.year
        //
        
        //On print la date, au format YYYY-MM-dd, choisi par l'utilisateur
        let userDate = dateBDFormatter.string(from: agePicker.date)
        print(userDate)
        self.userPref.set(userDate, forKey: "userBirthday")
        //
        
       
        if(currentYear! - pickedYear! > 18) { register() }
        else if(currentYear! - pickedYear! == 18) {
            if(currentMonth! < pickedMonth!) { errorAge() }
            else if(currentMonth == pickedMonth) {
                if(currentDay! < pickedDay!) { errorAge() }
                else if(currentDay == pickedDay) { register() }
                else { register() }
            }
            else { register() }
        }
        else { errorAge() }
        
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "loginViewController")
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func errorAge() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "loginViewController")
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    func register() {
        //Se Connecter à la bdd
        let myUrl = URL(string: "http://julienattard.fr/projects/WeSocialApp/webservice/getUser.php")
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"
        //
        
        
        print(self.userPref.value(forKey: "userFirstName")!)
        
        //Requete
        let postString = "id_facebook=\(self.userPref.value(forKey: "idFB")!)&nom=\(self.userPref.value(forKey: "userLastName")!)&prenom=\(self.userPref.value(forKey: "userFirstName")!)&email=\(self.userPref.value(forKey: "email")!)&birthday=\(self.userPref.value(forKey: "userBirthday")!)&gender=\(self.userPref.value(forKey: "userGender")!)" as NSString
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8.rawValue)
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, reponse: URLResponse?, error: Error?) in
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            do {
                //Let's convert response sent from a server side script to a NSDictionary object:
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                //
                
                
                
                //Stockage des réponses JSON sur le périphérique
                let idBD = json?["id_user"]
                self.userPref.set(idBD, forKey: "idBD")
                let success = json?["success"]
                self.userPref.set(success, forKey: "Success")
                
                //
                
            } catch {
                print(error)
            }
        }
        task.resume()
        //
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        self.present(nextViewController, animated:true, completion:nil)


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
