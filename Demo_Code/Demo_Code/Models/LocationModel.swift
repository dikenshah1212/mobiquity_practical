//
//  LocationModel.swift
//  Demo_Code
//
//  Created by Diken Shah on 03/12/20.
//

import Foundation

struct Location {
    var title: String?
    var latitide: Double?
    var longitude : Double?
    init(aTitle : String, aLatitude : Double, aLongtide : Double) {
        self.title = aTitle
        self.latitide = aLatitude
        self.longitude = aLongtide
    }
}
