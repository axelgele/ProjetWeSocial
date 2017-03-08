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





class GoogleMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate
{
    var vwGMap = GMSMapView()
    
    
    var locationManager = CLLocationManager()
    let marker = GMSMarker()
    
    var myTimer: Timer!
    
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
        let markerImage = UIImage(data: self.userPreference.value(forKey: "DataImage") as! Data)
        marker.icon = markerImage?.circleMask
        marker.layer.borderWidth = 1
        marker.layer.backgroundColor = UIColor.black.cgColor
        self.view = self.vwGMap
        //marker.appearAnimation = kGMSMaker
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
        vc.addAction(action: AABlurAlertAction(title: "Cancel", style: AABlurActionStyle.cancel) { _ in
            print("cancel")
            
        })
        vc.addAction(action: AABlurAlertAction(title: "Start", style: AABlurActionStyle.default) { _ in
            print("start")
            let vc2 = AABlurAlertController()
            vc2.alertTitle.text = "view2"
            self.present(vc2, animated: true, completion: nil)
        })
        vc.blurEffectStyle = .light
        vc.alertImage.image = UIImage(data: self.userPreference.value(forKey: "DataImage") as! Data)?.circleMask
        vc.imageHeight = 100
        vc.alertImage.layer.masksToBounds = true
        vc.alertTitle.text = userPreference.value(forKey: "userFirstName") as! String?
        vc.alertSubtitle.text = ""
        self.present(vc, animated: true, completion: nil)
         return true
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
        let maskSize = CGSize(width: lenght, height: lenght)
        let rect = CGRect(origin: .zero, size: maskSize)
        UIGraphicsBeginImageContextWithOptions(maskSize, false, scale)
        UIBezierPath(roundedRect: rect, cornerRadius: lenght/2).addClip()
        squared?.draw(in: rect)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
}
    
