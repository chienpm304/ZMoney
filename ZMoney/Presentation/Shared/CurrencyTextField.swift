//
//  CurrencyTextField.swift
//  ZMoney
//
//  Created by Chien Pham on 03/09/2024.
//

import SwiftUI
import UIKit
import DomainModule

struct CurrencyTextField: View {
    @Binding var amount: MoneyValue
    @Binding var isFocused: Bool
    @EnvironmentObject private var appSettings: AppSettings

    var body: some View {
        _CurrencyTextField(
            amount: $amount,
            isFocused: $isFocused,
            numberFormatter: appSettings.currencyFormatterWithoutSymbol,
            maxDigits: appSettings.maxMoneyDigits
        )
        .withFieldBackground()
    }
}

// MARK: Private

private struct _CurrencyTextField: UIViewRepresentable {
    @Binding var amount: MoneyValue
    @Binding var isFocused: Bool
    let numberFormatter: NumberFormatter
    let maxDigits: Int

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.delegate = context.coordinator

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(
            title: NSLocalizedString("Done", comment: ""),
            style: .done,
            target: context.coordinator,
            action: #selector(Coordinator.doneButtonTapped)
        )

        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        toolbar.items = [flexibleSpace, doneButton]
        textField.inputAccessoryView = toolbar

        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textFieldDidChange(_:)),
            for: .editingChanged
        )
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        let formattedText = formatAmount(amount)
        if uiView.text != formattedText {
            uiView.text = formattedText
        }

        if isFocused && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        } else if !isFocused && uiView.isFirstResponder {
            uiView.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    private func formatAmount(_ amount: MoneyValue) -> String? {
        return numberFormatter.string(from: NSNumber(value: amount))
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: _CurrencyTextField

        init(_ parent: _CurrencyTextField) {
            self.parent = parent
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            let cleanText = textField.text?.filter { $0.isNumber } ?? "0"
            if cleanText.isEmpty {
                parent.amount = 0
                textField.text = "0"
                return
            }

            if cleanText.count <= parent.maxDigits, let value = MoneyValue(cleanText) {
                parent.amount = value
                textField.text = parent.formatAmount(parent.amount)
            } else {
                textField.text = parent.formatAmount(parent.amount)
            }
        }

        @objc func doneButtonTapped() {
            parent.isFocused = false
        }
    }
}

// MARK: Preview

#Preview {
    @State var amount1: MoneyValue = 0
    @State var amount2: MoneyValue = 9999

    @State var amountFocus1 = false
    @State var amountFocus2 = false

    return List {
        HStack {
            CurrencyTextField(amount: $amount1, isFocused: $amountFocus1)
            MoneyText(value: amount1, type: .expense)
        }
        HStack {
            CurrencyTextField(amount: $amount2, isFocused: $amountFocus2)
            MoneyText(value: amount2, type: .expense)
        }

        Button(action: {
            amountFocus1.toggle()
        }, label: {
            Text(String("amountFocus1: \(amountFocus1 ? "yes" : "no")"))
        })

        Button(action: {
            amountFocus2.toggle()
        }, label: {
            Text(String("amountFocus2: \(amountFocus2 ? "yes" : "no")"))
        })
    }
    .environmentObject(AppSettings.preview)
}
