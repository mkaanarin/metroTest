//
//  PlaceModal.swift
//  MetroTest
//
//  Created by Mustafa Kaan ARIN on 8.03.2024.
//

import Foundation
import UIKit

class PlaceModal{
    
    static let sharedInstance = PlaceModal()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init(){}
}

