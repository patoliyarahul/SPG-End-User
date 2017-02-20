//
//  User.swift
//  SPG Stylist
//
//  Created by Dharmesh Vaghani on 20/02/17.
//  Copyright © 2017 Dharmesh Vaghani. All rights reserved.
//

internal class User : NSObject {
    internal let email: String
    internal let firstname: String
    internal let fullname: String
    internal let lastname: String
    internal let objectId: String
    internal let picture: String
    internal let userType: String
    
    init(dict : Dictionary<String, String>) {
        self.email = "\(dict[FUserParams.FUSER_EMAIL]!)"
        self.firstname = "\(dict[FUserParams.FUSER_FIRSTNAME]!)"
        self.fullname = "\(dict[FUserParams.FUSER_FULLNAME]!)"
        self.lastname = "\(dict[FUserParams.FUSER_LASTNAME]!)"
        self.objectId = "\(dict[FUserParams.FUSER_OBJECTID]!)"
        self.picture = "\(dict[FUserParams.FUSER_PICTURE]!)"
        self.userType = "\(dict[FUserParams.FUSER_TYPE]!)"
    }
    
    func getFullName() -> String {
        return self.fullname
    }
}
