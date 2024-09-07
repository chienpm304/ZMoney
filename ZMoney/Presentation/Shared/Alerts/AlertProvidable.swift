//
//  AlertProvidable.swift
//  ZMoney
//
//  Created by Chien Pham on 07/09/2024.
//

import Combine
import DomainModule

protocol AlertProvidable: ObservableObject {
    var alertData: AlertData? { get set }

    func showAlert<T>(with result: Result<T, DMError>, successMessage: String?, errorMessage: String?)
    func showSuccessAlert(with successMessage: String?)
    func showErrorAlert(with error: DMError, errorMessage: String?)
}

extension AlertProvidable {
    func showAlert<T>(
        with result: Result<T, DMError>,
        successMessage: String? = nil,
        errorMessage: String? = nil
    ) {
        switch result {
        case .success(_):
            showSuccessAlert(with: successMessage)
        case .failure(let error):
            showErrorAlert(with: error, errorMessage: errorMessage)
        }
    }

    func showSuccessAlert(with successMessage: String? = nil) {
        alertData = AlertData(
            title: "Success",
            message: successMessage,
            isSuccess: true,
            isToast: true
        )
    }

    func showErrorAlert(with error: DMError, errorMessage: String? = nil) {
        alertData = AlertData(
            title: "Error",
            message: errorMessage ?? error.localizedDescription,
            isSuccess: false,
            isToast: true
        )
    }
}
