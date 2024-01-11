import SwiftUI

struct SplitBillView: View {
    @State private var totalAmount = ""
    @State private var numberOfPeople = ""
    @State private var activityName = ""
    @State private var tax = ""
    @State private var isChoosingFriends = false
    @State private var selectedFriends: [String] = [] // Keep track of selected friends
    let allFriends = ["Friend 1", "Friend 2", "Friend 3", "Friend 4", "Friend 5"] // Add your friend names here

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Form {
                    Section(header: Text("Bill Details")) {
                        TextField("Activity Name", text: $activityName)
                            .keyboardType(.default)

                        TextField("Total Amount", text: $totalAmount)
                            .keyboardType(.decimalPad)

                        TextField("Number of People", text: $numberOfPeople)
                            .keyboardType(.numberPad)
                    }

                    Section(header: Text("Tax")) {
                        TextField("Enter the Tax Percentage", text: $tax)
                            .keyboardType(.decimalPad)
                    }

                    Section(header: Text("Choose Friends")) {
                        Button(action: {
                            isChoosingFriends = true
                        }) {
                            Text("Choose Friends")
                        }
                    }

                    Section(header: Text("Selected Friends")) {
                        ForEach(selectedFriends, id: \.self) { friend in
                            Text(friend)
                        }
                    }

                    Section(header: Text("Total per Person")) {
                        let totalPerPerson = calculateTotalPerPerson()
                        Text("Rp. \(totalPerPerson, specifier: "%.2f")")
                    }
                }

                Spacer()

                Button(action: {
                    // Add the action to send the bill to selected friends
                    print("Sending Bill to: \(selectedFriends.joined(separator: ", "))")
                }) {
                    Text("Send Bill to Selected Friends")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .bold()
                }
                .padding()
            }
            .navigationBarTitle("Split Bill")
            .sheet(isPresented: $isChoosingFriends) {
                FriendsListView(allFriends: allFriends, selectedFriends: $selectedFriends)
            }
        }
    }

    private func calculateTotalPerPerson() -> Double {
        guard let totalAmount = Double(totalAmount),
              let numberOfPeople = Double(numberOfPeople),
              let taxPercentage = Double(tax),
              numberOfPeople > 0 else {
            return 0.0
        }

        let totalWithTax = totalAmount * (1 + taxPercentage / 100)
        let totalPerPerson = totalWithTax / numberOfPeople

        return totalPerPerson.isNaN || totalPerPerson.isInfinite ? 0.0 : totalPerPerson
    }
}

struct FriendsListView: View {
    let allFriends: [String]
    @Binding var selectedFriends: [String]
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List {
                SearchBar(text: $searchText)

                ForEach(allFriends.filter { searchText.isEmpty || $0.localizedCaseInsensitiveContains(searchText) }, id: \.self) { friend in
                    HStack {
                        Text(friend)
                        Spacer()
                        Image(systemName: selectedFriends.contains(friend) ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                if selectedFriends.contains(friend) {
                                    selectedFriends.removeAll { $0 == friend }
                                } else {
                                    selectedFriends.append(friend)
                                }
                            }
                    }
                }
            }
            .navigationBarTitle("Choose Friends", displayMode: .inline)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(.horizontal, 24)
            Image(systemName: "magnifyingglass")
                .padding(.horizontal, 8)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct SplitBillView_Previews: PreviewProvider {
    static var previews: some View {
        SplitBillView()
    }
}
