//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 19/11/23.
//

import Foundation
import SwiftUI

public extension Image {
    static var appIcon: Image {
        Image(uiImage: UIImage(named: "AppIcon", in: .main, with: .none) ?? UIImage())
            .resizable()
    }
}
