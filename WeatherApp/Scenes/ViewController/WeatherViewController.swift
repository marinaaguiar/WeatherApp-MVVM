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

    func updateLabels() {
        temperatureLabel.text = viewModel.getTemperature()
        locationTextLabel.text = viewModel.getLocationLabel()
        timeLabel.text = viewModel.getCurrentTimeAmPmFormat()
        dataTextLabel.text = viewModel.getCurrentDate()
        conditionDescription.text = viewModel.getConditionDescription()
        conditionImageView.image = UIImage(named: viewModel.getWeatherConditionImageName())
        conditionImageView.isHidden = false
    }

    func updateBackgroundColor(for condition: Condition) {

        var backgroundColor: UIColor {
                switch condition {
                case .thunderstorm:
                    return WeatherApp.Colors.thunderstormBackground
                case .drizzle:
                    return WeatherApp.Colors.drizzleBackground
                case .snow:
                    return WeatherApp.Colors.snowBackground
                case .fog:
                    return WeatherApp.Colors.fogBackground
                case .clearSky, .fewClouds, .rain:
                    if viewModel.isDay() {
                        return WeatherApp.Colors.clearDayBackground
                    } else {
                        return WeatherApp.Colors.clearNightBackground
                    }
                case .clouds:
                    return WeatherApp.Colors.cloudBackground
            }
        }

        view.backgroundColor = backgroundColor
    }

    func updatePromptTextMessage(for condition: Condition) {

        var promptTextMessage: String {
            switch condition {
            case .thunderstorm:
                return "stay safe!"
            case .drizzle:
                return "it's just a drizzle!"
            case .rain:
                return "you better have an umbrella!"
            case .snow:
                return "don't forget your coat!"
            case .fog:
                return "don't worry this fog will pass!"
            case .clearSky:
                if viewModel.isDay() {
                    return "have a bright day!"
                } else {
                    return "nighty night!"
                }
            case .fewClouds, .clouds:
                return "don't worry this cloud will pass!"
            }
        }

        promptTextLabel.text = promptTextMessage
    }

    func updateDarkOrLightMode(for condition: Condition) {

        var darkOrLightMode: UIUserInterfaceStyle {
            switch condition {
            case .thunderstorm, .snow, .drizzle, .fog, .clouds:
                return .light
            case .clearSky, .fewClouds, .rain:
                if viewModel.isDay() {
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
            case .success(_):
                let weatherCondition = self.viewModel.getWeatherCondition()
                self.stopLoading()
                self.updateLabels()
                self.updateBackgroundColor(for: weatherCondition)
                self.updatePromptTextMessage(for: weatherCondition)
                self.updateDarkOrLightMode(for: weatherCondition)
            case .error(let error as APIError):
                self.presentAlert(title: error.title, message: error.message, vc: self)
                self.stopLoading()
            case .error(_):
                self.presentAlert(title: "Unexpected Error", message: "", vc: self)
            }
        }
    }
}

