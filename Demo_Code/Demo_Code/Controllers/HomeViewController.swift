//
//  HomeViewController.swift
//  Demo_Code
//
//  Created by Diken Shah on 03/12/20.
//

import UIKit
import CoreLocation
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var locationListTableview : UITableView!
    @IBOutlet weak var btnAddNewLocation : UIBarButtonItem!
    @IBOutlet weak var tblLocation : UITableView!
    @IBOutlet weak var viewNoDataFound : UIView!

    var context:NSManagedObjectContext!
    var arrayLocationData = [LocationData]()
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        context = AppDelegate.standard.persistentContainer.viewContext
        configureView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLocationFromDevice()
        fetchData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }

    func configureView(){
        tblLocation.tableFooterView = UIView(frame: CGRect.zero)
        let addLocation = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onClickAddNewLocation(sender:)))
        self.navigationItem.rightBarButtonItem = addLocation
    }
    //MARK: - IBAction methods
    @IBAction func onClickAddNewLocation(sender : UIButton){
        guard let addNewLocationVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.AddNewLocationViewController) as? AddNewLocationViewController else {
            return
        }
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addNewLocationVC, animated: true)
        self.hidesBottomBarWhenPushed = false
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

extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayLocationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.LocationCell, for: indexPath) as? LocationCell else {
            return UITableViewCell()
        }
        let locationObject = arrayLocationData[indexPath.row]
        cell.configureCell(indexPath: indexPath, object: locationObject)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let object = self.arrayLocationData[indexPath.row]
            self.deleteDataFromDB(object: object)
            self.arrayLocationData.remove(at: indexPath.row)
            self.viewNoDataFound.isHidden = self.arrayLocationData.count > 0 ? true : false
            self.tblLocation.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cityViewController = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.CityViewController) as? CityViewController else {
            return
        }
        cityViewController.locationData = arrayLocationData[indexPath.row]
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(cityViewController, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}

extension HomeViewController{
    func getLocationFromDevice(){
        LocationSingleton.sharedInstance.delegate = self
        if LocationSingleton.sharedInstance.isLocationServiceEnabled() == true {
            print("Last Location: \(String(describing: LocationSingleton.sharedInstance.lastLocation))")
        }else {
            
        }
    }
}
extension HomeViewController:LocationServiceDelegate{
    func tracingLocation(currentLocation: CLLocation) {
    }
    func tracingLocationDidFailWithError(error: NSError) {
    }
}

extension HomeViewController{
    func fetchData()
    {
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataIdentifier.LocationDataEntity)
        request.returnsObjectsAsFaults = false
        do {
            let result = try AppDelegate.standard.context.fetch(request)
            if let data = result as? [LocationData]{
                self.arrayLocationData = data
            }
            self.viewNoDataFound.isHidden = self.arrayLocationData.count > 0 ? true : false
            self.tblLocation.reloadData()
        } catch {
            print("Fetching data Failed")
        }
    }
    
    func deleteDataFromDB(object : LocationData){
        AppDelegate.standard.context.delete(object)
        print("Deleting Data..")
        do {
            try AppDelegate.standard.context.save()
        } catch {
            print("Deleting data Failed")
        }
    }
}
