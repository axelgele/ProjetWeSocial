//
//  GoogleMapViewController.swift
//  geo
//
//  Created by CURNIER Pierre on 26/01/2017.
//  Copyright © 2017 CURNIER Pierre. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps


struct Utilisateurs{
    
    var nom: String
    var prenom: String
    var latitude: String
    var longitude: String
    var id_facebook: String
}

class UtilisateursMarker: NSObject{
    
    var nom: String
    var prenom: String
    var coordinate: CLLocationCoordinate2D
    var id_Facebook: String
    
    init(nom: String, prenom: String, latitude: String, longitude: String, id_facebook: String) {
        
        self.nom = nom
        self.prenom = prenom
        self.coordinate = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
        self.id_Facebook = id_facebook
    }
}



class GoogleMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate
{
    var vwGMap = GMSMapView()
    
    
    var locationManager = CLLocationManager()
    let marker = GMSMarker()
    
    var myTimer: Timer!
    
    
    //Creation deux tableaux un pour récuperer le json et un autre pour stocker les utilisateurs du JSON
    var utilisateurTab = [Utilisateurs]()
    var arrayUsers =  [UtilisateursMarker]()
    var tabMarker = [GMSMarker]()
    
    
    
    

    let userPreference = UserDefaults.standard
    
    
    //    MARK: - View Life Cycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        vwGMap.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer

        //minimum distance to be moved by device before update
        locationManager.distanceFilter = 2000
        
        //Permission pour utiliser la geoloc
        locationManager.requestWhenInUseAuthorization()
        
        //Pour le futur pour activer la geoloc est tjrs activer
        locationManager.requestAlwaysAuthorization()
        
        //Mise à jour de la location de l'utilisateur
        locationManager.startUpdatingLocation()
        getCoord()


        self.view = vwGMap
        
        
        
        
//        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
//        self.view.addSubview(navBar)
//        let navItem = UINavigationItem(title: "SomeTitle");
//        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(getter: UIAccessibilityCustomAction.selector))
//        navItem.leftBarButtonItems = [doneItem]
//        navBar.setItems([navItem], animated: false)

    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if (status == CLAuthorizationStatus.authorizedWhenInUse)
        {
            vwGMap.isMyLocationEnabled = true //Avoir la location de l'utilisateur
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let newLocation = locations.last
        vwGMap.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 15.0)
        vwGMap.setMinZoom(15, maxZoom: 18)
        vwGMap.animate(toViewingAngle: 60)
        vwGMap.settings.myLocationButton = true
        
        //Afficher la latitude longitude
        print("Latitude: ",marker.position.latitude)
        
        print("Longitude: ",marker.position.longitude)
        
