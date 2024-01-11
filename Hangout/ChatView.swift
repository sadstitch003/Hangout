import SwiftUI

struct ChatView: View {
    @State private var newMessage: String = ""
    
    let sender: String
    let recipient: String
    @State private var scrollProxy: ScrollViewProxy?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .fill(Color(red: 0.26, green: 0.58, blue: 0.97))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(recipient.prefix(1)))
                            .foregroundColor(.white)
                            .font(.headline)
                    )
                    .padding(.trailing, 5)
                
                Text(recipient)
                    .bold()
            }
            
            
            ScrollView {
                ScrollViewReader { proxy in
                    VStack {
                        ChatBubble(message: "Hello, this is a message from the sender", isSender: true)
                        ChatBubble(message: "Hi, this is a message from the recipient", isSender: false)
                        ChatBubble(message: "Hello, this is a message from the sender", isSender: true)
                        ChatBubble(message: "Hi, this is a message from the recipient", isSender: false)
                        ChatBubble(message: "Hello, this is a message from the sender", isSender: true)
                        ChatBubble(message: "Hi, this is a message from the recipient", isSender: false)
                        ChatBubble(message: "Hello, this is a message from the sender", isSender: true)
                        ChatBubble(message: "Hi, this is a message from the recipient", isSender: false)
                        ChatBubble(message: "Hello, this is a message from the sender", isSender: true)
                        ChatBubble(message: "Hi, this is a message from the recipient", isSender: false)
                        ChatBubble(message: "Hello, this is a message from the sender", isSender: true)
                        ChatBubble(message: "Hi, this is a message from the recipient", isSender: false)
                        ChatBubble(message: "Hello, this is a message from the senssssder", isSender: true)
                        ChatBubble(message: "Hi, this is a message fromssthe sss", isSender: false)
                        ChatBubble(message: "Hello, this is a message from the sewwwnder", isSender: true)
                        ChatBubble(message: "Hi, this is a message from the recipwwwwwient", isSender: false)
                    }
                    .onChange(of: newMessage) { _ in
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                    .padding(.bottom, 50)
                    .onAppear {
                        scrollProxy = proxy
                        DispatchQueue.main.async {
                            proxy.scrollTo("bottom", anchor: .bottom)
                        }
                    }
                }
                .id("bottom")
            }
            
            HStack {
                TextField("Type your message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    // Handle sending the message here
                }) {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color(red: 67/255, green: 147/255, blue: 267/255))
                }
                .padding(.trailing)
            }
        }
        .padding(30)
    }
}

struct ChatBubble: View {
    let message: String
    let isSender: Bool

    var body: some View {
        HStack {
            if isSender {
                Spacer()
            }
            
            Text(message)
                .padding(8)
                .background(isSender ? Color(red: 67/255, green: 147/255, blue: 267/255) : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(4)
            
            if !isSender {
                Spacer()
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(sender: "SenderName", recipient: "Recipient1")
    }
}
