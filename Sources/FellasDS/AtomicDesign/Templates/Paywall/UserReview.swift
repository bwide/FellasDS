//
//  File.swift
//  
//
//  Created by Bruno Fulber Wide on 09/08/24.
//

import Foundation
import SwiftUI

public struct UserReview: View {
    
    private var stars: Int = 5
    private var review: String
    private var username: String?
    
    public init(stars: Int = 5, review: String, username: String? = nil) {
        self.stars = stars
        self.review = review
        self.username = username
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: .ds.spacing.small) {
            starsView
            Text(review)
            if let username {
                Text(verbatim: "- \(username)")
            }
        }
        .textStyle(ds: .headline)
        .padding(.horizontal, ds: .small)
        .padding(.vertical, ds: .medium)
        .background {
            RoundedRectangle(cornerRadius: .ds.cornerRadius.medium)
                .foregroundColor(Color.ds.background.secondary)
        }
    }
    
    var starsView: some View {
        HStack {
            ForEach(1..<6) { i in
                Image(systemName: i > stars ? "star" : "star.fill")
            }
        }.foregroundColor(.ds.feedback.warning)
    }
}

public struct UserReviews<Label: View>: View {
    
    var label: () -> Label
        
    public init(@ViewBuilder label: @escaping () -> Label) {
        self.label = label
    }
    
    public var body: some View {
        TabView {
            label()
                .padding(.horizontal, ds: .xxxSmall)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
//        .background { Color.red }
        .frame(minHeight: 120)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    ZStack {
        Color.ds.brand.primary
        VStack {
            UserReviews {
                UserReview(stars: 5, review: "Lorem ipsum odor amet, consectetuer adipiscing elit. Nullam justo dolor lacinia dis netus metus gravida.", username: "user1")
                UserReview(stars: 5, review: "Lorem ipsum odor amet, consectetuer adipiscing elit. Nullam justo dolor lacinia dis netus metus gravida.", username: "user1")
                UserReview(stars: 5, review: "Lorem ipsum odor amet, consectetuer adipiscing elit. Nullam justo dolor lacinia dis netus metus gravida.", username: "user1")
            }
            Spacer()
        }
    }
}
