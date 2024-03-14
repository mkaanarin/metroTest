//
//  MapVC.swift
//  MetroTest
//
//  Created by Mustafa Kaan ARIN on 8.03.2024.
//

import UIKit
import MapKit
import ParseCore

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
       
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        super.viewDidLoad()
        
        
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer: )))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
 

    @objc func saveButtonClicked(){
        
        let placeModel = PlaceModal.sharedInstance
        let object = PFObject(className: "Places")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5){
            
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        let alert = UIAlertController(title: "Kayıt", message: "Mekanı kaydetmek istediğinize emin misiniz?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ (action) in
                object.saveInBackground{ (succes, error) in
                    
                    if (error != nil){
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
                    }
                }
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
            alert.addAction(okButton)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
    }
    
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModal.sharedInstance.placeName
            annotation.subtitle = PlaceModal.sharedInstance.placeType
            
            self.mapView.addAnnotation(annotation)
            
            PlaceModal.sharedInstance.placeLatitude = String(coordinates.latitude)
            PlaceModal.sharedInstance.placeLongitude = String(coordinates.longitude)
            
           
        }
    }
    @objc func backButtonClicked(){
        
        self.dismiss(animated: true)
    }
}
