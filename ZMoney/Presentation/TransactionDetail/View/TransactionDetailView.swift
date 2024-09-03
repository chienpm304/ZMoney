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

    var body: some View {
        NavigationView {
            Form {
                transactionDetailsSection
                saveButtonSection
            }
            .navigationTitle(viewModel.isNewTransaction ? "Add Transaction" : "Edit Transaction")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var leftColumsWidth: CGFloat { 80 }

    private var transactionDetailsSection: some View {
        Section(header: Text("Transaction Details")) {
            if viewModel.isNewTransaction {
                transactionTypePicker
            } else {
                transactionTypeDisplay
            }

            datePicker
            amountTextField
            memoTextField
            categoryPicker
        }
    }

    private var datePicker: some View {
        DatePicker(selection: $viewModel.transaction.inputTime, displayedComponents: .date) {
            Text("Date")
                .fontWeight(.medium)
                .frame(width: leftColumsWidth, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
    }

    private var transactionTypePicker: some View {
        Picker("Tab", selection: $viewModel.transaction.transactionType) {
            ForEach(CategoryTab.allCases) {
                Text($0.rawValue.capitalized)
            }
        }
        .pickerStyle(.segmented)
    }

    private var transactionTypeDisplay: some View {
        HStack {
            Text("Type")
                .fontWeight(.medium)
                .frame(width: leftColumsWidth, alignment: .leading)
            Spacer()
            Text(viewModel.transaction.transactionType == .expense ? "Expense" : "Income")
                .foregroundColor(.gray)
        }
    }

    private var amountTextField: some View {
        HStack {
            Text(viewModel.transaction.transactionType == .expense ? "Expense" : "Income")
                .fontWeight(.medium)
                .frame(width: leftColumsWidth, alignment: .leading)

            CurrencyTextField(
                "Amount",
                amount: $viewModel.transaction.amount
            )
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.fieldBackground)
            )

            Text(appSettings.currencySymbol)
        }
    }

    private var memoTextField: some View {
        HStack {
            Text("Note")
                .fontWeight(.medium)
                .frame(width: leftColumsWidth, alignment: .leading)
            TextField("Enter value", text: $viewModel.transaction.memo)
        }
    }

    private var categoryPicker: some View {
        Picker("Category", selection: $viewModel.transaction.category) {
            ForEach(viewModel.filteredCategories, id: \.id) { category in
                HStack {
                    Text(category.icon)
                    Text(category.name)
                }
                .tag(category)
            }
        }
    }

    private var saveButtonSection: some View {
        Section {
            Button {
                viewModel.save()
            } label: {
                Text("Save")
                    .foregroundColor(.white)
                    .padding(.vertical, 2)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
            }
            .disabled(!viewModel.isSaveEnabled)
            .listRowBackground(viewModel.isSaveEnabled ? Color.blue : Color.gray)
        }
    }
}

#Preview {
    VStack {
        TransactionDetailView(
            viewModel: .init()
        )

        Divider()

        TransactionDetailView(
            viewModel: .init(
                transaction: .init(
                    inputTime: Date().timeValue,
                    amount: 123456,
                    memo: "hihi",
                    category: .defaultIncomeCategories.first!
                )
            )
        )
    }
    .environmentObject(AppSettings())
}
