import SwiftUI
import FirebaseFirestore

struct SplitBillView: View {
    @State private var totalAmount = ""
    @State private var numberOfPeople = ""
    @State private var activityName = ""
    @State private var tax = ""
    @State private var isChoosingFriends = false
    @State private var selectedFriends: [String] = []
    @State private var allFriends: [String] = []
    @AppStorage("appUsername") var appUsername: String?

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
                    sendBill()
                    print("Sending Bill to: \(selectedFriends.joined(separator: ", "))")
                    resetFields()
                }) {
                    Text("Send Bill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .bold()
                }
                .foregroundColor(Color.white)
                .frame(width: 260, height: 42)
                .background(Color(red: 0.26, green: 0.58, blue: 0.97))
                .cornerRadius(90)
                .padding(20)
            }
            .navigationBarTitle("Split Bill")
            .sheet(isPresented: $isChoosingFriends) {
                FriendsListView(allFriends: allFriends, selectedFriends: $selectedFriends)
            }
        }
        .onAppear {
            fetchFriend()
        }
    }

    func resetFields() {
        totalAmount = ""
        numberOfPeople = ""
        activityName = ""
        tax = ""
        isChoosingFriends = false
        selectedFriends = []
    }

    func sendBill() {
        let db = Firestore.firestore()

        // Get the current date and time in the desired format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateTime = dateFormatter.string(from: Date())

        for friend in selectedFriends {
            // Query Firestore to get the recipient's username based on the friend's name
            db.collection("users")
                .whereField("name", isEqualTo: friend)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            let recipient = document.get("username") as? String ?? ""

                            // Prepare chat data
                            let message = "Hey \(friend), you owe me Rp. \(String(format: "%.2f", calculateTotalPerPerson())), for \(activityName)."

                            let chatData: [String: Any] = [
                                "sender": appUsername ?? "",
                                "recipient": recipient,
                                "chat": message,
                                "date_time": currentDateTime
                            ]

                            // Add chatData to Firestore
                            db.collection("chats").addDocument(data: chatData) { error in
                                if let error = error {
                                    print("Error adding document: \(error)")
                                } else {
                                    print("Document added successfully")
                                }
                            }
                        }
                    }
                }
        }
    }

    func fetchFriend() {
        allFriends = []
        let db = Firestore.firestore()
        db.collection("friends")
            .whereField("username", isEqualTo: appUsername)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if let document = querySnapshot?.documents.first {
                        for field in document.data() {
                            if(field.key != "username"){
                                if let fieldValue = field.value as? String {
                                    allFriends.append(fieldValue)
                                }
                            }
                        }
                    }
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
