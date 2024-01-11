import SwiftUI
import FirebaseFirestore

struct Chat: Identifiable, Equatable {
    let id = UUID()
    let isSender: Bool?
    let date_time: String?
    let chat: String?
}

struct ChatView: View {
    let contactName: String?
    let contactUsername: String?
    @State private var chatHistory: [Chat] = []
    @AppStorage("appUsername") var appUsername: String?
    @State private var newMessage: String = ""
    @State private var timer: Timer?

    var body: some View {
        VStack(alignment: .leading) {
            // Modified HStack to fix the issue
            HStack(spacing: 5) {
                
                Circle()
                    .fill(Color(red: 0.26, green: 0.58, blue: 0.97))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(contactName?.prefix(1) ?? ""))
                            .foregroundColor(.white)
                            .font(.headline)
                    )
                Text(contactName ?? "")
                    .bold()
                
            }


            ScrollView {
                ScrollViewReader { scrollView in
                    ForEach(chatHistory, id: \.id) { chat in
                        ChatBubble(message: chat.chat ?? "", isSender: chat.isSender ?? false, datetime: chat.date_time ?? "")
                            .id(chat.id)
                    }
                    .onChange(of: chatHistory) { _ in
                        // Scroll to the bottom whenever chatHistory is updated
                        DispatchQueue.main.async {
                            
                                scrollView.scrollTo(chatHistory.last?.id, anchor: .bottom)
                            
                        }
                    }
                    .onAppear {
                        // Scroll to the bottom when the chat view appears
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation {
                                scrollView.scrollTo(chatHistory.last?.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }

            .onAppear {
                fetchChatHistory()
                startTimer()
            }
            
           

            HStack {
                TextField("Type your message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 10)

                Button(action: {
                    // Handle sending the message here
                    sendMessage()
                }) {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color(red: 67/255, green: 147/255, blue: 267/255))
                }
                .padding(.trailing)
            }
        }
        
        .padding(10)
        .navigationBarTitleDisplayMode(.inline)
    }

    func fetchChatHistory() {
        // Simulating fetching chat history from Firestore
        chatHistory = []
        let db = Firestore.firestore()

        db.collection("chats")
            .whereField("sender", in: [appUsername, contactUsername])
            .whereField("recipient", in: [appUsername, contactUsername])
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot?.documents ?? [] {
                        if let sender = document["sender"] as? String,
                           let date_time = document["date_time"] as? String,
                           let chat = document["chat"] as? String {
                            let chatData = Chat(isSender: sender == appUsername, date_time: date_time, chat: chat)
                            chatHistory.append(chatData)
                        }
                    }

                    // Sort chatHistory by date_time in descending order
                    chatHistory.sort { (chat1, chat2) -> Bool in
                        if let date1 = chat1.date_time, let date2 = chat2.date_time {
                            return date2 > date1
                        }
                        return false
                    }
                }
            }
    }


    func sendMessage() {
        let db = Firestore.firestore()

        // Get the current date and time in the desired format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateTime = dateFormatter.string(from: Date())

        // Prepare chat data
        let chatData: [String: Any] = [
            "sender": appUsername ?? "",
            "recipient": contactUsername ?? "",
            "chat": newMessage,
            "date_time": currentDateTime
        ]

        // Add chatData to Firestore
        db.collection("chats").addDocument(data: chatData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
                fetchChatHistory() // Refresh chat history after sending a message
            }
        }

        // Clear the input field after sending a message
        newMessage = ""
    }


    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            fetchChatHistory()
        }
    }
}

struct ChatBubble: View {
    let message: String
    let isSender: Bool
    let datetime: String // Add a datetime parameter

    var body: some View {
        VStack(alignment: isSender ? .trailing : .leading) {
            HStack {
                if isSender {
                    Spacer()
                }
                Text(message)
                    .padding(8)
                    .background(isSender ? Color(red: 67/255, green: 147/255, blue: 267/255) : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(2)
                if !isSender {
                    Spacer()
                }
            }
            HStack{
                if isSender {
                    Spacer()
                }
                Text(datetime)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.trailing, 4)
                if !isSender {
                    Spacer()
                }
            }
        }.padding(.horizontal, 10)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(contactName: "RecipientName", contactUsername: "RecipientName")
    }
}
                 
