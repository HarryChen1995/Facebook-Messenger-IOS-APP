//
//  Message.swift
//  FBMessenger
//
//  Created by Hanlin Chen on 7/15/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//
import Foundation
import CoreData

class Message: NSManagedObject{
    @NSManaged  var text : String?
    @NSManaged var date : Date?
    @NSManaged var friend: Friend?
}
