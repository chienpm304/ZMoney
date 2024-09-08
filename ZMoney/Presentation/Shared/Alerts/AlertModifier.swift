//
//  AlertModifier.swift
//  ZMoney
//
//  Created by Chien Pham on 07/09/2024.
//

import SwiftUI
import SwiftUI_SimpleToast

struct AlertModifier: ViewModifier {
    @Binding var alertData: AlertData?

    func body(content: Content) -> some View {
        content
            .simpleToast(item: $alertData, options: toastOptions) {
                alertData = nil
            } content: {
                if let alertData {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            if alertData.isSuccess {
                                HStack {
                                    Text("✅")
                                    Text(alertData.title)
                                        .fontWeight(.medium)
                                }
                                .lineLimit(1)
                            } else {
                                HStack {
                                    Text("❌")
                                    Text(alertData.title)
                                        .fontWeight(.medium)
                                }
                                .lineLimit(1)
                            }

                            Text(alertData.message ?? "")
                                .font(.caption)
                                .lineLimit(2)
                        }
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.adaptiveBackgroundColor)
                    .cornerRadius(8)
                    .padding()
                    .shadow(radius: 2, x: 1, y: 2)
                } else {
                    EmptyView()
                }
            }
    }

    private var toastOptions: SimpleToastOptions {
        let isSuccess = alertData?.isSuccess ?? false
        let isToast = alertData?.isToast ?? true
        let duration = isToast ? (isSuccess ? 2.0 : 3.0) : nil
        return SimpleToastOptions(
            alignment: isSuccess ? .bottom : .bottom,
            hideAfter: duration,
            backdrop: nil,
            animation: .default,
            modifierType: isSuccess ? .slide : .slide,
            dismissOnTap: true
        )
    }
}

extension View {
    func resultAlert(alertData: Binding<AlertData?>) -> some View {
        self.modifier(AlertModifier(alertData: alertData))
    }
}
