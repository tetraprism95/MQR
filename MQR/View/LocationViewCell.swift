//
//  SearchResultsCell.swift
//  MQR
//
//  Created by Nuri Chun on 10/6/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import Foundation
import UIKit

class LocationViewCell: UITableViewCell {
    
    var locationIconImageView: UIImageView = {
        let image = UIImage(named: "locationLogo")
        let iv = UIImageView(image: image)
        iv.layer.cornerRadius = 50 / 2
        return iv
    }()
    
    var locationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cells" 
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(locationIconImageView)
        locationIconImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topPad: 8, leftPad: 8, bottomPad: 8, rightPad: 0, width: 50, height: 50)
        addSubview(locationTitleLabel)
        locationTitleLabel.anchor(top: topAnchor, left: locationIconImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topPad: 8, leftPad: 5, bottomPad: 8, rightPad: 8, width: 0, height: 0)
    }
}
