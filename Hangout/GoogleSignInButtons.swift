//
//  GoogleSignInButtons.swift
//  Hangout
//
//  Created by MacBook Pro on 07/01/24.
//

import SwiftUI

struct GoogleSignInButtons: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 260, height: 42)
                    .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                    .cornerRadius(90)
                HStack(spacing: 0) {
                    Image("icongoogle")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("LOG IN WITH GOOGLE")
                        .multilineTextAlignment(.center)
                        .bold()
                        .foregroundColor(.black)
                        .frame(width: 180, height: 42, alignment: .center)
                }
                
            }
            .frame(width: 180, height: 42)
        }
    }
    
    struct GoogleSiginBtn_Previews: PreviewProvider {
        static var previews: some View {
            GoogleSignInButtons(action: {})
        }
    }
}
