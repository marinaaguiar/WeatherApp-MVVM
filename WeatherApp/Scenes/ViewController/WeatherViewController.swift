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

        view.backgroundColor = WeatherAppDS.Colors.backgroundColor
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

    func updateLabels(for item: WeatherViewItem) {
        temperatureLabel.text = item.temperature
        locationTextLabel.text = item.location
        timeLabel.text = item.timeAmPmFormat
        dataTextLabel.text = item.currentDate
        conditionDescription.text = item.conditionDescription
        conditionImageView.image = UIImage(named: item.conditionImageName)
        conditionImageView.isHidden = false
    }

    func updateBackgroundColor(for item: WeatherViewItem) {

        var backgroundColor: UIColor {
            switch item.weatherCondition {
                case .thunderstorm:
                    return WeatherAppDS.Colors.thunderstormBackground
                case .drizzle:
                    return WeatherAppDS.Colors.drizzleBackground
                case .snow:
                    return WeatherAppDS.Colors.snowBackground
                case .fog:
                    return WeatherAppDS.Colors.fogBackground
                case .clearSky, .fewClouds, .rain:
                if item.isDay {
                        return WeatherAppDS.Colors.clearDayBackground
                    } else {
                        return WeatherAppDS.Colors.clearNightBackground
                    }
                case .clouds:
                    return WeatherAppDS.Colors.cloudBackground
            }
        }

        view.backgroundColor = backgroundColor
    }

//    func updateBackgroundColor(for item: WeatherViewItem) {
////        let color: WeatherAppDS.Colors = item.backgroundColor
//        view.backgroundColor = WeatherAppDS.Colors()
//    }

    func updatePromptTextMessage(for item: WeatherViewItem) {
        promptTextLabel.text = item.promptMessage
    }

    func updateDarkOrLightMode(for item: WeatherViewItem) {

        var darkOrLightMode: UIUserInterfaceStyle {
            switch item.weatherCondition {
            case .thunderstorm, .snow, .drizzle, .fog, .clouds:
                return .light
            case .clearSky, .fewClouds, .rain:
                if item.isDay {
                    return .light
                } else {
                    return .dark
                }
            }
        }
        overrideUserInterfaceStyle = darkOrLightMode
    }
}

//MARK: - Alerts

extension WeatherViewController {

    func presentAlert(title: String, message: String, vc: UIViewController) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
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
        presentAlert(title: "Not able to fetch your location", message: "Check your internet connection", vc: self)
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
            case .success:
                self.stopLoading()
                guard let item = self.viewModel.getViewItem() else {
                    self.presentAlert(title: "Not able to fetch the data", message: "", vc: self)
                    return
                }
                self.updateLabels(for: item)
                self.updateBackgroundColor(for: item)
                self.updatePromptTextMessage(for: item)
                self.updateDarkOrLightMode(for: item)
            case .error(let error):
                self.presentAlert(title: error.title, message: error.message, vc: self)
                self.stopLoading()
            }
        }
    }
}

