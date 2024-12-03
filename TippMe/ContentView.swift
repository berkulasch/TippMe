//
//  ContentView.swift
//  TippMe
//
//  Created by Berk Ulas on 23.10.24.
//

import SwiftUI

struct ContentView: View {
  
      @State private var billAmount = ""
      @State private var selectedTipPercentage = 0.0
      @State private var customTipAmount = ""
      @State private var totalWithTip = 0.0
      @State private var selectedCurrency = "USD" // Default currency

      let currencies = ["USD", "EUR", "TRY"] // Available currencies

      // Format total with the selected currency symbol
      var currencySymbol: String {
          switch selectedCurrency {
          case "EUR": return "€"
          case "TRY": return "₺"
          default: return "$"
          }
      }

      // Calculate total with tip (custom tip is a direct price now)
      var calculatedTotal: Double {
          let bill = Double(billAmount) ?? 0.0
          let customTip = Double(customTipAmount) ?? 0.0
          
          if customTip > 0 {
              return bill + customTip
          } else {
              return bill + (bill * selectedTipPercentage / 100)
          }
      }

      // Filter input for numbers only (and a single decimal point for bill amount and custom tip)
      func filterNumericInput(_ value: String, allowDecimal: Bool = false) -> String {
          let filtered = value.filter { $0.isNumber || (allowDecimal && $0 == ".") }
          if allowDecimal {
              let decimalCount = filtered.filter { $0 == "." }.count
              return decimalCount > 1 ? String(filtered.dropLast()) : filtered
          }
          return filtered
      }

      // Reset all values after confirmation
      func resetValues() {
          billAmount = ""
          selectedTipPercentage = 0.0
          customTipAmount = ""
          totalWithTip = 0.0
      }

      var body: some View {
          VStack(spacing: 20) {
              Text("Tipp Me!")
                  .font(.largeTitle)
                  .fontWeight(.bold)

              // Currency Picker
              HStack {
                  Text("Currency:")
                      .font(.headline)

                  Picker("Select Currency", selection: $selectedCurrency) {
                      ForEach(currencies, id: \.self) {
                          Text($0)
                      }
                  }
                  .pickerStyle(MenuPickerStyle()) // Use a menu-style picker for a drop-down effect
                  .padding(.horizontal)
              }

              // Bill amount input (numbers and decimal allowed)
              TextField("Enter bill amount", text: $billAmount)
                  .keyboardType(.decimalPad)
                  .onChange(of: billAmount) { newValue in
                      billAmount = filterNumericInput(newValue, allowDecimal: true)
                  }
                  .padding()
                  .background(Color(UIColor.secondarySystemBackground))
                  .cornerRadius(8)
                  .padding(.horizontal)

              // Slider for tip percentage
              VStack {
                  Text("Select Tip Percentage: \(Int(selectedTipPercentage))%")
                  Slider(value: $selectedTipPercentage, in: 0...100, step: 5)
                      .accentColor(.blue)
                      .padding(.horizontal)
                      .disabled(!customTipAmount.isEmpty) // Disable slider if custom tip is entered
              }

              // Custom tip amount input (direct price)
              TextField("Or enter custom tip amount", text: $customTipAmount)
                  .keyboardType(.decimalPad)
                  .onChange(of: customTipAmount) { newValue in
                      customTipAmount = filterNumericInput(newValue, allowDecimal: true)
                  }
                  .padding()
                  .background(Color(UIColor.secondarySystemBackground))
                  .cornerRadius(8)
                  .padding(.horizontal)
                  .disabled(selectedTipPercentage != 0) // Disable custom tip field if slider is used

              // Display the total amount dynamically with the selected currency
              Text("Total with Tip: \(currencySymbol)\(calculatedTotal, specifier: "%.2f")")
                  .font(.title)
                  .fontWeight(.semibold)

              // Confirm Button
              Button(action: {
                  totalWithTip = calculatedTotal
                  resetValues() // Reset all values after confirming
              }) {
                  Text("Confirm")
                      .frame(maxWidth: .infinity)
                      .padding()
                      .background(Color.blue)
                      .foregroundColor(.white)
                      .cornerRadius(8)
                      .padding(.horizontal)
              }
              .disabled(billAmount.isEmpty) // Disable button if bill amount is empty

              Spacer()
          }
          .padding()
          .onTapGesture {
              // Dismiss the keyboard when tapping outside the input fields
              UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
          }
      }}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
