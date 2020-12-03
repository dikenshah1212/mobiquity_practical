//
//  LocationCell.swift
//  Demo_Code
//
//  Created by Diken Shah on 03/12/20.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblLattitude : UILabel!
    @IBOutlet weak var lblLongitude : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    func configureCell(indexPath : IndexPath, object : LocationData){
        lblTitle.text = object.title ?? ""
        lblLattitude.text = "Latitude: \(object.lattitude)"
        lblLongitude.text = "Latitude: \(object.longitude)"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
