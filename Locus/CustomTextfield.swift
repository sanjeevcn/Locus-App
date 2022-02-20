//
//  CustomTextfield.swift
//  Locus
//
//  Created by Sanjeev on 20/02/22.
//

import SwiftUI
import Combine

struct CustomTextField: View {
    @Binding var data: String
    
    var body: some View {
        HStack {
            textfield()
                .onChange(of: Just(data), perform: { _ in
                    print(data)
                })
        }.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    }
    
    func textfield() -> some View {
        TextField("Please enter city", text: $data) { (isChanged) in
            if !isChanged {}
        } onCommit: {
//            removeLastSpace()
        }
        .keyboardType(.default)
        .autocapitalization(.none)
        .padding(.vertical, 12)
        .padding(.horizontal)
    }
}
