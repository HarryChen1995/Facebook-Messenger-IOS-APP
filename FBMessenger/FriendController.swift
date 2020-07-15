//
//  ViewController.swift
//  FBMessenger
//
//  Created by Hanlin Chen on 7/15/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit

class FriendController:  UICollectionViewController, UICollectionViewDelegateFlowLayout{
    let cellID = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(FriendCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.alwaysBounceVertical = true
        navigationItem.title = "Recent"
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }

}

class FriendCell : BaseCell{
    
    let progileImageView : UIImageView =  {
        
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
    override func setupView() {
        addSubview(progileImageView)
        addSubview(divider)
        setupContainerView()
        progileImageView.image = UIImage(named: "mark")
        hasReadImageView.image = UIImage(named: "mark")
        
        addConstraintsWithFormat(format: "H:|-12-[v0(68)]", views: progileImageView)
        addConstraintsWithFormat(format: "V:[v0(68)]", views: progileImageView)
        
        addConstraint(NSLayoutConstraint(item: progileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat(format: "H:|-83-[v0]|", views: divider)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: divider)
        
        
        

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
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: viewDict))
    }
}
