import Foundation
import Combine

public class ProductsStore: ObservableObject {

    @Published public private(set) var subscriptions: [ProductProvider] = []
    @Published public private(set) var purchasedSubscriptions: [ProductProvider] = []
    @Published public private(set) var userSubscriptionStatus: RenewalState?
    
    public var error: AnyPublisher<Error?, Never> {
        provider.errorPublisher
    }
    
    private let provider: StoreProviderType
    
    public init(provider: StoreProviderType) {
        self.provider = provider
        
        provider.subscriptionsPublisher
            .assign(to: &$subscriptions)
        
        provider.purchasedSubscriptionsPublisher
            .assign(to: &$purchasedSubscriptions)
        
        provider.userSubscriptionStatusPublisher
            .assign(to: &$userSubscriptionStatus)
    }
    
    public func restorePurchases() {
        provider.restorePurchases()
    }
    
    public func purchase(_ product: ProductProvider) async throws -> Bool? {
        try await provider.purchase(product)
    }
}

extension Collection where Element == ProductProvider {
    func sortByPrice() -> [ProductProvider] {
        self.sorted(by: { $0.price < $1.price })
    }
    
    func first(with id: String) -> ProductProvider? {
        self.first(where: { $0.id == id })
    }
    
    func contains(_ item: ProductProvider) -> Bool {
        return contains(where: { $0.id == item.id })
    }
}
