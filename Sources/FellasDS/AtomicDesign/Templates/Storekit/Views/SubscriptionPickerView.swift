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
            Image(systemName: reason.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(ds: .medium)
            Text(reason.title)
                .textStyle(ds: .title2)
            Spacer()
                .frame(height: .ds.spacing.medium)
            Text(reason.subtitle)
                .textStyle(ds: .caption1)
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
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: .ds.spacing.small) {
                    Text(product.displayName)
                        .textStyle(ds: .title2)
                    Text(product.displayPrice)
                        .textStyle(ds: .headline)
                    // number of free days
                }
                Spacer()
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
            vm.tappedPurchase.send()
        }
        .buttonStyle(.dsAction)
        .padding(.bottom, ds: .medium)
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem {
            Button(vm.restoreString) {
                vm.tappedRestore.send()
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
    }
}

#endif
