import Foundation

struct Contact: Identifiable, Hashable {
    let id: UUID
    var name: String
    var about: String
    var isGroup = false

    init(id: UUID = UUID(), name: String, about: String = "", isGroup: Bool = false) {
        self.id = id
        self.name = name
        self.about = about
        self.isGroup = isGroup
    }
}

enum MessageStatus: Hashable {
    case sent, delivered, read
}

struct Message: Identifiable, Hashable {
    let id: UUID
    var text: String
    var date: Date
    var isOutgoing: Bool
    var status: MessageStatus

    init(id: UUID = UUID(), text: String, date: Date, isOutgoing: Bool, status: MessageStatus = .read) {
        self.id = id
        self.text = text
        self.date = date
        self.isOutgoing = isOutgoing
        self.status = status
    }
}

struct Chat: Identifiable, Hashable {
    let id: UUID
    var contact: Contact
    var messages: [Message]
    var unreadCount = 0
    var isPinned = false
    var isMuted = false

    init(id: UUID = UUID(), contact: Contact, messages: [Message] = [],
         unreadCount: Int = 0, isPinned: Bool = false, isMuted: Bool = false) {
        self.id = id
        self.contact = contact
        self.messages = messages
        self.unreadCount = unreadCount
        self.isPinned = isPinned
        self.isMuted = isMuted
    }

    var lastMessage: Message? { messages.last }
}

struct CallRecord: Identifiable, Hashable {
    enum Direction { case incoming, outgoing, missed }
    enum Kind { case audio, video }

    let id = UUID()
    var contact: Contact
    var direction: Direction
    var kind: Kind
    var date: Date
}

struct StatusUpdate: Identifiable, Hashable {
    let id = UUID()
    var contact: Contact
    var caption: String
    var date: Date
    var isSeen: Bool
}

struct Channel: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var summary: String
    var followers: String
}
