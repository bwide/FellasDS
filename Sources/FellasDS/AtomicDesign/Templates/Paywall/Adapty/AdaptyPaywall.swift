//
//  PaywallView.swift
//  Adapty-Demo
//
//  Created by Elena Gordienko on 01.08.22.
//  Copyright © 2022 Adapty. All rights reserved.
//

import Adapty
import Foundation
import SwiftUI
import FellasStoreKit

struct AdaptyPaywall<PaywallService: PaywallServicing>: View {
    
    @Environment(\.paywallContent) private var paywallContent
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.subscriptionStatus) private var subscriptionStatus
    
    @EnvironmentObject var paywallService: PaywallService
    @EnvironmentObject var userService: UserService
    
    @State private var isLoading: Bool = false
    @State private var errorAlertMessage: String?
    @State private var shouldShowErrorAlert: Bool = false
    @State private var alertMessage: String?
    @State private var shouldShowAlert: Bool = false
    
    @State private var selectedProduct: ProductItemModel? = nil
    @State private var isFreeTrial: Bool = true

    // MARK: - body

    var body: some View {
        ZStack {
            paywall
                .disabled(isLoading)
            progressView
                .isHidden(!isLoading)
        }
        .onAppear { paywallService.logPaywallDisplay() }
        .onChange(of: isFreeTrial) { _,_ in onUpdateFreeTrial() }
        .onChange(of: selectedProduct) { _,_ in onUpdateSelected() }
        .onChange(of: paywallService.paywallViewModel?.productModels, initial: true) {
            onUpdateProducts()
        }
    }
    
    var paywall: some View {
        VStack(spacing: .zero) {
            if let paywallContent {
                marketingContent(paywallContent)
                    .background {
                        Color.ds.brand.primary.ignoresSafeArea()
                    }
            }
            buttonGroup
                .background {
                    LinearGradient(
                        colors: [.ds.brand.primary, .ds.background.tertiary],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                }
        }
    }

    // MARK: - top close button

    var topCloseButton: some View {
        HStack {
            Spacer()
            Button(
                role: .destructive,
                action: {
                    presentationMode.wrappedValue.dismiss()
                },
                label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.regularMaterial)
                }
            )
        }
        .safeAreaPadding(.top)
    }

    // MARK: - description
    
    @ViewBuilder
    func marketingContent(_ content: PaywallContent) -> some View {
        VStack(alignment: .leading, spacing: .ds.spacing.medium) {
//            topCloseButton //hard paywall
            Label(
                title: { Text(Strings.paywallTitle) },
                icon: { descriptionIcon }
            )
                .textStyle(ds: .largeTitle)
            
            content.paywallLabels
        }
        .padding(.horizontal, ds: .large)
        .multilineTextAlignment(.leading)
        .textStyle(ds: .body)
    }
    
    var descriptionIcon: Image {
        guard let vm = paywallService.paywallViewModel else { return Image(systemName: "square.and.arrow.up") }
        return Image(systemName: vm.iconName)
    }

    // MARK: - button group

    @ViewBuilder
    var buttonGroup: some View {
        if let model = paywallService.paywallViewModel {
            VStack(spacing: .zero) {
                Spacer()
                
                Toggle(Strings.freeTrialToggle, isOn: $isFreeTrial)
                    .textStyle(ds: .title2)
                    .padding(.ds.spacing.medium)
                
                DSPicker(selection: $selectedProduct) {
                    ForEach(model.productModels, id: \.self) { product in
                        label(for: product)
                    }
                }
                .dsPickerStyle(.verticalBackground)
                
                buyButton
                footerSection
            }
            .padding()
        } else {
            Color.clear
        }
    }
    
    // MARK: - Product
    @ViewBuilder
    func label(for product: ProductItemModel) -> some View {
        HStack(alignment: .bottom) {
            Spacer()
            Text(product.period)
                .textStyle(ds: .title2)
            Text("/ \(product.priceString)")
                .textStyle(ds: .headline)
            Spacer()
        }
        .padding(.ds.spacing.xxSmall)
        .foregroundColor(buyButtonTextColor)
    }
    

    // MARK: - buyButton

    @ViewBuilder
    var buyButton: some View {
        Button(
            action: { purchase() },
            label: {
                Text(buyButtonText)
            }
        )
        .buttonStyle(.dsAction)
        .padding(.vertical, ds: .xxLarge)
    }

    // MARK: - restore button

    var footerSection: some View {
        HStack {
            Link(Strings.termsOfUse, destination: termsOfUse)
            Link(Strings.privacyPolicy, destination: privacyPolicy)
            Button(Strings.restore, action: { restoreTapped() })
                .foregroundColor(textColor)
        }
        .font(.title3)
    }

    // MARK: - progress view

    var progressView: some View {
        ZStack {
            Color.ds.background.primary.ignoresSafeArea().opacity(0.3)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.ds.text.background.primary))
                .scaleEffect(1.5, anchor: .center)
                .animation(.easeOut, value: isLoading)
        }
        .alert(errorAlertMessage ?? Strings.error, isPresented: $shouldShowErrorAlert) {
            Button(Strings.ok, role: .cancel) {
                errorAlertMessage = nil
                shouldShowErrorAlert = false
            }
        }
        .alert(alertMessage ?? Strings.success, isPresented: $shouldShowAlert) {
            Button(Strings.ok, role: .cancel) {
                alertMessage = nil
                shouldShowAlert = false
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

extension AdaptyPaywall {
    func purchase() {
        guard
            let selectedProduct,
            let products = paywallService.paywallProducts,
            let product = products.first(where: { $0.vendorProductId == selectedProduct.id })
        else {
            updateErrorAlert(isShown: true, title: Strings.noProduct)
            return
        }
        
        isLoading = true
        
        userService.makePurchase(for: product) { succeeded, error in
            isLoading = false
            
            guard succeeded else {
                error.map { print($0) }
                return
            }
            alertMessage = Strings.success
            shouldShowAlert = true
        }
    }
    
    func restoreTapped() {
        isLoading = true
        
        userService.restorePurchases { isPremium, error in
            isLoading = false
            
            guard error == nil else {
                errorAlertMessage = Strings.restoreAlertError
                shouldShowErrorAlert = true
                return
            }
            
            alertMessage = isPremium
            ? Strings.restoreAlertSuccessPremium
            : Strings.restoreAlertSuccessNotPremium
            
            shouldShowAlert = true
        }
    }
    
    private func updateErrorAlert(isShown: Bool, title: String) {
        errorAlertMessage = title
        shouldShowErrorAlert = isShown
    }
    
    private func onUpdateFreeTrial() {
        selectProduct()
    }
    
    private func onUpdateSelected() {
        isFreeTrial = selectedProduct?.introductoryDiscount != nil
    }
    
    private func onUpdateProducts() {
        selectProduct()
    }
    
    private func selectProduct() {
        guard let product = paywallService.paywallViewModel?
            .productModels
            .first(where: {
                isFreeTrial
                ? $0.introductoryDiscount != nil
                : $0.introductoryDiscount == nil
            }) else { return }
        
        selectedProduct = product
    }
}

// MARK: - Colors

extension AdaptyPaywall {
    var backgorundColor: Color {
//        paywallService.paywallViewModel?.backgroundColor ??
        Color.ds.brand.secondary
    }

    var textColor: Color {
//        paywallService.paywallViewModel?.textColor ??
        Color.ds.text.background.primary
    }
    
    var buyButtonText: String {
        isFreeTrial ? Strings.subscribeFreeTrial : Strings.subscribe
    }

    var buyButtonTextColor: Color {
//        paywallService.paywallViewModel?.buyButtonStyle.buttonTextColor ??
        Color.ds.brand.secondary
    }

    var buyButtonColor: Color {
//        paywallService.paywallViewModel?.buyButtonStyle.buttonColor ??
        Color.ds.text.background.primary
    }
    
    var privacyPolicy: URL {
        URL(
            string: "https://madduck.com/wp-content/uploads/2022/11/Publishing-Privacy-Policy.pdf"
        )!
    }
    var termsOfUse: URL {
        URL(
            string: "https://madduck.com/terms-of-use/"
        )!
    }
}

// MARK: - preview

#Preview {
    
    struct MockSubscriptions: SubscriptionIdentifying {
        var adaptyAPIKey: String? = "public_live_8v7C0A1S.5szHELZbG2nprTmjotym"
        
        var group: String = "A3B522EF"
        
        var subscriptions: [String] = [
            "company.fellas.bible.month",
            "company.fellas.bible.month"
        ]
        
        func identify(productID: FellasStoreKit.ProductID) -> FellasStoreKit.SubscriptionStatus {
            productID.starts(with: "fellasds.premium")
            ? .subscribed
            : .notSubscribed
        }
        
        
    }
    
    return NavigationStack {
        Paywall()
            .withPaywallContent(paywallType: .mockAdapty) {
                Text(verbatim: "Et natus aut ipsa saepe neque vitae. Veniam in facere nam quam vitae ut. Ipsum quisquam reprehenderit quo quod")
                Label(String(stringLiteral: "Label 1"), systemImage: "checkmark")
                Label(String(stringLiteral: "Label 2"), systemImage: "checkmark")
                Label(String(stringLiteral: "Label 3"), systemImage: "checkmark")
            }
            .withSubscriptionService(
                identifiers: MockSubscriptions(),
                mock: .notSubscribed
            )
    }
}

extension String {
    var optional: String? {
        Optional.some(self)
    }
}
