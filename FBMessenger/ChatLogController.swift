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
        if let message = messages?[indexPath.item], let messageText = message.text, let profileImageName = message.friend?.profileImageName{
            let size = CGSize(width:250, height:1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimateFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            if !message.isSender{
                
                cell.messageTextView.frame = CGRect(x: 48+8, y: 0, width: estimateFrame.width+16, height: estimateFrame.height+20)
                cell.textBubbleView.frame = CGRect(x: 48-10, y: -4, width: estimateFrame.width+16+8+16, height: estimateFrame.height+20+6)
                cell.profileImageView.image = UIImage(named: profileImageName)
                cell.profileImageView.isHidden = false
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
            }else{
                
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimateFrame.width-16-8-10, y: 0, width: estimateFrame.width+16, height: estimateFrame.height+20)
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimateFrame.width-16-8-8-10, y: -4, width: estimateFrame.width+16+8+10, height: estimateFrame.height+20+6)
                cell.bubbleImageView.image = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
                cell.bubbleImageView.tintColor = UIColor(red:0, green:137/255, blue: 249/255, alpha:1)
                cell.messageTextView.textColor = .white
                cell.profileImageView.isHidden = true
                
            }
            
            
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
        return view
    }()
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let bubbleImageView: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
        view.tintColor = UIColor(white: 0.90, alpha: 1)
        return view
    }()
    override func setupView() {
        super.setupView()
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
        profileImageView.backgroundColor = .red
        
        textBubbleView.addSubview(bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
    }
}
