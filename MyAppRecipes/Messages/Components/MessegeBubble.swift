//
//  MessegeBubble.swift
//  ChatApp2
//
//  Created by Consultant on 1/15/23.
//

import SwiftUI

struct MessegeBubble: View {
    var message: Messages
    //@AppStorage("user_name") private var name: String = ""
    //@AppStorage("user_UID") private var userUID: String = ""
    //var sender: Bool = false
    @State private var showTime = false
    //var name = "Mike"
    var body: some View {
        VStack(
            alignment: message.received ? .trailing : .leading) {
                    HStack {
                        Text(message.text)
                            .fontWeight(.medium)
                            .padding()
                            .background(message.received ? Color("Blue") : Color ("Blue"))
                            .cornerRadius(12)
                        Text("\(message.userName)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                    }
                    .frame(maxWidth: 400, alignment: message.received ? .trailing : .leading)
                    
                    .onTapGesture {
                        showTime.toggle()
                    }
                    if showTime {
                            Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .padding(message.received ? .leading : .trailing, 0)
                        
                    }
                    
        }
                .frame(maxWidth: .infinity, alignment: message.received ? .leading : .trailing)
                .padding(message.received ? .leading : .trailing)
                .padding(.horizontal, 10)
    }
}

struct MessegeBubble_Previews: PreviewProvider {
    static var previews: some View {
//        MessegeBubble(message: Message(id: "12345", text: "I've been coding SwiftUI applicatiions and it's so fun!", received: true, timestamp: Date()))
        MessegeBubble(message: Messages(messageid: "1234", text: "Hello", userName: "Mike", userUID: "1234", received: false))
    }
}
