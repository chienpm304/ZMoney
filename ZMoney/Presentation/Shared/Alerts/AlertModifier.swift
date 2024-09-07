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
                    VStack(alignment: .leading, spacing: 8) {
                        if alertData.isSuccess {
                            Text("✅ \(alertData.title)")
                                .fontWeight(.medium)
                        } else {
                            Text("❌ \(alertData.title)")
                                .fontWeight(.semibold)
                                .lineLimit(1)
                        }
                        Text(alertData.message ?? "")
                            .font(.caption)
                            .lineLimit(2)
                    }
                    .padding()
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(8)
                    .shadow(radius: 2)
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
            alignment: isSuccess ? .center : .bottom,
            hideAfter: duration,
            backdrop: nil,
            animation: .default,
            modifierType: isSuccess ? .fade : .slide,
            dismissOnTap: true
        )
    }
}

extension View {
    func resultAlert(alertData: Binding<AlertData?>) -> some View {
        self.modifier(AlertModifier(alertData: alertData))
    }
}