       //Déclaration de l'utilisation du timer
        myTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(GoogleMapViewController.requetePost), userInfo: nil, repeats: true)
        

       
        //Création de l'image du marqueur
        let markerImage = UIImage(data: self.userPreference.value(forKey: "ppMkr") as! Data)
        marker.icon = markerImage?.circleMask
        marker.layer.borderWidth = 1
        marker.layer.backgroundColor = UIColor.black.cgColor
        marker.appearAnimation = GMSMarkerAnimation.pop
        self.view = self.vwGMap
        marker.position = CLLocationCoordinate2DMake(newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)
        marker.map = self.vwGMap
        
    }
    
    
    //Fonction pour la requete POST
    func requetePost(){
        
        //Se Connecter à la bdd
        let myUrl = URL(string: "http://www.julienattard.fr/projects/WeSocialApp/webservice/setGeolocation.php")
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"
        
        
        //Requete
        print(self.userPreference.value(forKey: "idBD"))
        let postString = "id=\(self.userPreference.value(forKey: "idBD"))&latitude=\(marker.position.latitude))&longitude=\(marker.position.longitude)" as NSString
        
        request.httpBody = postString.data(using: String.Encoding.utf8.rawValue)
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, reponse: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            print("response=\(reponse)")
            
             
        }
        task.resume()
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let vc = AABlurAlertController()
        vc.addAction(action: AABlurAlertAction(title: "", style: AABlurActionStyle.facebook) { _ in
            var myfacebookUrl = "https://www.facebook.com/"
            //print(self.userPreference.value(forKey: "id") as! String)
            for user in self.arrayUsers {
                var setting = user.id_Facebook
                print(setting)
                //var setting = "axel.gele2"
                myfacebookUrl = myfacebookUrl.appending(setting)
                print(myfacebookUrl)
                var facebookUrl = URL(string: myfacebookUrl)
                //print(facebookUrl.baseURL)
                UIApplication.shared.canOpenURL(facebookUrl!)
                UIApplication.shared.open(facebookUrl!, options: [:], completionHandler: nil)
            }
           
         })
        vc.addAction(action: AABlurAlertAction(title: "Start", style: AABlurActionStyle.messenger) { _ in
            print("start")
        })
        vc.blurEffectStyle = .light
        
        
            for user in self.arrayUsers {
                if marker.title == user.id_Facebook {
                    let ppMkr = "http://graph.facebook.com/\(user.id_Facebook)/picture?type=normal"
                    let urlppMkr = URL(string: ppMkr)
                    let dtMkr = try? Data.init(contentsOf: urlppMkr!)
                    vc.alertImage.image = UIImage(data: dtMkr!)?.circleMask
                    vc.imageHeight = 100
                    vc.alertImage.layer.masksToBounds = true
                    vc.alertTitle.text = user.prenom
                    vc.alertSubtitle.text = ""
                    print("oui")
                    self.present(vc, animated: true, completion: nil)
                    return true
                }
            }
        print("on est al")
        return true

    }
 
    
    func getCoord()
    {
       
        
        //On se connecte à la bdd
        let url = URL(string: "http://www.julienattard.fr/projects/WeSocialApp/webservice/getCoordinates.php")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            if error != nil
            {
                print ("ERROR")
                return
            }
            else
            {
                if let content = data
                {
                    do
                    {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as? NSDictionary
                        print(myJson)
                        let coordinates = myJson?["coordinates"] as! NSArray
                        print("bONjour", coordinates)
                        for index in 0...coordinates.count - 1 {
                            print(coordinates[index])
                            let coord = coordinates[index] as! NSDictionary
                            
                            let nom = coord["nom"] as! String
                            let prenom = coord["prenom"] as! String
                            let lat = coord["latitude"] as! String
                            let lng = coord["longitude"] as! String
                            let idFb = coord["id_facebook"] as! String
                            
                            let user = Utilisateurs(nom: nom, prenom: prenom, latitude: lat, longitude: lng, id_facebook: idFb)
                            print(user)
                            self.utilisateurTab.append(user)
                        }
                        //{et
                            
//                            for index in 0...(coordinates as AnyObject).count-1{
//                                
//                                let coord = coordinates[index] as! [String: AnyObject]
//                                
//                                
//                                utilisateurTab.append(Utilisateurs(nom: (coord["nom"] as! String),
//                                                                  prenom: (coord["prenom"] as! String),
//                                                                  latitude: (coord["latitude"] as! String),
//                                                                   longitude: (coord["longitude"] as! String),
//                                                                  id_facebook: (coord["id_facebook"] as! String)))
//                               
//                            print("prénom", coord["prenom"])
//                            }
                            
                        
                            //}
                        
                        //On remplit un tableau d'utilisateur avec les données du JSON
                        for utilisateur in self.utilisateurTab{
                            
                            var utilisateursWesocial = UtilisateursMarker(nom: utilisateur.nom,
                                                                          prenom: utilisateur.prenom,
                                                                          latitude: utilisateur.latitude,
                                                                          longitude: utilisateur.longitude,
                                                                          id_facebook: utilisateur.id_facebook)
                            
                            self.arrayUsers.append(utilisateursWesocial)
                            
                            print("Debut",self.arrayUsers.description, "Wesh")
                        }
                        
                        //  On parcourt le tableau pour placer les markers
                        for users in self.arrayUsers{
                            
                            /*self.vwGMap.clear()
                             self.marker.position = CLLocationCoordinate2D(latitude: users.coordinate.latitude,
                             longitude: users.coordinate.longitude)
                             
                             print("caca")
                             self.marker.map = self.vwGMap*/
                            //                            marker.position.latitude = users.coordinate.latitude
                            //                            marker.position.longitude = users.coordinate.longitude
                            //                            self.vwGMap.
                            
                            DispatchQueue.main.async() {
                                let placeMarker = GMSMarker()
                                placeMarker.title = users.id_Facebook
                                print(placeMarker.title)
                                let ppMkr = "http://graph.facebook.com/\(users.id_Facebook)/picture?type=normal"
                                let urlppMkr = URL(string: ppMkr)
                                let dtMkr = try? Data.init(contentsOf: urlppMkr!)
                                placeMarker.icon = UIImage(data: dtMkr!)?.circleMask
                                placeMarker.layer.borderWidth = 1
                                placeMarker.layer.backgroundColor = UIColor.black.cgColor
                                placeMarker.appearAnimation = GMSMarkerAnimation.pop
                                placeMarker.position = CLLocationCoordinate2D(latitude: users.coordinate.latitude,longitude: users.coordinate.longitude)
                                //placeMarker.title = users.prenom
                                placeMarker.map = self.vwGMap
                                self.tabMarker.append(placeMarker)
                                
                            }
                            
                            
                        }
                        
                        
                        
                    }
                    catch
                    {
                        
                    }
                }
            }
            
            
        }
        task.resume()
        
    }
    
}



extension UIImage{
    var squared: UIImage? {
        let lenght = min(size.width, size.height)
        let maskSize = CGSize(width: lenght, height: lenght)
        let rect = CGRect(origin: .zero, size: maskSize)
        UIGraphicsBeginImageContextWithOptions(maskSize, false, scale)
        draw(in: rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }

    var circleMask: UIImage? {
        let lenght = min(size.width, size.height)
        let maskSize = CGSize(width: 70, height: 70)
        let rect = CGRect(origin: .zero, size: maskSize)
        UIGraphicsBeginImageContextWithOptions(maskSize, false, scale)
        UIBezierPath(roundedRect: rect, cornerRadius: lenght/2).addClip()
        squared?.draw(in: rect)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
}
    
