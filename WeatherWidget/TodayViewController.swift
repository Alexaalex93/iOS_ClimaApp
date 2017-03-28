//
//  TodayViewController.swift
//  WeatherWidget
//
//  Created by formador on 15/3/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit
import NotificationCenter
import WeatherInfoKit

//El widget funciona por si solo entonces si actualizas la app el widget no lo va a hacer, si quieres compartir datos entre aplicaciones diferentes las debes añadir en appgroups en capablities
class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var climaLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var location = "Madrid, Spain"
    var defaults = UserDefaults(suiteName: "group.cice.climaapp")
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ciudadLabel.text = location
        
        //Llamamos a Weather Service para coger la info
        
        WeatherService().getCurrentWeather(location: location) { (data) in
            OperationQueue.main.addOperation {
                if let weatherData = data {
                    self.climaLabel.text = weatherData.weather.capitalized
                    self.tempLabel.text = String(format: "%d", weatherData.temperature) + "\u{00B0}"
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //En info plist hay que poner App transport security settins y allow aribtrary loads para que permita conexiones no seguras, las que no empiezan por https
    func widgetPerformUpdate(completionHandler: @escaping ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        if let defaultLocation = defaults?.value(forKey: "location") as? String {
            location = defaultLocation
        }
        ciudadLabel.text = location
        WeatherService().getCurrentWeather(location: location) { (data) in
            
         
                guard let weatherData = data else {
                completionHandler(NCUpdateResult.noData)
                return
                }
                
                OperationQueue.main.addOperation({  () -> Void in
                    self.climaLabel.text = weatherData.weather.capitalized
                    self.tempLabel.text = String(format: "%d", weatherData.temperature) + "\u{00B0}"
                })

        }
        completionHandler(NCUpdateResult.newData)
        
    }
    
}
