
import UIKit

class WeatherListViewController: UIViewController {
    
    @IBOutlet weak var addCityTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var forecastArray: Array<ForecastModel> = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CityWeatherCell", bundle: nil), forCellReuseIdentifier:"cityWeatherCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
    }
    
    func fetchForecastForCityByName(cityNameStr: String?) {
        if let cityName = cityNameStr {
            // check if non-empty
            guard !cityName.isEmpty else {
                print("Empty name")
                return
            }

            // check if city not added yet
            var alreadyInList = false
            if forecastArray.count > 0 {
                for case let forecast in forecastArray {
                    if (forecast.city == cityNameStr) {
                        alreadyInList = true
                    }
                }
            }
            guard !alreadyInList else {
                self.showAlert(title: "Warning", text: "This city is already in list", buttonText: "OK")
                addCityTextField.text = ""
                return
            }
            
            // call request
            ApiManager.fetchForecastForCityByNameApi(cityName: cityName, completion: {(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void in
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions(rawValue: 0))
                    guard let dictionary = jsonObject as? Dictionary<String, Any> else {
                        print("Not a Dictionary")
                        self.showAlert(title: "Server error", text: "Please try again", buttonText: "OK")
                        return
                    }
                    
                    print("JSON response: \(dictionary)")
                    
                    let forecast = ForecastModel.init(attributes: dictionary)
                    DispatchQueue.main.async {
                        self.addNewCity(forecast: forecast)
                    }
                }
                catch let error as NSError {
                    print("Found an error - \(error)")
                    self.showAlert(title: "Error", text: error.description, buttonText: "OK")
                }
                
            })
            
        }
    }
    
    @IBAction func addNewCityButtonPressed(sender: UIButton) {
        self.fetchForecastForCityByName(cityNameStr: addCityTextField.text)
    }
    
    func addNewCity(forecast: ForecastModel?) {
        forecastArray.append(forecast!)
        tableView.reloadData()
        addCityTextField.text = ""
    }

    
    func showAlert(title: String, text: String, buttonText: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension WeatherListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityWeatherCell") as! CityWeatherCell
        cell.updateWithForecast(forecast: forecastArray[indexPath.row])
        return cell
    }
}
