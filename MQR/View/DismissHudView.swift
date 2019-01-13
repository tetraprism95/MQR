//
//  DismissHudView.swift
//  MQR
//
//  Created by Nuri Chun on 1/9/19.
//  Copyright © 2019 tetra. All rights reserved.
//

import Foundation
import UIKit

protocol DismissHudViewDelegate {
    func dismissTapped()
}

class DismissHudView: UIView {
    
    var delegate: DismissHudViewDelegate?
    
    var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.backgroundColor = .lightGray
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 10)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    @objc func handleDismiss() {
        delegate?.dismissTapped()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        self.alpha = 0.0
        self.addSubview(dismissButton)
        dismissButton.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topPad: 0, leftPad: 0, bottomPad: 0, rightPad: 0, width: 0, height: 0)
    }
}
