//
//  BoardingView.swift
//  Hangout
//
//  Created by MacBook Pro on 14/12/23.
//

import SwiftUI

struct Boarding2View: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("location")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text("LIVE LOCATION")
                    .padding()
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("See the location of your loved people in real time")
                    .padding(.horizontal)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color(red: 67/255, green: 147/255, blue: 267/255))
                    
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.gray)
                    
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.gray)
                }
                .padding()
                
                NavigationLink(destination: Boarding3View()) {
                    Text("Continue")
                        .font(.title2)
                        .bold()
                }
                .padding(10)
                .frame(width: 280)
                .foregroundColor(.white)
                .background(Color(red: 67/255, green: 147/255, blue: 267/255))
                .cornerRadius(50)
            }
            .padding(40)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Boarding2View()
}
