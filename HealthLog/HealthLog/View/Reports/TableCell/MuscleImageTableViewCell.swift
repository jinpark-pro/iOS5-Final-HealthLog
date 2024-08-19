//
//  MuscleImageTableViewCell.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/19/24.
//

import UIKit

class MuscleImageTableViewCell: UITableViewCell {

    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = "8월 운동 기록"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.color2F2F2F
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var frontMuscleImage: UIImageView = {
        let imageView = UIImageView()
        let imageName = "front_body_layout"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(monthLabel)
        contentView.addSubview(divider)
        contentView.addSubview(frontMuscleImage)
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            monthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            divider.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 13),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            
        ])
        
        
        
        // Autolayout Constraints
        
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
