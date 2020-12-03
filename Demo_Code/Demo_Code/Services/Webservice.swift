//
//  Webservice.swift
//  Demo_Code
//
//  Created by Diken Shah on 03/12/20.
//

import Foundation
class WebService {
    func getTodayWeather(url : URL, completion : @escaping (WeatherObject?) -> ()){
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print(error.localizedDescription)
                completion(nil)
            }else if let data = data {
                print(data)
                do{
                    let weatherObject = try JSONDecoder().decode(WeatherObject.self, from: data)
                    completion(weatherObject)
                    print(weatherObject.weather.first?.main ?? "")

                }catch let error{
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}
