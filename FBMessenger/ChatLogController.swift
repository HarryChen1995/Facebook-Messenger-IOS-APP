//
//  ChatLogController.swift
//  FBMessenger
//
//  Created by Hanlin Chen on 7/15/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit

class ChatLogController:  UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellID = "cd"
    var friend: Friend? {
        didSet{
            navigationItem.title = friend?.name
            messages = friend?.message?.allObjects as? [Message]
            messages = messages?.sorted(by: {$0.date!.compare($1.date!) == .orderedAscending})
        }
    
    }
    var messages: [Message]?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(ChatLogCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatLogCell
        cell.messageTextView.text = messages?[indexPath.item].text
        return cell 
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}


class ChatLogCell : BaseCell {
    let messageTextView: UITextView =  {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Sample Message"
        return textView
    }()
    override func setupView() {
        super.setupView()
        backgroundColor = .blue
        addSubview(messageTextView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: messageTextView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: messageTextView)
    }
}
