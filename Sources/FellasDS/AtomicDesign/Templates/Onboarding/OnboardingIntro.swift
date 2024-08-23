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
        VStack(alignment: .leading) {
            Spacer()
            headers
                .padding(.vertical, ds: .xxLarge)
                .padding(.horizontal, ds: .large)
                .padding(.bottom, ds: .xxxLarge)
        }
        .background {
            GeometryReader { geo in
                VStack(spacing: .zero) {
                    content.image
                        .frame(
                            maxWidth: geo.size.width,
                            maxHeight: 500
                        )
                        .overlay {
                            LinearGradient(
                                colors: [.clear, .ds.background.primary],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                    
                    Color.ds.background.primary
                }
                .ignoresSafeArea()
            }
        }
    }
    
    var headers: some View {
        VStack(alignment: .leading, spacing: .ds.spacing.large) {
            Spacer()
            Text(content.title)
                .textStyle(ds: .largeTitle)
            Text(content.subtitle)
                .textStyle(ds: .title3)
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    OnboardingIntro {
        Image(.paywallBg).resizable()
        "Title"
        "subtitle"
    }
}
