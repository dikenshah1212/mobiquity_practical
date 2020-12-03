//
//  CityViewController.swift
//  Demo_Code
//
//  Created by Diken Shah on 03/12/20.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var lblCityName : UILabel!
    @IBOutlet weak var lblTemperature : UILabel!
    @IBOutlet weak var lblHumidity : UILabel!
    @IBOutlet weak var lblRainChances : UILabel!
    @IBOutlet weak var lblWind : UILabel!
    
    var locationData : LocationData?
    var weatherData : WeatherObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        lblCityName.text = locationData?.title ?? ""
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(locationData?.lattitude ?? 0.0)&lon=\(locationData?.longitude ?? 0.0)&appid=\(AppConstant.AppId)&units=metric")!
        print("==>> URL: \(url)")
        WebService().getTodayWeather(url: url) { [weak self](weatherData) in
            guard let `self` = self else { return }
            if let weatherData = weatherData{
                self.weatherData = weatherData
                DispatchQueue.main.async {
                    self.setupData()
                }
            }
        }
    }
    
    func setupData(){
        lblTemperature.text = "\(self.weatherData?.main.temp ?? 0)°C"
        lblHumidity.text = "\(self.weatherData?.main.humidity ?? 0)%"
        if (self.weatherData?.weather.count ?? 0) > 0{
            if let rainChance = self.weatherData?.weather.first?.main{
                lblRainChances.text = "\(rainChance)"
            }
        }
        lblWind.text = "\(self.weatherData?.wind.speed ?? 0) km/h"
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
