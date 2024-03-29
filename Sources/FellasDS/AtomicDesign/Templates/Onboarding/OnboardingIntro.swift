//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 28/03/24.
//

import Foundation
import SwiftUI

public struct OnboardingIntroContent<Image: View> {
    var image: Image
    var title: String
    var subtitle: String
}

@resultBuilder
public enum OnboardingIntroBuilder {
    public static func buildBlock<Image: View>(_ image: Image, _ title: String, _ subtitle: String) -> OnboardingIntroContent<Image> {
        .init(image: image, title: title, subtitle: subtitle)
    }
}

public struct OnboardingIntro<Image: View>: View {
     
    var content: OnboardingIntroContent<Image>
    
    public init(@OnboardingIntroBuilder content: () -> OnboardingIntroContent<Image>) {
        self.content = content()
    }
    
    public var body: some View {
        VStack {
            Spacer()
            content
                .image
            ZStack(alignment: .leading) {
                Color.ds.brand.primary
                    .opacity(ds: .disabled)
                    .roundedCorners(.medium, corners: [.topLeft, .topRight])
                headers
                .padding(.top, ds: .xxLarge)
                .padding(.horizontal, ds: .large)
            }
            .zIndex(-1)
        }
        .ignoresSafeArea()
    }
    
    var headers: some View {
        VStack(alignment: .leading, spacing: .ds.spacing.large) {
            Text(content.title)
                .textStyle(ds: .largeTitle)
            Text(content.subtitle)
                .textStyle(ds: .title3)
            Spacer()
        }
    }
}


#Preview {
    OnboardingIntro {
        Image(.illustration1)
            .offset(y: 90)
        "Title"
        "subtitle"
    }
}
