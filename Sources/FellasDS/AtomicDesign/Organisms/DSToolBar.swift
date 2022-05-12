//
//  DSToolbar.swift
//  
//
//  Created by Bruno Wide on 24/04/22.
//

import Foundation
import SwiftUI

struct ToolbarPreview: PreviewProvider {

    static var previews: some View {
        Group {
            NavigationView {
                Text("hello world")
                Text("hello world 2")
                    .toolbar {
                        ToolbarItem(placement: .status) {
                            Button("Edit", action: {})
                                .style(.pill)
                        }
                        ToolbarItem(placement: .principal) {
                            Text("Title")
                                .style(.title3)
                        }
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: {}) {
                                Label("add", image: "plus")
                            }
                                .style(.round)
                        }

                    }
            }
        }
        .preferredColorScheme(.dark)
    }
}

