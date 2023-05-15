//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 7/27/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationTextLabel: UILabel!
    @IBOutlet weak var dataTextLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var promptTextLabel: UILabel!
    @IBOutlet weak var conditionDescription: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let locationManager = CLLocationManager()
    private let viewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        hideFields()
        startLoading()

        view.backgroundColor = WeatherApp.Colors.backgroundColor
        self.viewModel.delegate = self

        setupLocationManager()
        searchTextField.delegate = self

        //hide keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
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
        startLoading()
    }

    func startLoading() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        view.alpha = 0.5
        view.isUserInteractionEnabled = false
    }

    func stopLoading() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
        view.alpha = 1.0
        view.isUserInteractionEnabled = true
    }

    func updateLabels(with weather: WeatherModel) {
        temperatureLabel.text = weather.temperature
        locationTextLabel.text = "\(weather.cityName), \(weather.countryName)"
        timeLabel.text = weather.currentTimeAmPm
        dataTextLabel.text = weather.currentDate
        conditionDescription.text = weather.conditionDescription
        conditionImageView.image = UIImage(named: "\(weather.condition).day")
        print("\(weather.condition).day")
        conditionImageView.isHidden = false
        view.backgroundColor = weather.backgroundColor
        promptTextLabel.text = weather.promptTextMessage
        overrideUserInterfaceStyle = weather.darkOrLightMode
    }
}

//MARK: - Alerts

func errorAlert(title: String, message: String, vc: UIViewController) {

    let alert = UIAlertController(title: "OK", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            viewModel.loadWeatherData(latitude: lat, longitude: lon)

            print(lat)
            print(lon)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorAlert(title: "Not able to fetch your location", message: "Check your internet connection", vc: self)
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {

    @IBAction func searchPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            sender.alpha = 0.3
            sender.alpha = 1
        }

        if searchTextField.text != "" {
            hideFields()
            stopLoading()
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
            return true
            
        } else {
            textField.placeholder = "(e.g. New York, NY, US)"
            view.resignFirstResponder()
            return true
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            viewModel.loadWeatherData(cityName: city, countryName: city)
        }
        searchTextField.text = ""
    }
}
//MARK: - WeatherViewModelDelegate

extension WeatherViewController: WeatherViewModelDelegate {

    func didUpdate(with state: ViewState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            switch state {
            case .none:
                break
            case .loading:
                self.startLoading()
            case .success(let weatherModel):
                self.stopLoading()
                self.updateLabels(with: weatherModel)
            case .error(let error):
                errorAlert(title: "City Not Found", message: "Please, try again" , vc: self)
            }
        }
    }
}

