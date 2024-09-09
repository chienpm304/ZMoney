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
    @EnvironmentObject private var appSettings: AppSettings

    var body: some View {
        _CurrencyTextField(
            amount: $amount,
            numberFormatter: appSettings.currencyFormatterWithoutSymbol,
            maxDigits: appSettings.maxMoneyDigits
        )
        .withFieldBackground()
    }
}

// MARK: Private

private struct _CurrencyTextField: UIViewRepresentable {
    @Binding var amount: MoneyValue
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
            target: textField,
            action: #selector(textField.resignFirstResponder)
        )

        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        let zeroZeroZeroButton = UIBarButtonItem(
            title: "000",
            style: .done,
            target: context.coordinator,
            action: #selector(Coordinator.zeroZeroZeroButtonTapped)
        )

        let zeroZeroButton = UIBarButtonItem(
            title: "00",
            style: .done,
            target: context.coordinator,
            action: #selector(Coordinator.zeroZeroButtonTapped)
        )

        toolbar.items = [
            zeroZeroZeroButton,
            flexibleSpace,
            zeroZeroButton,
            flexibleSpace,
            doneButton
        ]
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

        @objc func zeroZeroZeroButtonTapped() {
            appendZeros(3)
        }

        @objc func zeroZeroButtonTapped() {
            appendZeros(2)
        }

        private func appendZeros(_ count: Int) {
            guard (1...3).contains(count) else { return }
            let zeros = Array(repeating: "0", count: count).joined()
            let text = (String(parent.amount) + zeros).prefix(parent.maxDigits)

            if let value = MoneyValue(text) {
                parent.amount = value
            }
        }
    }
}

// MARK: Preview

#Preview {
    @State var amount1: MoneyValue = 0
    @State var amount2: MoneyValue = 9999

    return List {
        HStack {
            CurrencyTextField(amount: $amount1)
            MoneyText(value: amount1, type: .expense)
        }
        HStack {
            CurrencyTextField(amount: $amount2)
            MoneyText(value: amount2, type: .expense)
        }
    }
    .environmentObject(AppSettings.preview)
}
