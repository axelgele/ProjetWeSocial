//
//  ViewController.swift
//  WeSocialSwift
//
//  Created by GRISERI Pierre on 19/01/2017.
//  Copyright © 2017 LPDAM. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    
    //Creation du bouton Facebook
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    //
    
    //Variable de stockage des données utilisateur
    let userPreference = UserDefaults.standard
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Redimension du boutton FB en fonction de la taille d'écran
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        let dividedScreenWidth = screenWidth/8
        let dividedScreenHeight = screenHeight/8
        if(screenWidth < 375) {
            loginButton.frame = CGRect(x: dividedScreenWidth*2, y: dividedScreenHeight * 5, width: dividedScreenWidth*4 + 20, height: 40)
        }
        else {
            loginButton.frame = CGRect(x: dividedScreenWidth*2, y: dividedScreenHeight * 5, width: dividedScreenWidth*4, height: 40)
        }
        //
        
        //Background WeSocial
        let backgroundImage = UIImageView (frame: view.bounds)
        backgroundImage.image = UIImage(named:"background.png")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at:0)
        //
        
        //Ajout du boutton a la vue
        loginButton.delegate = self
        view.addSubview(loginButton)
        //
        
        //On affiche le token du Profil FB et on apelle la fonction fetchProfile()
        if let token = FBSDKAccessToken.current() {
            print(token)
            fetchProfile()
        }
        //
        
    }
    
    
    //Si l'utilisateur est déjà inscrit on bascule directement sur la Map
    override func viewDidAppear(_ animated: Bool) {
        if (self.userPreference.value(forKey: "idBD") != nil) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Map") as! GoogleMapViewController
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    //
    
    
    
    //Récupération du Profil + Enregistrement du profil sur la BD
    func fetchProfile() {
        
        //Déclaration des variables utile pour stocker les infos de l'utilisateur
        var dict = NSDictionary()
        let idUser: String
        let first_name: String
        let last_name: String
        let gender: String
        let email: String
        //
        
        //Variable pour récupérer les information via le SDK Facebook
        let param = ["fields" : "id, email, first_name, last_name, picture, gender"]
        //
        
        //Déclaration du GraphFB avec les champs a récupérer
        let graph = FBSDKGraphRequest(graphPath: "me", parameters: param)
        //
        
        //Récupération des informations
        graph?.start(completionHandler: { (connection, result, error) -> Void in
            
            //Si une erreur survient on l'affiche sinon on affiche les informations du Profil
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else {
                print(result)
            }
            //
            
            //Stockage des informations
            dict = (result as? NSDictionary)!
            let idUser = dict["id"] as! String
            let first_name = dict["first_name"] as! String
            let email = dict["email"] as! String
            let last_name = dict["last_name"] as! String
            let gender = dict["gender"] as! String
            //
            
            //Récupération de la PP
            let picture = dict["picture"] as! NSDictionary, data = picture["data"] as! NSDictionary, urlString = data["url"] as! String, urlImage = URL(string: urlString)
            let dt = try? Data.init(contentsOf: urlImage!)
            //
            
            //Stockage des données utilisateur
            self.userPreference.set(first_name, forKey: "userFirstName")
            self.userPreference.set(gender, forKey: "userGender")
            self.userPreference.set(dt, forKey: "DataImage")
            //
            
            print(idUser)
            print(email)
            print(first_name)
            print(last_name)
            print(gender)
            
            //Se Connecter à la bdd
            let myUrl = URL(string: "http://www.julienattard.fr/projects/WeSocialApp/webservice/getUser.php")
            var request = URLRequest(url:myUrl!)
            request.httpMethod = "POST"
            //
            
            
            //Requete
            let postString = "idfb=\(idUser)&nom=\(last_name)&prenom=\(first_name)&email=\(email)&birthday=&gender=\(gender)" as NSString
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
                    
                    
                    print(json?["id"] as! String)
                    print(json?["success"] as! String)
                    
                    //Stockage des réponses JSON sur le périphérique
                    self.userPreference.set(json?["id"], forKey: "idBD")
                    self.userPreference.set(json?["success"], forKey: "Success")
                    //
                    
                } catch {
                    print(error)
                }
            }
            task.resume()
            //
            
        })
        
        //On bascule sur la Map
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Map") as! UINavigationController
        self.present(nextViewController, animated:true, completion:nil)
        //
        
    }
    //
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("complete login")
        fetchProfile()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


