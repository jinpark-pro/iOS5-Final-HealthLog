//
//  ExercisesListCell.swift
//  HealthLog
//
//  Created by user on 8/12/24.
//

import UIKit

class ExerciseListCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    // 상단 영역
    let topStackView = UIStackView()
    let titleLabel = UILabel()
    let detailButton = UIButton(type: .system)
    
    // 구분선
    let dividerView = UIView()
    
    // 하단 영역
    let bottomStackView = UIStackView()
    var exerciseImageView = UIImageView()
    let bottomRightStackView = UIStackView()
    let bodypartStackView = UIStackView()
    var bodypartLabels: [CustomBodyPartLabel] = []
    let descriptionTextView = UITextView()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupTopStackView()
        setupDivider()
        setupBottomStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 13, left: 10, bottom: 0, right: 10))
    }
    
    // MARK: - Setup UI
    
    private func setupCell() {
        backgroundColor = .black
        contentView.backgroundColor = .colorSecondary
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        separatorInset = UIEdgeInsets(
            top: 30, left: 30, bottom: 30, right: 30)
    }
    
    private func setupTopStackView() {
        // MARK: topStackView
        topStackView.axis = .horizontal
        topStackView.distribution = .equalSpacing
        topStackView.alignment = .center
        topStackView.spacing = 8
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topStackView)
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor, 
                constant: 13),
            topStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, 
                constant: 16),
            topStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, 
                constant: -16),
        ])
        
        // MARK: titleLabel
        titleLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        titleLabel.textColor = .white
        topStackView.addArrangedSubview(titleLabel)
        
        // MARK: detailButton
        detailButton.setTitle("자세히 보기 ❯", for: .normal)
        detailButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        detailButton.setTitleColor(.lightGray, for: .normal)
        topStackView.addArrangedSubview(detailButton)
    }
    
    func setupDivider() {
        dividerView.backgroundColor = .color1E1E1E
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dividerView)
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(
                equalTo: topStackView.bottomAnchor,
                constant: 13),
            dividerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, 
                constant: 16),
            dividerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, 
                constant: -16),
            dividerView.heightAnchor.constraint(
                equalToConstant: 1)
        ])
    }
    
    private func setupBottomStackView() {
        // MARK: bottomStackView
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fill
        bottomStackView.spacing = 8
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bottomStackView)
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(
                equalTo: dividerView.bottomAnchor, 
                constant: 13),
            bottomStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, 
                constant: 22),
            bottomStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, 
                constant: -22),
            bottomStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, 
                constant: -26),
            bottomStackView.heightAnchor.constraint(
                equalToConstant: 100),
        ])
        
        // MARK: exerciseImageView
        exerciseImageView.contentMode = .scaleAspectFill
        exerciseImageView.clipsToBounds = true
        exerciseImageView.backgroundColor = .color3E3E3E
        exerciseImageView.layer.borderColor = UIColor.black.cgColor
        exerciseImageView.layer.borderWidth = 2.0
        exerciseImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.addArrangedSubview(exerciseImageView)
        NSLayoutConstraint.activate([
            exerciseImageView.widthAnchor.constraint(equalToConstant: 90),
            exerciseImageView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        // MARK: bottomRightStackView
        bottomRightStackView.axis = .vertical
        bottomRightStackView.distribution = .fill
        bottomRightStackView.spacing = 4
        bottomStackView.addArrangedSubview(bottomRightStackView)
        
        // MARK: bodypartStackView
        bodypartStackView.axis = .horizontal
        bodypartStackView.distribution = .fill
        bodypartStackView.spacing = 8
        bodypartStackView.translatesAutoresizingMaskIntoConstraints = false
        bodypartStackView.clipsToBounds = true
        bottomRightStackView.addArrangedSubview(bodypartStackView)
        
        // MARK: descriptionLabel
        descriptionTextView.font = UIFont(name: "Pretendard-Medium", size: 14)
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textColor = .color767676
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false
        bottomRightStackView.addArrangedSubview(descriptionTextView)
    }
    
    // MARK: - Configure
    
    func configure(with exercise: Exercise) {
        // exercise.name
        titleLabel.text = exercise.name
        
        // exercise.Image
        exerciseImageView.image = UIImage(data: exercise.image ?? Data())
        
        // exercise.bodyParts
        for part in exercise.bodyParts {
            let label = CustomBodyPartLabel()
            label.text = part.name.rawValue
            bodypartStackView.addArrangedSubview(label)
        }
        
        // exercise.descriptionText
        descriptionTextView.text = exercise.descriptionText
    }
    
}

