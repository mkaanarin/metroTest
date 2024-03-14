//
//  DetailsVC.swift
//  MetroTest
//
//  Created by Mustafa Kaan ARIN on 8.03.2024.
//

import UIKit
import MapKit
import ParseCore

class DetailsVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var detailsPlaceLabel: UILabel!
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsMapView: MKMapView!
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromParse()
        detailsMapView.delegate = self
        
    }
    
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground{ (objects, error) in
            if error != nil {
                
            }else {
                if objects != nil{
                    let chosenPlaceObject = objects![0]
                    
                    if let placeName = chosenPlaceObject.object(forKey: "name") as? String{
                        self.detailsPlaceLabel.text = placeName
                    }
                    if let placeType = chosenPlaceObject.object(forKey: "type") as? String{
                        self.detailsTypeLabel.text = placeType
                    }
                    if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String{
                        self.detailsAtmosphereLabel.text = placeAtmosphere
                    }
                    if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String {
                        if let placeDoubleLatitude = Double(placeLatitude) {
                            self.chosenLatitude = placeDoubleLatitude
                        }
                    }
                    if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String {
                        if let placeDoubleLongitude = Double(placeLongitude) {
                            self.chosenLongitude = placeDoubleLongitude
                        }
                    }
                    if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject {
                        imageData.getDataInBackground{ (data, error) in
                            if error == nil{
                                self.detailsImageView.image = UIImage(data: data!)
                            }
                        }
                    }
                }
                
                let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                
                let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                
                let region = MKCoordinateRegion(center: location, span: span)
                
                self.detailsMapView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = self.detailsPlaceLabel.text!
                annotation.subtitle = self.detailsTypeLabel.text!
                self.detailsMapView.addAnnotation(annotation)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKClusterAnnotation{
            return nil
        }
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil{
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else{
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) {
                (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0{
                        
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsTypeLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                
                        mapItem.openInMaps(launchOptions: launchOptions)
                        
                    }
                }
            }
        }
    }
}
