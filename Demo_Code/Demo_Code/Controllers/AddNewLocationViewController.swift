//
//  AddNewLocationViewController.swift
//  Demo_Code
//
//  Created by Diken Shah on 03/12/20.
//

import UIKit
import MapKit
import CoreLocation
import Contacts
import CoreData

class AddNewLocationViewController: UIViewController {

    @IBOutlet weak var mapView : MKMapView!
    
    var didSelectLocation: ((_ location: Location)->())?
    var selectedLocation : Location?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
    var context:NSManagedObjectContext!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDelegate.persistentContainer.viewContext
        configureView()
        // Do any additional setup after loading the view.
    }
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        mapView.removeAnnotations(mapView.annotations)
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let locationvalue = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        locationvalue.placemark { [weak self] placemark, error in
            guard let `self` = self else { return }
            guard let placemark = placemark else {
                print("Error:", error ?? "nil")
                return
            }
            if let address = placemark.postalAddressFormatted{
                self.selectedLocation = Location(aTitle: address, aLatitude: coordinate.latitude, aLongtide: coordinate.longitude)
            }
            print(placemark.postalAddressFormatted ?? "")
        }
        print("Selected Location: \(String(describing: coordinate))")
    }

    func configureView(){
        DispatchQueue.main.async { [weak self] in
            guard let `self` = `self` else { return }
            self.mapView.delegate = self
            self.mapView.mapType = .standard
            self.mapView.isZoomEnabled = true
            self.mapView.isScrollEnabled = true

            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
            self.mapView.addGestureRecognizer(gestureRecognizer)

            
            if let coor = self.mapView.userLocation.location?.coordinate{
                self.mapView.setCenter(coor, animated: true)
            }
            
            if let locValue:CLLocationCoordinate2D = LocationSingleton.sharedInstance.lastLocation?.coordinate{
                self.mapView.mapType = MKMapType.standard

                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: locValue, span: span)
                self.mapView.setRegion(region, animated: true)
            }
            
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.onClickAddNewLocation(sender:)))
            self.navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    func saveDataToDatabase(){
        let location = NSEntityDescription.insertNewObject(forEntityName: CoreDataIdentifier.LocationDataEntity,
                                                         into: context) as! LocationData
        location.title = self.selectedLocation?.title ?? ""
        location.lattitude = self.selectedLocation?.latitide ?? 0.0
        location.longitude = self.selectedLocation?.longitude ?? 0.0

        print("Storing Data..")
        do {
            try AppDelegate.standard.context.save()
        } catch {
            print("Storing data Failed")
        }
        fetchData()
    }
    
    func fetchData()
    {
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataIdentifier.LocationDataEntity)
        request.returnsObjectsAsFaults = false
        do {
            let result = try AppDelegate.standard.context.fetch(request)
            for data in result as! [LocationData] {
                let title = data.title
                let latitude = data.lattitude
                let longtitude = data.longitude
                print("===>> title: \(title ?? "") | Latitude: \(latitude) | longtitude: \(longtitude)")
            }
        } catch {
            print("Fetching data Failed")
        }
    }
    
    @IBAction func onClickAddNewLocation(sender : UIButton){
        if self.selectedLocation != nil{
            self.saveDataToDatabase()
            self.navigationController?.popViewController(animated: true)
        }else{
            showAlertWithTitle(title: StringConstant.AppName, message: StringMessage.SelectLocation, viewController: self)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddNewLocationViewController : MKMapViewDelegate{
    
}

extension CLPlacemark {
    /// street name, eg. Infinite Loop
    var streetName: String? { thoroughfare }
    /// // eg. 1
    var streetNumber: String? { subThoroughfare }
    /// city, eg. Cupertino
    var city: String? { locality }
    /// neighborhood, common name, eg. Mission District
    var neighborhood: String? { subLocality }
    /// state, eg. CA
    var state: String? { administrativeArea }
    /// county, eg. Santa Clara
    var county: String? { subAdministrativeArea }
    /// zip code, eg. 95014
    var zipCode: String? { postalCode }
    /// postal address formatted
    var postalAddressFormatted: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter().string(from: postalAddress)
    }
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
