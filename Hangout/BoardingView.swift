//
//  BoardingView.swift
//  Hangout
//
//  Created by MacBook Pro on 14/12/23.
//

import SwiftUI

struct BoardingView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("message")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text("MESSAGE")
                    .padding()
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Get connected and chat with your family and friends")
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
                
                NavigationLink(destination: Boarding2View()) {
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
    }
}

#Preview {
    BoardingView()
}
