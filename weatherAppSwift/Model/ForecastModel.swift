
import UIKit

class ForecastModel: NSObject {
    var city: String?
    var cityId: String?
    var tempMax: Int?
    var tempMin: Int?
    var desc: String?
    var weatherId: Int?
    var weatherIcon: String?
    
    convenience init(attributes:Dictionary<String, Any>) {
        self.init()
        
        for (key, value) in attributes {
            switch key {
            case "name":
                self.city = value as? String
            case "id":
                self.cityId = value as? String
            case "main":
                let mainDict = value as? Dictionary<String, Any>
                let tempMax = mainDict?["temp_max"] as! NSNumber
                self.tempMax = convertToCelsius(kelvinTemp: tempMax.floatValue)
                let tempMin = mainDict?["temp_min"] as! NSNumber
                self.tempMin = convertToCelsius(kelvinTemp: tempMin.floatValue)
            case "weather":
                let weatherArray = value as? Array<Dictionary<String, Any>>
                let weatherDefault = weatherArray?[0]
                self.desc = weatherDefault?["main"] as? String
                self.weatherId = weatherDefault?["id"] as? Int
                self.weatherIcon = weatherDefault?["icon"] as? String
            default:
                break;
            }
        }
    }
}

func convertToCelsius(kelvinTemp: Float) -> Int {
    return Int(kelvinTemp - 273.15)
}
