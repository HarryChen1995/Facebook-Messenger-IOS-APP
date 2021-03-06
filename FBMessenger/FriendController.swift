//
//  ViewController.swift
//  FBMessenger
//
//  Created by Hanlin Chen on 7/15/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit


class FriendController:  UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    
    var messages: [Message]?

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    let cellID = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.alwaysBounceVertical = true
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteMessage))
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.title = "Recent"
        setupData()
    }
    @objc func deleteMessage(){
        
        if let   selectCellsIndexPath = collectionView.indexPathsForSelectedItems {
        let items = selectCellsIndexPath.map { $0.item }.sorted().reversed()
        for  item in items {
            
            messages?.remove(at: item)
        }
            collectionView.deleteItems(at: selectCellsIndexPath)
            navigationItem.rightBarButtonItem?.isEnabled = false
            setEditing(false, animated: true)
            
    }
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MessageCell
        if let message = messages?[indexPath.item]{
            cell.message = message
        }
        cell.isInEditingMode = isEditing
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !isEditing {
            navigationItem.rightBarButtonItem?.isEnabled = false
            let layout = UICollectionViewFlowLayout()
            let controller = ChatLogController(collectionViewLayout:layout)
            controller.friend = messages?[indexPath.item].friend
            navigationController?.pushViewController(controller, animated: true)
        }
        else{
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
        if let selectCells = collectionView.indexPathsForSelectedItems, selectCells.count == 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        }
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.allowsMultipleSelection = editing
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! MessageCell
            cell.isInEditingMode = editing
            }
        if !editing{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        collectionView.reloadData()

        
    }
}

class MessageCell : BaseCell{
    
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1) : .white
            nameLabel.textColor = isHighlighted ? .white : .black
            timeLabel.textColor = isHighlighted ? .white : .black
            messageLabel.textColor = isHighlighted ? .white : .black
        }
    }
    var message : Message? {
        didSet{
            nameLabel.text = message?.friend?.name
            
            if   let imageName = message?.friend?.profileImageName {
            profileImageView.image = UIImage(named: imageName)
            hasReadImageView.image = UIImage(named: imageName)
        }
            messageLabel.text = message?.text
            
            if let date = message?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                let elapseTimeInSeconds = Date().timeIntervalSince(date)
                let secondsInDay: TimeInterval = 60*60*24
                if elapseTimeInSeconds > 7*secondsInDay {
                     dateFormatter.dateFormat = "MM/dd/yy"
                }else if elapseTimeInSeconds > secondsInDay {
                    
                    dateFormatter.dateFormat = "EEE"
                }
                timeLabel.text = dateFormatter.string(from: date)
            }
     }
    }
    
    let profileImageView : UIImageView =  {
        
        let img_view = UIImageView()
        img_view.contentMode = .scaleAspectFill
        img_view.translatesAutoresizingMaskIntoConstraints = false
        img_view.layer.cornerRadius = 34
        img_view.layer.masksToBounds = true
        return img_view
        
    }()
    let divider : UIView = {
            let d = UIView()
        d.translatesAutoresizingMaskIntoConstraints = false
        d.backgroundColor =  UIColor(white: 0.5, alpha: 0.5)
        return d
    }()
    
    let nameLabel: UILabel  = {
        let label = UILabel()
        label.text = "Murk Zuckberg"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
        
    }()
    
    let messageLabel : UILabel = {
       let label = UILabel()
        label.text = "Your Friend Message"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    let timeLabel : UILabel = {
       let label = UILabel()
        label.text = "12:05 pm"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        let img_view = UIImageView()
        img_view.contentMode = .scaleAspectFill
        img_view.translatesAutoresizingMaskIntoConstraints = false
        img_view.layer.cornerRadius = 10
        img_view.layer.masksToBounds = true
        return img_view
    }()
    let checkMark: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = ""
        return label
    }()
    var isInEditingMode:Bool = false {
        didSet {
            checkMark.isHidden = !isInEditingMode
        }
    }
    override var isSelected: Bool{
        didSet {
            if isInEditingMode {
            checkMark.text = isSelected ? "☑" : "☐"
            }
        }
    }
    override func setupView() {
        addSubview(profileImageView)
        addSubview(divider)
        setupContainerView()
        profileImageView.image = UIImage(named: "zuckprofile")
        hasReadImageView.image = UIImage(named: "zuckprofile")
        
        addConstraintsWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(68)]", views: profileImageView)
        
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat(format: "H:|-83-[v0]|", views: divider)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: divider)
        
        addSubview(checkMark)
        addConstraintsWithFormat(format: "H:[v0(30)]-5-|", views: checkMark)
        addConstraintsWithFormat(format: "V:|[v0(30)]", views: checkMark)

        
        

    }
    
    func setupContainerView(){
        let containerView = UIView()
        addSubview(containerView)
        addConstraintsWithFormat(format: "H:|-90-[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: containerView)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    
        
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView)
        containerView.addConstraintsWithFormat(format: "H:|[v0][v1(80)]-12-|", views: nameLabel, timeLabel)
        containerView.addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
        containerView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLabel, hasReadImageView)
        containerView.addConstraintsWithFormat(format: "V:|[v0(24)]", views: timeLabel)
        containerView.addConstraintsWithFormat(format: "V:[v0(20)]|", views: hasReadImageView)
    
        
    }

}



class BaseCell : UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
    }
    
    func setupView(){
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewDict = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDict[key] = view
            
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: viewDict))
    }
}
