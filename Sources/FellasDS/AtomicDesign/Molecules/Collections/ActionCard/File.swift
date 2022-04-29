//
//  File.swift
//  
//
//  Created by Bruno Wide on 25/04/22.
//

import Foundation
import Combine

public extension ActionCardView {

    init(title: String,
         subtitle: String,
         info: String,
         icon: String) {
        self.init(vm: .init(title: .init(initialValue: title), subtitle: .init(initialValue: subtitle), info: .init(initialValue: info), icon: icon))
    }

    /// Adds an action for the button tap
    func onTappedButton(_ action: @escaping () -> Void) -> ActionCardView {
        vm.buttonAction = action
        return ActionCardView(vm: vm)
    }

    /// Adds an action when tapping the card
    func onTapCard(_ action: @escaping () -> Void) -> ActionCardView {
        vm.tapAction = action
        return ActionCardView(vm: vm)
    }
}

internal extension ActionCardViewModel {
    convenience init(title: String,
                     subtitle: String,
                     info: String,
                     icon: String) {
        self.init(title: .init(initialValue: title), subtitle: .init(initialValue: subtitle), info: .init(initialValue: info), icon: icon)
    }
}

public class ActionCardViewModel: ObservableObject {

    public init(title: Published<String>,
                subtitle: Published<String>,
                info: Published<String>,
                icon: String,
                buttonAction: (() -> Void)? = nil,
                tapAction: (() -> Void)? = nil) {

        self._title = title
        self._subtitle = subtitle
        self._info = info
        self.icon = icon
        self.buttonAction = buttonAction
        self.tapAction = tapAction
    }


    @Published var title: String
    @Published var subtitle: String
    @Published var info: String

    var icon: String

    var buttonAction: (() -> Void)?
    var tapAction: (() -> Void)?
}
