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
                Text(verbatim: "hello world")
                Text(verbatim: "hello world 2")
                    .toolbar {
                        ToolbarItem(placement: .status) {
                            Button {
                                
                            } label: {
                                Text(verbatim: "Edit")
                            }
                                .buttonStyle(.dsPill)
                        }
                        ToolbarItem(placement: .principal) {
                            Text(verbatim: "Title")
                                .textStyle(ds: .title3)
                        }
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: {}) {
                                HStack {
                                    Text(verbatim: "add")
                                    Spacer()
                                    Image(systemName: "plus")
                                }
                            }
                            .buttonStyle(.dsRound)
                        }

                    }
            }
        }
        .preferredColorScheme(.dark)
    }
}

