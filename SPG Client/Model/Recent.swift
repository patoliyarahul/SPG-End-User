
internal class Recent {
    
    internal let counter: String
//    internal let createdAt: String
    internal let description: String
    internal let groupId: String
    internal let initials: String
    internal let isArchived: Bool
    internal let isDeleted: Bool
    internal let lastMessage: String
    internal let lastMessageDate: String
    internal let objectId: String
    internal let password: String
    internal let picture: String
    internal let type: String
//    internal let updatedAt: String
    internal let userId: String
    
    init(dict: Dictionary<String, Any>) {
        self.counter        = "\(dict[FRecentParams.FRECENT_COUNTER]!)"
//        self.createdAt      = "\(dict[FRecentParams.FRECENT_CREATEDAT]!)"
        self.description    = "\(dict[FRecentParams.FRECENT_DESCRIPTION]!)"
        self.groupId        = "\(dict[FRecentParams.FRECENT_GROUPID]!)"
        self.initials       = "\(dict[FRecentParams.FRECENT_INITIALS]!)"
        self.isArchived     = dict[FRecentParams.FRECENT_ISARCHIVED]! as! Bool
        self.isDeleted      = dict[FRecentParams.FRECENT_ISDELETED]! as! Bool
        self.lastMessage    = "\(dict[FRecentParams.FRECENT_LASTMESSAGE]!)"
        self.lastMessageDate = "\(dict[FRecentParams.FRECENT_LASTMESSAGEDATE]!)"
        self.objectId       = "\(dict[FRecentParams.FRECENT_OBJECTID]!)"
        self.password       = "\(dict[FRecentParams.FRECENT_PASSWORD]!)"
        self.picture        = "\(dict[FRecentParams.FRECENT_PICTURE]!)"
        self.type           = "\(dict[FRecentParams.FRECENT_TYPE]!)"
//        self.updatedAt      = "\(dict[FRecentParams.FRECENT_UPDATEDAT]!)"
        self.userId         = "\(dict[FRecentParams.FRECENT_USERID]!)"
    }
}
