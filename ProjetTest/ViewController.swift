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
        let hauteur = self.view.frame.size.height
        self.userPreference.set(hauteur, forKey: "screenHeight")
        
        let largeur = self.view.frame.size.width
        self.userPreference.set(largeur, forKey: "screenWidth")
        
        //Ajout du boutton a la vue
        loginButton.delegate = self
        view.addSubview(loginButton)
        //
        
        //On affiche le token du Profil FB et on apelle la fonction fetchProfile()
        if (FBSDKAccessToken.current()) != nil {
            self.userPreference.value(forKey: "idFB")
            fetchProfile()
        }
        //
        
    }
    
    
    //Si l'utilisateur est déjà inscrit on bascule directement sur la Map
    override func viewDidAppear(_ animated: Bool) {
        if (self.userPreference.value(forKey: "idBD") != nil) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    //
    
    
    
    //Récupération du Profil + Enregistrement du profil sur la BD
    func fetchProfile() {
        
        //Déclaration des variables utile pour stocker les infos de l'utilisateur
          var dict = NSDictionary()
        
        
        //Variable pour récupérer les information via le SDK Facebook
        let param = ["fields" : "id, email, first_name, last_name, picture.type(large), gender"]
        //
        
        //Déclaration du GraphFB avec les champs a récupérer
        let graph = FBSDKGraphRequest(graphPath: "me", parameters: param)
        //
        
        //Récupération des informations
        graph?.start(completionHandler: { (connection, result, error) -> Void in
            
            //Stockage des informations
            dict = (result as? NSDictionary)!
            let idUser = dict["id"] as! String

            let first_name = dict["first_name"] as! String
            
            /*let email = dict["email"] as! String
            print(email)
            */
            let last_name = dict["last_name"] as! String
            let gender = dict["gender"] as! String
           
                        
            //Récupération de la PPLarge
            let picture = dict["picture"] as! NSDictionary, data = picture["data"] as! NSDictionary, urlString = data["url"] as! String, urlImage = URL(string: urlString)
            let dt = try? Data.init(contentsOf: urlImage!)
            
            let ppMkr = "http://graph.facebook.com/\(idUser)/picture?type=normal"
            let urlppMkr = URL(string: ppMkr)
            let dtMkr = try? Data.init(contentsOf: urlppMkr!)

            
            
            //Stockage des données utilisateur
            self.userPreference.set(idUser, forKey: "idFB")
            self.userPreference.set(first_name, forKey: "userFirstName")
            self.userPreference.set(gender, forKey: "userGender")
            self.userPreference.set(dt, forKey: "DataImage")
            self.userPreference.set(dtMkr, forKey: "ppMkr")
            //
            
            
            //Se Connecter à la bdd
            let myUrl = URL(string: "http://julienattard.fr/projects/WeSocialApp/webservice/getUser.php")
            var request = URLRequest(url:myUrl!)
            request.httpMethod = "POST"
            //
            
            
            //Requete
            let postString = "idfb=\(idUser)&nom=\(last_name)&prenom=\(first_name)&email=pierregriseri@hotmail.fr&birthday=&gender=\(gender)" as NSString
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
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
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


