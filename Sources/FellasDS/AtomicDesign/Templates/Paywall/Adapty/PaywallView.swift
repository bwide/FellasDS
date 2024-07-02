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

struct PaywallView: View {
    
    @Environment(\.paywallContent) private var paywallContent
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var paywallService: PaywallService
    @EnvironmentObject var userService: UserService
    @State var isLoading: Bool = false
    @State var errorAlertMessage: String?
    @State var shouldShowErrorAlert: Bool = false
    @State var alertMessage: String?
    @State var shouldShowAlert: Bool = false

    // MARK: - body

    var body: some View {
        ZStack {
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
                    }
            }
            .disabled(isLoading)
            progressView
                .isHidden(!isLoading)
        }.onAppear {
            paywallService.logPaywallDisplay()
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
    }

    // MARK: - description
    
    @ViewBuilder
    func marketingContent(_ content: PaywallContent) -> some View {
        VStack(alignment: .leading, spacing: .ds.spacing.medium) {
            topCloseButton
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
        if let iconName = paywallService.paywallViewModel?.iconName {
            Image(iconName)
        } else {
            Image(systemName: "crown.fill")
        }
    }

    // MARK: - button group

    var buttonGroup: some View {
        VStack {
            HStack(alignment: .center, spacing: 12) {
                let model = paywallService.paywallViewModel
                ForEach(model?.productModels ?? [], id: \.id) { product in
                    buyButton(title: model?.buyActionTitle ?? "", product: product)
                }
            }
            Spacer()
            restoreButton
        }
        .padding()
    }

    // MARK: - buyButton

    func buyButton(title: String, product: ProductItemModel) -> some View {
        Button(
            action: {
                guard
                    let product = paywallService.paywallProducts?.first(where: { $0.vendorProductId == product.id })
                else {
                    updateErrorAlert(isShown: true, title: "No product found")
                    return
                }
                isLoading = true
                userService.makePurchase(for: product) { succeeded, error in
                    isLoading = false
                    guard succeeded else {
                        error.map { print($0) }
                        return
                    }
                    alertMessage = "Success!"
                    shouldShowAlert = true
                }
            },
            label: { buyButtonLabel(title: title, product: product) }
        )
    }

    func buyButtonLabel(title: String, product: ProductItemModel) -> some View {
        let discount = product.introductoryDiscount
        let discountText = discount.map { "\($0.localizedPeriod) for \($0.localizedPrice)"} ?? ""
        return ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(buyButtonColor)
            VStack {
                Text(product.period)
                    .font(.title)
                Text(title)
                    .font(.body)
                Text(product.priceString)
                    .font(.title2)
                Text(discountText)
                    .font(.title3)
                    .lineLimit(2)
                    .padding(.top, 10)
                    .isHidden(discount == nil, removeIfHidden: true)
            }
            .padding()
            .foregroundColor(buyButtonTextColor)
        }.frame(maxHeight: 200, alignment: .center)
    }

    // MARK: - restore button

    var restoreButton: some View {
        Button(
            role: .none,
            action: {
                isLoading = true
                userService.restorePurchases { isPremium, error in
                    isLoading = false
                    guard error == nil else {
                        errorAlertMessage = "Could not restore purchases."
                        shouldShowErrorAlert = true
                        return
                    }
                    alertMessage = "Successfully restored purchases!"
                    shouldShowAlert = true
                }
            },
            label: {
                Text(paywallService.paywallViewModel?.restoreActionTitle ?? "restore")
                    .font(.title3)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(textColor)
            }
        )
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
        .alert(errorAlertMessage ?? "Error occurred", isPresented: $shouldShowErrorAlert) {
            Button("OK", role: .cancel) {
                errorAlertMessage = nil
                shouldShowErrorAlert = false
            }
        }
        .alert(alertMessage ?? "Success!", isPresented: $shouldShowAlert) {
            Button("OK", role: .cancel) {
                alertMessage = nil
                shouldShowAlert = false
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    private func updateErrorAlert(isShown: Bool, title: String) {
        errorAlertMessage = title
        shouldShowErrorAlert = isShown
    }
}

// MARK: - Colors

extension PaywallView {
    var backgorundColor: Color {
        paywallService.paywallViewModel?.backgroundColor ?? Color.ds.brand.secondary
    }

    var textColor: Color {
        paywallService.paywallViewModel?.textColor ?? Color.ds.text.background.primary
    }

    var buyButtonTextColor: Color {
        paywallService.paywallViewModel?.buyButtonStyle.buttonTextColor ?? Color.ds.brand.secondary
    }

    var buyButtonColor: Color {
        paywallService.paywallViewModel?.buyButtonStyle.buttonColor ?? Color.ds.text.background.primary
    }
}

// MARK: - preview

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView()
            .withSubscriptionService(mock: .notSubscribed)
            .withPaywallContent {
                Text("description")
                
                Label {
                    Text("Label 1")
                } icon: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.ds.feedback.positive)
                }
                
                Label {
                    Text("Label 2")
                } icon: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.ds.feedback.positive)
                }
            }
    }
}
