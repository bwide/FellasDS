//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 28/03/24.
//

import Foundation
import SwiftUI
import Combine

private let frameRate: TimeInterval = 1/120

public struct OnboardingOutroContent<Image: View> {
    var image: Image
}

@resultBuilder
public enum OnboardingOutroBuilder {
    public static func buildBlock<Image: View>(_ image: Image) -> OnboardingOutroContent<Image> {
        .init(image: image)
    }
}

public struct OnboardingOutro<Image: View>: View {
     
    var content: OnboardingOutroContent<Image>
    
    private let totalTime = 4.0
    @State private var progress: Double = 0
    @State var timer = Timer.publish(every: frameRate, on: .main, in: .common).autoconnect()
    
    public init(
        @OnboardingOutroBuilder content: () -> OnboardingOutroContent<Image>
    ) {
        self.content = content()
    }
    
    public var body: some View {
        VStack {
            Spacer()
            content
                .image
                .padding(.horizontal, ds: .small)
            ZStack(alignment: .leading) {
                Color.ds.brand.tertiary
                    .roundedCorners(.medium, corners: [.topLeft, .topRight])
                VStack(alignment: .leading, spacing: .ds.spacing.xLarge) {
                    Spacer()
                    elipses
                    Text(Strings.onboardingOutroTitle)
                        .textStyle(ds: .largeTitle)
                    progressBar
                }
                .padding(.vertical, ds: .xxLarge)
                .padding(.horizontal, ds: .large)
            }
            .zIndex(-1)
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    var elipses: some View {
        let dots = [0,1,2,3]
        PhaseAnimator(dots, content: { phase in
            HStack {
                ForEach(dots, id: \.self) { index in
                    Circle()
                        .frame(ds: .xxSmall)
                        .foregroundColor(
                            phase < index
                            ? .ds.brand.primary
                            : .ds.brand.secondary
                        )
                }
            }
        }, animation: { phase in
                .easeOut(duration: 1)
        })
    }
    
    @ViewBuilder
    var progressBar: some View {
        ProgressView(value: progress, total: totalTime)
            .progressViewStyle(.dsProgrressBar)
            .onReceive(timer) { _ in
                guard progress+frameRate < totalTime else {
                    stopTimer()
                    return
                }
                progress += frameRate
            }
    }
}

extension OnboardingOutro {
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
}


#Preview {
    OnboardingOutro {
        Image(.illustration1)
            .offset(y: 90)
    }
}
