
import UIKit

class CityWeatherCell: UITableViewCell {

    @IBOutlet weak var cellTitleLabel : UILabel?
    @IBOutlet weak var cellTempMaxLabel : UILabel?
    @IBOutlet weak var cellTempMinLabel : UILabel?
    @IBOutlet weak var cellWeatherDescLabel : UILabel?
    
    @IBOutlet weak var cellWeatherImageView : UIImageView?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateWithForecast(forecast: ForecastModel?) {
        cellTitleLabel?.text = forecast?.city
        cellWeatherDescLabel?.text = forecast?.desc
        
        if let tempMax = forecast?.tempMax {
            cellTempMaxLabel?.text = String(tempMax).appending("°")
        }
        if let tempMin = forecast?.tempMin {
            cellTempMinLabel?.text = String(tempMin).appending("°")
        }
        if let weatherIcon = forecast?.weatherIcon {
            cellWeatherImageView?.image = UIImage(named: weatherIcon)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
