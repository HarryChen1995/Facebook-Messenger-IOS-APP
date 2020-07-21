//
//  FriendsControllerHelper.swift
//  FBMessenger
//
//  Created by Hanlin Chen on 7/15/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit
import CoreData
extension  FriendController {
    
    func clearData(){
        let delegate = UIApplication.shared.delegate as? AppDelegate
              if let context = delegate?.persistentContainer.viewContext {
                    do {
                        
                        let entityNames = ["Friend", "Message"]
                        for entityName  in entityNames {
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                        let objects =  try context.fetch(fetchRequest) as? [NSManagedObject]
                            for object in objects! {
                        context.delete(object)
                        }
                        }
                        try context.save()
                        
                    }catch let err{
                        print(err)
                    }
                }
                
        }

    func setupData(){
        clearData()
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
        
        let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        mark.name = "Mark Zuckerberg"
        mark.profileImageName = "zuckprofile"
        
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = mark
        message.text = "Hello, my name is Mark, Nice to meet you  ..."
        message.date = Date()
        
        
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve_profile"
        
            
        createMessageWithText(text: "Good Morning", friend: steve,minuteAgo:  2 , context: context)
        createMessageWithText(text: "Hello How are You, Hope you are having a good morning", friend: steve, minuteAgo: 1,  context: context)
        createMessageWithText(text: "Are you interested in buying a new Apple device, we have a varities of devives that will suit your needs. Please make your purchase with us.", friend: steve,minuteAgo: 0,  context: context)
            
        let trump = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        trump.name = "Donald Trump"
        trump.profileImageName = "donald_trump_profile"
        createMessageWithText(text: "You are fire", friend: trump,minuteAgo:  5 , context: context)

        let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        gandhi.name = "Mhatma Gandhi"
        gandhi.profileImageName = "gandhi"
            
        createMessageWithText(text: "Love Peace", friend: gandhi, minuteAgo: 60*24, context: context)
            
            
            
        let hillary = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        hillary.name = "Hillary Clinton"
        hillary.profileImageName = "hillary_profile"
            
        createMessageWithText(text: "Please vote for me", friend: hillary, minuteAgo: 8*60*24, context: context)

        
        
            do {
                try context.save()
            }catch let err{
                print(err)
            }
        }
        
        loadData()
        
    }
    private func createMessageWithText(text:String, friend: Friend, minuteAgo: Double , context: NSManagedObjectContext){
        let message  = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = Date().addingTimeInterval(-minuteAgo*60)
    }
    
    private func fetchFreinds() -> [Friend]? {
    let delegate = UIApplication.shared.delegate as? AppDelegate
    if let context = delegate?.persistentContainer.viewContext {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
        do {
            return try context.fetch(request) as? [Friend]
        }catch let err {
            print(err)
        }
        
        }
        return nil
     }
    func loadData(){
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            if  let friends = fetchFreinds() {
                messages = [Message]()
                for friend in friends {
                  do {
                      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                      fetchRequest.sortDescriptors  = [NSSortDescriptor(key: "date", ascending: false)]
                      fetchRequest.predicate = NSPredicate(format: "friend.name =%@", friend.name as! String)
                      fetchRequest.fetchLimit = 1
                      let fetchMessages = try context.fetch(fetchRequest) as? [Message]
                    messages?.append(contentsOf: fetchMessages!)
                  }
                  catch let err {
                      print(err)
                  }
                }
            }
            messages = messages?.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
            
        }
        
    }
}
