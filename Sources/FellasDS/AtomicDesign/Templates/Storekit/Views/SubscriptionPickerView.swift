//
//  SubscriptionPickerView.swift
//  Instagram Tracker (iOS)
//
//  Created by Bruno Fulber Wide on 21/07/22.
//

import Foundation
import SwiftUI
import StoreKit

#if os(iOS)

public struct SubscriptionPickerView<VM: SubscriptionPickerViewModelProtocol>: View {
    
    public init(vm: VM) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    @StateObject var vm: VM
    
    public var body: some View {
        NavigationView {
            ZStack {
                Background(.secondary)
                VStack(alignment: .leading, spacing: .ds.spacing.small) {
                    subscriptionHeadlines
                    subscriptionList
                    links
                    purchaseButton
                }
                .padding(.horizontal, ds: .medium)
            }
            .toolbar { toolbar }
            .alert(error: $vm.error)
        }
    }
    
    var subscriptionHeadlines: some View {
        TabView {
            ForEach(vm.subscriptionReasons) {
                view(for: $0)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
    
    @ViewBuilder
    func view(for reason: SubscriptionReason) -> some View {
        VStack {
            Text(reason.title)
                .textStyle(ds: .title1)
            Image(systemName: reason.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(ds: .medium)
            Spacer()
                .frame(height: .ds.spacing.medium)
            Text(reason.subtitle)
                .textStyle(ds: .subhead)
            Spacer()
        }
    }
    
    @ViewBuilder
    var subscriptionList: some View {
        VStack(spacing: .ds.spacing.small) {
            Spacer()
            DSPicker(selection: $vm.selectedProductIndex) {
                ForEach(vm.products, id: \.id) {
                    view(for: $0)
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func view(for product: (any ProductProvider)?) -> some View {
        if let product = product {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: .ds.spacing.small) {
                    Text(product.displayName)
                        .textStyle(ds: .headline, color: .ds.text.grouped.secondary)
                    Text(product.displayPrice)
                        .textStyle(ds: .title2)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: .ds.spacing.small) {
                    Text(product.displayIntroductoryOffer)
                        .textStyle(ds: .footnote)
                    if product.subscriptionPeriod == .year {
                        Text(String.s.bestDeal)
                            .textStyle(ds: .headline)
                            .padding(.vertical, .ds.spacing.xxxSmall)
                            .padding(.horizontal, .ds.spacing.small)
                            .background {
                                Capsule()
                                    .fill(Color.ds.brand.primary)
                            }
                    }
                }
            }
        }
    }
    
    var links: some View {
        HStack(spacing: .zero) {
            Spacer()
            Link(vm.privacyPolicyString, destination: vm.privacyPolicyURL)
            Spacer()
            Link(vm.termsOfUseString, destination: vm.termsOfUseURL)
            Spacer()
        }
        .padding(ds: .medium)
    }
    
    var purchaseButton: some View {
        Button(vm.subscribeString) {
            vm.onTappedPurchase.send()
        }
        .buttonStyle(.dsAction)
        .padding(.bottom, ds: .medium)
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem {
            Button(vm.restoreString) {
                vm.onTappedRestore.send()
            }
            .buttonStyle(.dsPill)
        }
    }
}

struct SubscriptionPicker_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SubscriptionPickerView(vm: MockSubscriptionPickerViewModel())
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

#endif
