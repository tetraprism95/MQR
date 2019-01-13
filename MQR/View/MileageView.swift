//
//  DisplayDistanceView.swift
//  MQR
//
//  Created by Nuri Chun on 1/9/19.
//  Copyright © 2019 tetra. All rights reserved.
//

import Foundation
import UIKit

class MileageView : UIView {
    
    // Create a didSet soon here.
    
    var mileageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "thiryttooo"
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        label.textColor = .black
        label.numberOfLines = 0
        label.layer.cornerRadius = 10.0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        self.layer.cornerRadius = 10.0
        setupUI()
    }
    
    func setupUI() {
        
        self.addSubview(mileageLabel)
        mileageLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topPad: 10, leftPad: 10, bottomPad: 10, rightPad: 10, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
