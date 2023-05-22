//
//  ViewItem.swift
//  WeatherApp
//
//  Created by Marina Aguiar on 5/22/23.
//

import Foundation

struct WeatherViewItem {

    let temperature: String
    let location: String
    let timeAmPmFormat: String
    let currentDate: String
    let conditionDescription: String
    let conditionImageName: String
    let weatherCondition: Condition
    let isDay: Bool
    let promptMessage: String
//    let backgroundColor: BackgroundColorCondition
}

enum BackgroundColorCondition: CaseIterable {
    case backgroundColor
    case thunderstormBackground
    case drizzleBackground
    case snowBackground
    case fogBackground
    case clearDayBackground
    case clearNightBackground
    case cloudBackground
}
