//
//  BoardingView.swift
//  Hangout
//
//  Created by MacBook Pro on 14/12/23.
//

import SwiftUI

struct Boarding3View: View {
    @AppStorage("isOnBoarding") var isOnBoarding: Bool?
    
    var body: some View {
        NavigationView {
            VStack {
                Image("splitbill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text("SPLIT BILL")
                    .padding()
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Effortlessly share and settle expenses with ease through our split bill app")
                    .padding(.horizontal)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.gray)
                    
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.gray)
                    
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color(red: 67/255, green: 147/255, blue: 267/255))
                    
                }
                .padding()
                
                Button(action: {
                    isOnBoarding = false
                }) {
                    Text("Get Started!")
                        .font(.title2)
                        .bold()
                        .padding(10)
                        .frame(width: 280)
                        .foregroundColor(.white)
                        .background(Color(red: 67/255, green: 147/255, blue: 267/255))
                        .cornerRadius(50)
                }
            }
            .padding(40)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Boarding3View()
}
