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
import FBSDKCoreKit




class Utilisateurs{
    
    var nom: String
    var prenom: String
    var latitude: String
    var longitude: String
    var id_facebook: String
    var pp: Toucan
    var coordinate: CLLocationCoordinate2D
    
    init(nom: String, prenom: String, latitude: String, longitude: String, id_facebook: String, pp: Toucan) {
        self.nom = nom
        self.prenom = prenom
        self.latitude = latitude
        self.longitude = longitude
        self.coordinate = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
        self.id_facebook = id_facebook
        self.pp = pp
    }

}


class GoogleMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate
{
    
    var vwGMap = GMSMapView()
    
    
    var locationManager = CLLocationManager()
    let marker = GMSMarker()
    
    var myTimer: Timer!
    var time: Timer!
    var timerDelete : Timer!
    
    
    //Creation deux tableaux un pour récuperer le json et un autre pour stocker les utilisateurs du JSON
    var utilisateurTab = [Utilisateurs]()
    //var arrayUsers =  [UtilisateursMarker]()
    var tabMarker = [GMSMarker]()
    
    @IBAction func popUPDelete(_ sender: Any) {
        let vc = MoodController()
        vc.view.bounds.size.height = 200
        vc.blurEffectStyle = .light
        
        let userPref = UserDefaults.standard
        let screenWidth = userPref.value(forKey: "screenWidth") as! Float
        let dividedWidth = screenWidth / 8 * 7
        vc.viewBlue.frame = CGRect(x: 0, y: 0, width: Int(dividedWidth), height: 70)
        vc.titleInfo.frame = CGRect(x: 50, y: 20, width: 200, height: 50)
        vc.titleInfo.text = "Poste par Axel il y a 20 minutes"
        vc.alertTitle.frame = CGRect(x: 20, y: 20, width: 500, height: 500)
        
        vc.alertImage.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        vc.alertSubtitle.text = "Qui pour sortir ce soir ?"

        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func openMessage(_ sender: Any) {
        let vc = popUpMessageController()
        vc.blurEffectStyle = .light
        let userPref = UserDefaults.standard
        let screenWidth = userPref.value(forKey: "screenWidth") as! Float
        let dividedWidth = screenWidth / 2 * 1.3
        vc.button.frame = CGRect(x: Int(dividedWidth ) , y: 90, width: 50, height: 25)
        
        self.present(vc, animated: true, completion: nil)
    }
    
    

    let userPreference = UserDefaults.standard
    
    
    
    //    MARK: - View Life Cycle Methods
    override func viewDidLoad()
    {
        //Changement du style de la map
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "map_style", withExtension: "json") {
                vwGMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        
        
        
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
        
        //Déclaration de l'utilisation du timer
        //myTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.requetePost), userInfo: nil, repeats: true)
        
        time = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.getCoord), userInfo: nil, repeats: true)
        
