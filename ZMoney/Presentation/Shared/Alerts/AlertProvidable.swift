//
//  AlertProvidable.swift
//  ZMoney
//
//  Created by Chien Pham on 07/09/2024.
//

import Combine
import DomainModule
import SwiftUI

protocol AlertProvidable: ObservableObject {
    var alertData: AlertData? { get set }

    func showAlert<T>(
        with result: Result<T, DMError>,
        successMessage: LocalizedStringKey?,
        errorMessage: LocalizedStringKey?
    )
    func showSuccessAlert(with successMessage: LocalizedStringKey?)
    func showErrorAlert(with error: DMError, errorMessage: LocalizedStringKey?)
}

// swiftlint:disable empty_enum_arguments

extension AlertProvidable {
    func showAlert<T>(
        with result: Result<T, DMError>,
        successMessage: LocalizedStringKey? = nil,
        errorMessage: LocalizedStringKey? = nil
    ) {
        switch result {
        case .success(_):
            showSuccessAlert(with: successMessage)
        case .failure(let error):
            showErrorAlert(with: error, errorMessage: errorMessage)
        }
    }

    func showSuccessAlert(with successMessage: LocalizedStringKey? = nil) {
        alertData = AlertData(
            title: "Success",
            message: successMessage,
            isSuccess: true,
            isToast: true
        )
    }

    func showErrorAlert(with error: DMError, errorMessage: LocalizedStringKey? = nil) {
        alertData = AlertData(
            title: "Error",
            message: errorMessage ?? LocalizedStringKey(error.localizedDescription),
            isSuccess: false,
            isToast: true
        )
    }
}

// swiftlint:enable empty_enum_arguments
