//
//  TagsView.swift
//  FetchRecipes
//
//  Created by Jillian Scott on 9/28/23.
//

import SwiftUI

struct TagsView: View {
    let tags: [String]?
    
    var body: some View {
        if let tags = tags {
            HStack {                
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .padding(5)
                        .background(Color(CGColor(gray: 0.5, alpha: 0.4)), in: RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
}

struct TagsView_Previews: PreviewProvider {
    static var previews: some View {
        TagsView(tags: ["previewTag1", "previewTag2"])
    }
}
