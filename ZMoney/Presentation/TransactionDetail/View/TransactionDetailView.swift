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
            VStack {
                transactionTypeSection
                Form {
                    transactionDetailsSection
                    saveButtonSection
                }
            }
            .navigationTitle(viewModel.isNewTransaction ? "Add Transaction" : "Edit Transaction")
            .navigationBarTitleDisplayMode(.inline)
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
        Section(header: Text("Transaction Details")) {
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
//        HStack {
//            Text("Date")
//                .fontWeight(.medium)
//                .frame(width: leftColumsWidth, alignment: .leading)
//            Spacer()
//            DateView(date: viewModel.transaction.inputTime)
//        }
    }

    private var transactionTypePicker: some View {
        Picker("Tab", selection: $viewModel.transaction.transactionType) {
            ForEach(CategoryTab.allCases) {
                Text($0.rawValue.capitalized)
            }
        }
        .pickerStyle(.segmented)
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
            .withFieldBackground()

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
