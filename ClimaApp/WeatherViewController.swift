//
//  WeatherViewController.swift
//  ClimaApp
//
//  Created by formador on 10/3/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit
import WeatherInfoKit

/*
    //Niveles de Acceso
        - open
        - public
        - internal
        - file-private
        - private
*/

class WeatherViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var city = "Madrid"
    var country = "Spain"

    override func viewDidLoad() {
        super.viewDidLoad()

        weatherLabel.text = ""
        tempLabel.text = ""
        mostrarClima()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mostrarClima() {
        cityLabel.text = city
        countryLabel.text = country
        
        //Llamar a Weather Service para parsear el JSON y conseguir la información
        let weatherObject = WeatherService()
        weatherObject.getCurrentWeather(location: city + "," + country) { (data) in
            OperationQueue.main.addOperation({ 
                if let weatherData = data {
                    self.weatherLabel.text = weatherData.weather.capitalized
                    self.tempLabel.text = String(format: "%d", weatherData.temperature) + "\u{00B0}"
                }
            })
        }
    }
    
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        //Botón Cancel
    }
    
    @IBAction func updateWeatherInfo(segue: UIStoryboardSegue) {
        //Botón Hecho
        let sourceViewController = segue.source as! LocationTableViewController
        //"Madrid , Spain" -> ["Madrid", "Spain"]
        let selectedLocation = sourceViewController.selectedLocation.characters.split {$0 == ","}.map {String($0)}
        let splitString = sourceViewController.selectedLocation.characters.split {$0 == ","}
        let mapString = splitString.map {String($0)}
        
        print("-------------------------------------")
        print(splitString)
        print(mapString)
        print(selectedLocation)
        print("-------------------------------------")
        
        city = selectedLocation[0]
        country = selectedLocation[1]
        
        mostrarClima()
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocation" {
            let destinationViewController = segue.destination as! UINavigationController
            let locationTableViewController = destinationViewController.viewControllers[0] as! LocationTableViewController
            locationTableViewController.selectedLocation = "\(city),\(country)"
            //Madrid,Spain
            //Madrid, Spain
        }
    }
    

}
