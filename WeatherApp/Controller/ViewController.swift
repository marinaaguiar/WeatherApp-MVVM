//
//  ViewController.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 7/27/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationTextLabel: UILabel!
    @IBOutlet weak var dataTextLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var promptTextLabel: UILabel!
    @IBOutlet weak var conditionDescription: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideFields()
        isLoading(true)
        
        view.backgroundColor = WeatherApp.Colors.backgroundColor
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        //hide keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func hideFields() {
        searchTextField.text = ""
        timeLabel.text = ""
        locationTextLabel.text = ""
        dataTextLabel.text = ""
        conditionDescription.text = ""
        promptTextLabel.text = ""
        temperatureLabel.text = ""
        conditionImageView.isHidden = true
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
        UIView.animate(withDuration: 0.5) {
            sender.alpha = 0.3
            sender.alpha = 1
        }
        isLoading(true)
        
    }
    
    func isLoading(_ sender: Bool) {
        if sender == true {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            view.alpha = 0.5
            view.isUserInteractionEnabled = false
        } else {
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
            view.alpha = 1.0
            view.isUserInteractionEnabled = true
        }
    }

}
   

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
   
    @IBAction func searchPressed(_ sender: UIButton) {
        //        print(searchTextField.text!)
        
        UIView.animate(withDuration: 0.5) {
            sender.alpha = 0.3
            sender.alpha = 1
        }

        if searchTextField.text != "" {
            hideFields()
            isLoading(false)
            
        }
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        searchTextField.endEditing(true)
        
        return true
        }
        
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
                
        if textField.text != "" {
            locationTextLabel.text = ""
            timeLabel.text = ""
            dataTextLabel.text = ""
            conditionDescription.text = ""
            promptTextLabel.text = ""
            temperatureLabel.text = ""
            conditionImageView.isHidden = true
//            hideFields()
            return true
            
        } else {
            textField.placeholder = "(e.g. New York, NY, US)"
            view.resignFirstResponder()
            return true
        }
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city, countryName: city)
        }
        searchTextField.text = ""
    }
}


//MARK: - WeatherManagerDelegate

    extension ViewController: WeatherManagerDelegate {
       
        func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.temperature
                self.locationTextLabel.text = "\(weather.cityName), \(weather.countryName)"
                self.timeLabel.text = weather.currentTimeAmPm
                self.dataTextLabel.text = weather.currentDate
                self.conditionDescription.text = weather.conditionDescription
                self.conditionImageView.image = UIImage(named: "\(weather.condition).day")
                self.conditionImageView.isHidden = false
                self.view.backgroundColor = weather.backgroundColor
                self.promptTextLabel.text = weather.promptTextMessage
                self.overrideUserInterfaceStyle = weather.darkOrLightMode
                self.isLoading(false)


            }
        }
        
        func errorAlert(title: String, message: String, vc: UIViewController) {
            
            let alert = UIAlertController(title: "OK", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        
        func didFailWithError(error: Error) {
            errorAlert(title: "City Not Found", message: "Please, try again" , vc: self)
            print(error)
        }
        
    }


//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            
            print(lat)
            print(lon)
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