        timerDelete = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(self.clearMarkers), userInfo: nil, repeats: true)
        self.view = vwGMap
        
        
        
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
        
        
       //Déclaration de l'utilisation du timer
        myTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(GoogleMapViewController.requetePost), userInfo: nil, repeats: true)
        

       
        //Création de l'image du marqueur
        let markerImage = Toucan(image: UIImage(data: self.userPreference.value(forKey: "ppMkr") as! Data)!)
        let ppToucan = markerImage.resize(CGSize(width: 50, height: 50))
        marker.icon = ppToucan.maskWithEllipse(borderWidth: 0.5, borderColor: UIColor.blue).image
        marker.layer.borderWidth = 1
        marker.layer.backgroundColor = UIColor.black.cgColor
        //marker.appearAnimation = GMSMarkerAnimation.pop
        self.view = self.vwGMap
        marker.position = CLLocationCoordinate2DMake(newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)
        marker.map = self.vwGMap
        
    }
    
    
    //Fonction pour la requete POST
    func requetePost(){
        
        //Se Connecter à la bdd
        let myUrl = URL(string: "http://julienattard.fr/projects/WeSocialApp/webservice/setGeolocation.php")
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"
        
        //Requete
        let postString = "id_user=\(self.userPreference.value(forKey: "idUser"))&latitude=\(marker.position.latitude))&longitude=\(marker.position.longitude)"
        //\(userPreference.value(forKey: "idBD"))
        print(postString)
        request.httpBody = postString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        
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
        vc.addAction(action: AABlurAlertAction(title: "Voir sur Facebook", style: AABlurActionStyle.facebook) { _ in
            var myfacebookUrl = "https://www.facebook.com/"
            for user in self.utilisateurTab {
                let setting = user.id_facebook
                myfacebookUrl = myfacebookUrl.appending(setting)
                let facebookUrl = URL(string: myfacebookUrl)
                UIApplication.shared.canOpenURL(facebookUrl!)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(facebookUrl!, options: [:], completionHandler: nil)
                } else {
                    print("iOS version is lower than 10.0")
                }
            }
           
         })
        vc.blurEffectStyle = .light
        
            for user in self.utilisateurTab {
                if marker.title == user.id_facebook {
                    let ppMkr = "http://graph.facebook.com/\(user.id_facebook)/picture?type=large"
                    let urlppMkr = URL(string: ppMkr)
                    let dtMkr = try? Data.init(contentsOf: urlppMkr!)
                    let image = Toucan(image: UIImage(data: dtMkr!)!)
                    vc.alertImage.image = image.maskWithEllipse().image
                    vc.imageHeight = 100
                    vc.alertImage.layer.masksToBounds = true
                    vc.alertTitle.text = user.prenom + "  22 ans"
                    vc.alertSubtitletwo.text = "---------"
                    vc.alertSubtitle.text = "Coucou je suis nouveau"
                    self.present(vc, animated: true, completion: nil)
                    return true
                }
            }
        return true

    }
 
    
    func getCoord()
    {
       
        
        //On se connecte à la bdd
        let url = URL(string: "http://www.julienattard.fr/projects/WeSocialApp/webservice/getMarkers.php")
        
        var request = URLRequest(url:url!)
        
        request.httpMethod = "POST"
        
        let idUser = userPreference.value(forKey: "idBD")!
        
        let postString = "id_user=\(idUser)&latitude=43.617189795910335&longitude=7.07360744146412"
        print(postString)
        //\(vwGMap.myLocation?.coordinate.latitude) \(vwGMap.myLocation?.coordinate.longitude)
        
        request.httpBody = postString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        

        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, reponse: URLResponse?, error: Error?) in
            
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
                        let coordinates = myJson?["users"] as! NSArray
                        for index in 0...coordinates.count - 1 {
                            let coord = coordinates[index] as! NSDictionary
                            
                            let nom = coord["nom"] as! String
                            let prenom = coord["prenom"] as! String
                            let lat = coord["latitude"] as! String
                            let lng = coord["longitude"] as! String
                            let idFb = coord["id_facebook"] as! String
                            let ppMkr = "http://graph.facebook.com/\(idFb)/picture?type=normal&width=160&height=160"
                            let urlppMkr = URL(string: ppMkr)
                            let dtMkr = try? Data.init(contentsOf: urlppMkr!)
                            let imageMkr = UIImage(data: dtMkr!)
                            let toucanResize = Toucan(image: imageMkr!).resize(CGSize(width: 50, height: 50))

                            
                            let user = Utilisateurs(nom: nom, prenom: prenom, latitude: lat, longitude: lng, id_facebook: idFb, pp: toucanResize)
                            self.utilisateurTab.append(user)
                        }
                     
                        
                        //  On parcourt le tableau pour placer les markers
                        for users in self.utilisateurTab{
                            
                           DispatchQueue.main.async() {
                                    let placeMarker = GMSMarker()
                                    placeMarker.title = users.id_facebook
                                    placeMarker.tracksViewChanges = false
                                    placeMarker.icon = users.pp.maskWithEllipse(borderWidth: 0.5, borderColor: UIColor.blue).image
                                    placeMarker.layer.borderWidth = 1
                                    placeMarker.layer.backgroundColor = UIColor.black.cgColor
                                    // placeMarker.appearAnimation = GMSMarkerAnimation.pop
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
    
    func clearMarkers() {
        self.vwGMap.clear()
    }
    
}


    
