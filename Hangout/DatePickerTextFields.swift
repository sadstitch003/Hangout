//
//  DatePickerTextFields.swift
//  Hangout
//
//  Created by MacBook Pro on 07/01/24.
//

import SwiftUI

struct DatePickerTextFields: View {
    @State private var selectedDate = Date()
    @State private var isDatePickerVisible = false

    var body: some View {
        VStack {
            HStack {
                TextField("Select Date", text: .constant(formattedDate))
                    .onTapGesture {
                        isDatePickerVisible.toggle()
                    }
                    .textFieldStyle(PlainTextFieldStyle())
//                    .padding()

                Image(systemName: "calendar")
//                    .foregroundColor(.accentColor)
                    .foregroundColor(.black)
                    .onTapGesture {
                        isDatePickerVisible.toggle()
                    }

            }
            .overlay(Rectangle().frame(width: .infinity, height: 2)
            .padding(.top, 30))
            .foregroundColor(Color.black)
            .padding(.horizontal, 10)
//            Rectangle()
//                .frame(width: .infinity, height: 2)
//                .background(Color.gray)
//                .padding(.top, 30)
//                .padding(.horizontal)
//                .padding(.bottom)

            if isDatePickerVisible {
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
//                    .datePickerStyle(FieldDatePickerStyle())
                    .datePickerStyle(GraphicalDatePickerStyle())
//                    .datePickerStyle(CompactDatePickerStyle())
//                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
//                    .padding()
            }
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }
}

struct DatePickerTextField_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerTextFields()
    }
}
