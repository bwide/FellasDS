//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 28/01/24.
//

import Foundation
import SwiftUI

extension ProgressViewStyle where Self == DSProgressBarStyle {
    static var dsProgrressBar: DSProgressBarStyle { DSProgressBarStyle() }
}

struct DSProgressBarStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.ds.brand.primary)
                .opacity(0.7)
            Rectangle()
                .fill(Color.ds.brand.primary)
                .scaleEffect(x: configuration.fractionCompleted ?? 0, anchor: .leading)
        }
        .clipShape(RoundedRectangle(cornerRadius: .ds.cornerRadius.small))
        .frame(height: .ds.size.medium)
    }
}


#Preview {
    struct Progress: View {
        @State private var progress: Double = 0
        @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        
        var body: some View {
            ProgressView(value: progress)
                .onReceive(timer) { _ in
                    guard progress <= 1 else {
                        timer.upstream.connect().cancel()
                        return
                    }
                    progress += 0.002
                }
        }
    }
    
    return VStack {
        Progress()
            .progressViewStyle(DSProgressBarStyle())
        Progress()
            .progressViewStyle(.linear)
    }
    .padding(ds: .large)
}
