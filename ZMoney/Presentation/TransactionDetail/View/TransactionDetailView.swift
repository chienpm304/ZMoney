//
//  TransactionDetailView.swift
//  ZMoney
//
//  Created by Chien Pham on 29/08/2024.
//

import SwiftUI
import DomainModule

struct TransactionDetailView: View {
    @EnvironmentObject var appSettings: AppSettings
    @ObservedObject var viewModel: TransactionDetailViewModel
    @State private var showDeleteConfirmationDialog = false
    private let navigationType: NavigationType

    @FocusState private var focusedField: Bool

    init(
        viewModel: TransactionDetailViewModel,
        navigationType: NavigationType
    ) {
        self.viewModel = viewModel
        self.navigationType = navigationType
    }

    var body: some View {
        VStack {
            transactionTypeSection
            Form {
                transactionDetailsSection
                saveButtonSection
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button {
                    focusedField = false
                } label: {
                    Text("Done")
                }
            }
        }
        .navigationTitle(viewModel.isNewTransaction ? "Add Transaction" : "Edit Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: cancelButton)
        .navigationBarItems(trailing: deleteButton)
        .onAppear {
            viewModel.onViewAppear()
        }
        .resultAlert(alertData: $viewModel.alertData)
    }

    private var cancelButton: some View {
        HStack {
            if navigationType == .present {
                Button("Cancel", role: .cancel) {
                    viewModel.cancel()
                }
            }
        }
    }

    private var deleteButton: some View {
        HStack {
            if !viewModel.isNewTransaction {
                Button(role: .destructive) {
                    showDeleteConfirmationDialog = true
                } label: {
                    Text("Delete")
                        .foregroundColor(.red)
                }
                .confirmationDialog(
                    "Are you sure you want to delete this transaction?",
                    isPresented: $showDeleteConfirmationDialog,
                    titleVisibility: .visible
                ) {
                    Button("Yes, delete", role: .destructive) {
                        viewModel.delete()
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
    }

    private var leftColumsWidth: CGFloat { 80 }

    private var transactionTypeSection: some View {
        Section {
            if viewModel.isNewTransaction {
                transactionTypePicker
            }
        }
        .padding(.horizontal)
    }

    private var transactionDetailsSection: some View {
        Section {
            datePicker
            amountTextField
            memoTextField
            categoryPicker
        }
    }

    private var datePicker: some View {
        DatePicker(
            selection: $viewModel.transaction.inputTime,
            displayedComponents: .date
        ) {
            Text("Date")
                .fontWeight(.medium)
                .frame(width: leftColumsWidth, alignment: .leading)
        }
    }

    private var transactionTypePicker: some View {
        Picker("Tab", selection: $viewModel.transaction.transactionType) {
            ForEach(CategoryTab.allCases) {
                Text($0.localizedStringKey)
            }
        }
        .pickerStyle(.segmented)
    }

    private var amountTextField: some View {
        HStack {
            Text(viewModel.transaction.transactionType == .expense ? "Expense" : "Income")
                .fontWeight(.medium)
                .frame(width: leftColumsWidth, alignment: .leading)

            CurrencyTextField(amount: $viewModel.transaction.amount)

            Text(appSettings.currencySymbol)
        }
    }

    private var memoTextField: some View {
        HStack {
            Text("Note")
                .fontWeight(.medium)
                .frame(width: leftColumsWidth, alignment: .leading)
            TextField("Enter value", text: $viewModel.transaction.memo)
                .withFieldBackground()
                .focused($focusedField)
        }
    }

    private var categoryPicker: some View {
        CategoryPickerView(
            spacing: 8,
            items: viewModel.filteredCategories,
            selectedItem: $viewModel.transaction.category
        ) {
            viewModel.didTapEditCategory()
        }
    }

    private var saveButtonSection: some View {
        Section {
            Button {
                viewModel.save()
            } label: {
                Text("Save")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
            }
            .disabled(!viewModel.isSaveEnabled)
            .listRowBackground(
                viewModel.isSaveEnabled
                ? Color.accentColor
                : Color.accentColor.opacity(0.5)
            )
        }
    }
}

// #Preview {
//     VStack {
//         TransactionDetailView(
//             viewModel: .init()
//         )
//
//         Divider()
//
//         TransactionDetailView(
//             viewModel: .init(
//                 transaction: .init(
//                     inputTime: Date().timeValue,
//                     amount: 123456,
//                     memo: "hihi",
//                     category: .defaultIncomeCategories.first!
//                 )
//             )
//         )
//     }
//     .environmentObject(AppSettings())
// }

struct DateView: View {
    let date: Date

    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Text(date.formatDateMediumWithShortWeekday())
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.secondarySystemBackground)
        )
    }
}
