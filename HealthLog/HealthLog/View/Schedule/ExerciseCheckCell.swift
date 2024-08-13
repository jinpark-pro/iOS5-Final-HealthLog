//
//  ExerciseTableViewCell.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit

class ExerciseCheckCell: UITableViewCell {
    static let identifier = "ExerciseCheckCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "운동 타이틀"
        label.textColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let setsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let setView: UIView = {
        let view = UIView()
        
        let setNumber = UILabel()
        setNumber.text = "1 세트"
        setNumber.textColor = .white
        let weightLabel = UILabel()
        weightLabel.text = "10 kg"
        weightLabel.textColor = .white
        let repsLabel = UILabel()
        repsLabel.text = "10 회"
        repsLabel.textColor = .white
        let checkbox = UISwitch()
        checkbox.isOn = false
        checkbox.addTarget(ExerciseCheckCell.self, action: #selector(didToggleCheckbox(_:)), for: .valueChanged)
        
        view.addSubview(setNumber)
        view.addSubview(weightLabel)
        view.addSubview(repsLabel)
        view.addSubview(checkbox)
        
        setNumber.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        repsLabel.translatesAutoresizingMaskIntoConstraints = false
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            setNumber.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            setNumber.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            weightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            weightLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            repsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 200),
            repsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            checkbox.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkbox.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(named: "ColorSecondary")
        
        setsContainer.addArrangedSubview(setView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(setsContainer)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            setsContainer.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 13),
            setsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            setsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            setsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            setView.topAnchor.constraint(equalTo: setsContainer.topAnchor),
            setView.leadingAnchor.constraint(equalTo: setsContainer.leadingAnchor),
            setView.trailingAnchor.constraint(equalTo: setsContainer.trailingAnchor),
            setView.bottomAnchor.constraint(equalTo: setsContainer.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc private func didToggleCheckbox(_ sender: UISwitch) {
//        print("checkbox")
    }
}
