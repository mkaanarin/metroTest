//
//  PlacesVC.swift
//  MetroTest
//
//  Created by Mustafa Kaan ARIN on 6.03.2024.
//

import UIKit
import ParseCore

class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOutClicked))
        
        tableView.dataSource = self
        tableView.delegate = self
        getDataFromParse()
    }
    
    @objc func logOutClicked(){
        
        PFUser.logOutInBackground{
            (error) in
            if error != nil{
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Çıkış Yapılamamıştır.")
            }
            else{
                let alert = UIAlertController(title: "Çıkış", message: "Çıkış Yapmak istediğinize emin misiniz? ", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ (action) in
                    self.performSegue(withIdentifier: "toLogOut", sender: nil)
                }
                let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
                alert.addAction(okButton)
                alert.addAction(cancelButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func addButtonClicked(){
        //Segue
        self.performSegue(withIdentifier: "addPlaceVC", sender: nil)
    }

    func getDataFromParse() {
           
           let query = PFQuery(className: "Places")
           query.findObjectsInBackground { (objects, error) in
               if error != nil {
                   self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
               } else {
                   if objects != nil {
                       
                       self.placeIdArray.removeAll(keepingCapacity: false)
                       self.placeNameArray.removeAll(keepingCapacity: false)
                       
                       for object in objects! {
                           if let placeName = object.object(forKey: "name") as? String {
                               if let placeId = object.objectId {
                                   self.placeNameArray.append(placeName)
                                   self.placeIdArray.append(placeId)
                               }

                           }
                       }
                       
                       self.tableView.reloadData()
                   }
               }
           }
       }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenPlaceId = selectedPlaceId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return placeNameArray.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            cell.textLabel?.text = placeNameArray[indexPath.row]
            return cell
        }
    

    func makeAlert(titleInput: String, messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
