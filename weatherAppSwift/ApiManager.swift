
import UIKit

let OWMAP_APIURL = "https://api.openweathermap.org/data/2.5/"
let APPID = "95b7f25ebb77962319a42203d3e297ce"

class ApiManager: NSObject {
    
    class func fetchForecastForCityByNameApi(cityName: String,
                                       completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let paramsString = String(format: "%@weather?q=%@&appid=%@", OWMAP_APIURL, cityName, APPID).addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        ApiManager.sendGETRequest(paramsString:paramsString!, completion: completion)
    }
    
    class func sendGETRequest(paramsString: String,
                       completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = URL(string: paramsString)
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            completion(data, response, error)
        }
        
        task.resume()
    }

}
