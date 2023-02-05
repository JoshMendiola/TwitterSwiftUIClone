//
//  TextArea.swift
//  TwitterSwiftUIClone
//
//  Created by Ryan Aparicio on 1/31/23.
//

import SwiftUI

struct TextArea: View {
    @Binding var text: String
    let placeholder: String
    
    init(_ placeholder: String, text: Binding<String>){
        self.placeholder = placeholder
        self._text = text
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        ZStack(alignment: .topLeading){
            
            if text.isEmpty{//empty text field
                Text(placeholder)
                    .foregroundColor(Color(.placeholderText))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
            }
            //not empty text field
            TextEditor(text: $text)
                .padding(4)
        }
        .font(.body)
    }
}

