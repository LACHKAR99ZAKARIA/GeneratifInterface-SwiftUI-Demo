import Foundation

/// Données fictives réalistes (aucun backend). Dates relatives à « maintenant ».
enum MockData {
    private static func ago(_ minutes: Int) -> Date { Date().addingTimeInterval(TimeInterval(-minutes * 60)) }

    static let contacts: [Contact] = [
        Contact(name: "Sarah Benali", about: "Disponible"),
        Contact(name: "Yassine El Amrani", about: "Au travail"),
        Contact(name: "Maman", about: "Ne pas déranger sauf urgence 😄"),
        Contact(name: "Équipe Produit", about: "12 participants", isGroup: true),
        Contact(name: "Lina Moreau", about: "En voyage ✈️"),
        Contact(name: "Karim Haddad", about: "Hey, j'utilise l'app !"),
        Contact(name: "Julie Martin", about: "📚 Révisions"),
        Contact(name: "Omar Tazi", about: "Sport tous les matins")
    ]

    private static func contact(_ name: String) -> Contact { contacts.first { $0.name == name }! }

    static func makeChats() -> [Chat] {
        [
            Chat(contact: contact("Équipe Produit"), messages: [
                Message(text: "Le design system est mergé 🎉", date: ago(190), isOutgoing: false),
                Message(text: "Parfait, je lance la review des écrans.", date: ago(185), isOutgoing: true),
                Message(text: "On se retrouve à 15h pour la démo ?", date: ago(12), isOutgoing: false)
            ], unreadCount: 3, isPinned: true),
            Chat(contact: contact("Sarah Benali"), messages: [
                Message(text: "Salut ! Tu as vu la maquette ?", date: ago(60 * 5), isOutgoing: false),
                Message(text: "Oui, elle est top. Les rayons de coins sont parfaits.", date: ago(60 * 5 - 2), isOutgoing: true, status: .read),
                Message(text: "Je t'envoie la version dark dans la soirée.", date: ago(60 * 5 - 3), isOutgoing: false),
                Message(text: "Super, merci beaucoup 🙏", date: ago(35), isOutgoing: true, status: .read),
                Message(text: "Avec plaisir ! Je te l'envoie dans 10 minutes.", date: ago(34), isOutgoing: false),
                Message(text: "Tu peux aussi regarder la densité compacte, elle change tout.", date: ago(33), isOutgoing: false),
                Message(text: "Je teste ça maintenant, j'ai activé le thème sombre.", date: ago(8), isOutgoing: true, status: .delivered),
                Message(text: "Dis-moi ce que tu en penses !", date: ago(6), isOutgoing: true, status: .sent)
            ], unreadCount: 0, isPinned: true),
            Chat(contact: contact("Maman"), messages: [
                Message(text: "N'oublie pas dimanche, on mange tous ensemble.", date: ago(60 * 20), isOutgoing: false),
                Message(text: "Oui, j'apporte le dessert !", date: ago(60 * 19), isOutgoing: true)
            ], unreadCount: 1),
            Chat(contact: contact("Yassine El Amrani"), messages: [
                Message(text: "Tu as le lien du build TestFlight ?", date: ago(60 * 27), isOutgoing: false),
                Message(text: "Je te l'envoie dans une minute.", date: ago(60 * 27 - 5), isOutgoing: true, status: .delivered)
            ]),
            Chat(contact: contact("Lina Moreau"), messages: [
                Message(text: "Photos de Lisbonne 📸", date: ago(60 * 50), isOutgoing: false),
                Message(text: "Magnifique ! Profite bien.", date: ago(60 * 49), isOutgoing: true)
            ], isMuted: true),
            Chat(contact: contact("Karim Haddad"), messages: [
                Message(text: "Merci pour ton aide hier 👍", date: ago(60 * 75), isOutgoing: false)
            ]),
            Chat(contact: contact("Julie Martin"), messages: [
                Message(text: "On révise ensemble jeudi ?", date: ago(60 * 24 * 4), isOutgoing: true, status: .read)
            ])
        ]
    }

    static func makeCalls() -> [CallRecord] {
        [
            CallRecord(contact: contact("Sarah Benali"), direction: .missed, kind: .audio, date: ago(25)),
            CallRecord(contact: contact("Maman"), direction: .outgoing, kind: .video, date: ago(60 * 6)),
            CallRecord(contact: contact("Yassine El Amrani"), direction: .incoming, kind: .audio, date: ago(60 * 26)),
            CallRecord(contact: contact("Équipe Produit"), direction: .incoming, kind: .video, date: ago(60 * 28)),
            CallRecord(contact: contact("Lina Moreau"), direction: .missed, kind: .video, date: ago(60 * 52)),
            CallRecord(contact: contact("Karim Haddad"), direction: .outgoing, kind: .audio, date: ago(60 * 24 * 4))
        ]
    }

    static func makeStatuses() -> [StatusUpdate] {
        [
            StatusUpdate(contact: contact("Lina Moreau"), caption: "Coucher de soleil sur le Tage 🌅", date: ago(20), isSeen: false),
            StatusUpdate(contact: contact("Omar Tazi"), caption: "5 km avant le café ☕️", date: ago(75), isSeen: false),
            StatusUpdate(contact: contact("Julie Martin"), caption: "Dernière ligne droite avant les exams", date: ago(60 * 5), isSeen: false),
            StatusUpdate(contact: contact("Karim Haddad"), caption: "Nouveau setup 🖥️", date: ago(60 * 9), isSeen: true),
            StatusUpdate(contact: contact("Sarah Benali"), caption: "Brainstorm design ✏️", date: ago(60 * 14), isSeen: true)
        ]
    }

    static let channels: [Channel] = [
        Channel(name: "SwiftUI Weekly", summary: "Astuces et nouveautés SwiftUI chaque semaine.", followers: "48 k abonnés"),
        Channel(name: "Design Systems FR", summary: "Tokens, composants et bonnes pratiques.", followers: "12 k abonnés"),
        Channel(name: "iOS Dev Maroc", summary: "Communauté des développeurs iOS.", followers: "7,3 k abonnés")
    ]
}
