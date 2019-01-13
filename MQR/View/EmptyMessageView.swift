//
//  EmptyMessageView.swift
//  MQR
//
//  Created by Nuri Chun on 1/7/19.
//  Copyright © 2019 tetra. All rights reserved.
//

import UIKit
import Foundation

class EmptyMessageView: UIView {
    
    var searchImage: UIImageView = {
        // add image name here with string
        let image = UIImage(named: "search")
            let iv = UIImageView(image: image?.withRenderingMode(.alwaysOriginal))
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.clipsToBounds = true
            return iv
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Please Search For Location"
        label.font = UIFont.init(name: "AvenirNext-DemiBold", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        self.addSubview(searchImage)
        self.addSubview(messageLabel)

        searchImage.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: messageLabel.topAnchor, right: self.rightAnchor, topPad: 50, leftPad: 0, bottomPad: 0, rightPad: 0, width: 100, height: 100)
        
        messageLabel.anchor(top: searchImage.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topPad: 0, leftPad: 0, bottomPad: 0, rightPad: 0, width: 0, height: 0)
    
    }
}
