//
//  ContentView.swift
//  Challenge1
//
//  Created by Vishrut Jha on 4/26/24.
//

import SwiftUI

struct ContentView: View {
    let unitDictionary: [String: [String: String]] = [
        "Length": ["meter": "m", "kilometer": "km", "feet": "ft", "yard": "yd", "mile": "mi"],
        "Temperature": ["Kelvin": "K", "Celsius": "°C", "Fahrenheit": "°F"],
        "Volume": ["liters": "L", "milliliters": "mL", "cups": "cups", "pints": "pt", "gallons": "gal"],
        "Time": ["seconds": "s", "minutes": "min", "hours": "hr", "days": "d"]
    ]
    
    @State private var selectedCategory: String = "Length"
    @State private var inputUnit: String = "meter"
    @State private var outputUnit: String = "kilometer"
    @State private var inputValue: Double = 0
    @State private var outputValue: Double = 0
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    Picker("Measurement", selection: $selectedCategory){
                        ForEach(unitDictionary.keys.sorted(), id: \.self){
                            Text($0)
                        }
                    }
                }
//                .pickerStyle(.segmented)
                .onChange(of: selectedCategory) { newCategory, _ in
                    updateUnits(for: newCategory)
                }
                
                Section("Input") {
                    TextField("Value", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                    
                    Picker("From Unit", selection: $inputUnit) {
                        ForEach(unitDictionary[selectedCategory]!.keys.sorted(), id: \.self) {
                            Text("\($0) (\(unitDictionary[selectedCategory]![$0]!))")
                        }
                    }
//                    .pickerStyle(.wheel)
                }
                
                Section("Output") {
                    Text("\(outputValue, specifier: "%.2f") \(unitDictionary[selectedCategory]?[outputUnit] ?? "")")
                    
                    Picker("To Unit", selection: $outputUnit) {
                        ForEach(unitDictionary[selectedCategory]!.keys.sorted(), id: \.self) {
                            Text("\($0) (\(unitDictionary[selectedCategory]![$0]!))")
                        }
                    }
//                    .pickerStyle(.wheel)
                }
            }
            .navigationTitle("Converter Pro Max+")
            .onChange(of: inputUnit) { _, _ in convert() }
            .onChange(of: outputUnit) { _, _ in convert() }
            .onChange(of: inputValue) { _, _ in convert() }
        }
    }
    
    private func updateUnits(for category: String) {
        if let units = unitDictionary[category] {
            inputUnit = units.keys.first ?? ""
            outputUnit = units.keys.first ?? ""
        }
    }
    
    // helper functions
    func convert() {
        switch selectedCategory {
            case "Length":
                convertLength()
            case "Temperature":
                convertTemperature()
            case "Volume":
                convertVolume()
            case "Time":
                convertTime()
            default:
                outputValue = inputValue // Default case if no category matches
        }
    }
    
    func convertLength() {
        let inputInMeters: Double
        switch inputUnit {
            case "meter":
                inputInMeters = inputValue
            case "kilometer":
                inputInMeters = inputValue * 1000
            case "feet":
                inputInMeters = inputValue / 3.28084
            case "yard":
                inputInMeters = inputValue / 1.09361
            case "mile":
                inputInMeters = inputValue * 1609.34
            default:
                inputInMeters = inputValue // Fallback to raw input if unit unrecognized
        }
        
            // Convert from meters to the output unit
        switch outputUnit {
            case "meter":
                outputValue = inputInMeters
            case "kilometer":
                outputValue = inputInMeters / 1000
            case "feet":
                outputValue = inputInMeters * 3.28084
            case "yard":
                outputValue = inputInMeters * 1.09361
            case "mile":
                outputValue = inputInMeters / 1609.34
            default:
                outputValue = inputInMeters // Fallback if unit unrecognized
        }
    }
    
    func convertTemperature() {
        let inputInCelsius: Double
        switch inputUnit {
            case "Kelvin":
                inputInCelsius = inputValue - 273.15
            case "Celsius":
                inputInCelsius = inputValue
            case "Fahrenheit":
                inputInCelsius = (inputValue - 32) * 5 / 9
            default:
                inputInCelsius = inputValue
        }
        
        switch outputUnit {
            case "Kelvin":
                outputValue = inputInCelsius + 273.15
            case "Celsius":
                outputValue = inputInCelsius
            case "Fahrenheit":
                outputValue = (inputInCelsius * 9 / 5) + 32
            default:
                outputValue = inputInCelsius
        }
    }
    
    func convertVolume() {
        let inputInLiters: Double
        switch inputUnit {
            case "liters":
                inputInLiters = inputValue
            case "milliliters":
                inputInLiters = inputValue / 1000.0  // 1000 milliliters in a liter
            case "cups":
                inputInLiters = inputValue * 0.236588  // 1 cup is approximately 0.236588 liters
            case "pints":
                inputInLiters = inputValue * 0.473176  // 1 pint is approximately 0.473176 liters
            case "gallons":
                inputInLiters = inputValue * 3.78541  // 1 US gallon is approximately 3.78541 liters
            default:
                inputInLiters = inputValue  // Fallback to raw input if unit unrecognized
        }
        
            // Convert from liters to the output unit
        switch outputUnit {
            case "liters":
                outputValue = inputInLiters
            case "milliliters":
                outputValue = inputInLiters * 1000.0  // Convert liters to milliliters
            case "cups":
                outputValue = inputInLiters / 0.236588  // Convert liters to cups
            case "pints":
                outputValue = inputInLiters / 0.473176  // Convert liters to pints
            case "gallons":
                outputValue = inputInLiters / 3.78541  // Convert liters to gallons
            default:
                outputValue = inputInLiters  // Fallback if unit unrecognized
        }
    }
    
    func convertTime() {
        let inputInSeconds: Double
        switch inputUnit {
            case "seconds":
                inputInSeconds = inputValue
            case "minutes":
                inputInSeconds = inputValue * 60
            case "hours":
                inputInSeconds = inputValue * 3600
            case "days":
                inputInSeconds = inputValue * 86400
            default:
                inputInSeconds = inputValue
        }
        
        switch outputUnit {
            case "seconds":
                outputValue = inputInSeconds
            case "minutes":
                outputValue = inputInSeconds / 60
            case "hours":
                outputValue = inputInSeconds / 3600
            case "days":
                outputValue = inputInSeconds / 86400
            default:
                outputValue = inputInSeconds
        }
    }
}

#Preview {
    ContentView()
}
