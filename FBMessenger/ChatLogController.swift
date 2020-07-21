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
        if let messageText = messages?[indexPath.item].text, let profileImageName = messages?[indexPath.item].friend?.profileImageName{
            let size = CGSize(width:250, height:1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimateFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            cell.messageTextView.frame = CGRect(x: 48+8, y: 0, width: estimateFrame.width+16, height: estimateFrame.height+20)
            cell.textBubbleView.frame = CGRect(x: 48, y: 0, width: estimateFrame.width+16+8, height: estimateFrame.height+20)
            cell.profileImageView.image = UIImage(named: profileImageName)
            
        }
        
        return cell 
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text{
            let size = CGSize(width:250, height:1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimateFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            return CGSize(width: collectionView.frame.width, height: estimateFrame.height+20)
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
}


class ChatLogCell : BaseCell {
    let messageTextView: UITextView =  {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample Message"
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
    }()
    let textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return view
    }()
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    override func setupView() {
        super.setupView()
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
        profileImageView.backgroundColor = .red
    }
}
