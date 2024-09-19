//
//  ExerciseTableViewCell.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit
import RealmSwift

protocol ExerciseCheckCellDelegate: AnyObject {
    func didTapEditExercise(_ exercise: ScheduleExercise)
    func didToggleExerciseCompletion(_ exercise: ScheduleExercise)
}

class ExerciseCheckCell: UITableViewCell {
    static let identifier = "ExerciseCheckCell"
    weak var delegate: ExerciseCheckCellDelegate?
    private var currentExercise: ScheduleExercise?
    private var viewModel = ScheduleViewModel()
    
    lazy var exerciseNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.font(.pretendardBold, ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var exerciseEditContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var exerciseEditButton: UIButton = {
        let button = UIButton(type: .system)
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = "수정"
        configuration.baseBackgroundColor = .colorAccent
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    lazy var checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didToggleCheckboxExercise(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .colorSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var setsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .color1E1E1E
        contentView.addSubview(exerciseNameLabel)
        contentView.addSubview(exerciseEditContainer)
        contentView.addSubview(separatorLine)
        contentView.addSubview(setsContainer)
        
        NSLayoutConstraint.activate([
            exerciseNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            exerciseNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            exerciseNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            exerciseEditContainer.topAnchor.constraint(equalTo: exerciseNameLabel.bottomAnchor, constant: 13),
            exerciseEditContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            exerciseEditContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            separatorLine.topAnchor.constraint(equalTo: exerciseEditContainer.bottomAnchor, constant: 13),
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separatorLine.heightAnchor.constraint(equalToConstant: 2),
            
            setsContainer.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 10),
            setsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            setsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            setsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            setsContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with scheduleExercise: ScheduleExercise) {
        currentExercise = scheduleExercise
        exerciseNameLabel.text = scheduleExercise.exercise?.name
        createExerciseEditView(scheduleExercise)
        setsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for set in scheduleExercise.sets {
            let setView = createSetView(set: set)
            setsContainer.addArrangedSubview(setView)
        }
    }
    
    private func createExerciseEditView(_ scheduleExercise: ScheduleExercise) {
        exerciseEditButton.addTarget(self, action: #selector(editExercise), for: .touchUpInside)
        
        checkboxButton.isSelected = scheduleExercise.isCompleted
        [exerciseEditButton, checkboxButton].forEach {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        let stackView = UIStackView(arrangedSubviews: [
            exerciseEditButton, checkboxButton
        ])
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        exerciseEditContainer.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: exerciseEditContainer.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: exerciseEditContainer.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: exerciseEditContainer.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: exerciseEditContainer.bottomAnchor),
            
            stackView.heightAnchor.constraint(equalToConstant: 24),
            
            exerciseEditButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 55),
            checkboxButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 24),
            checkboxButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
        ])
    }
    
    private func createSetView(set: ScheduleExerciseSet) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let setNumber = UILabel()
        setNumber.text = "\(set.order) 세트"
        setNumber.font = UIFont.font(.pretendardMedium, ofSize: 14)
        setNumber.textColor = .white
        
        let weightLabel = UILabel()
        weightLabel.text = "\(set.weight) kg"
        weightLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        weightLabel.textColor = .white
        
        let repsLabel = UILabel()
        repsLabel.text = "\(set.reps) 회"
        repsLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        repsLabel.textColor = .white
        
        let checkboxBtn = UIButton(type: .custom)
        checkboxBtn.setImage(UIImage(systemName: "square"), for: .normal)
        checkboxBtn.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        checkboxBtn.tintColor = .white
        checkboxBtn.isSelected = set.isCompleted
        checkboxBtn.tag = set.order
        checkboxBtn.addTarget(self, action: #selector(didToggleCheckboxSet(_:)), for: .touchUpInside)
        checkboxBtn.translatesAutoresizingMaskIntoConstraints = false
        
        [setNumber, weightLabel, repsLabel, checkboxBtn].forEach {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        let stackView = UIStackView(arrangedSubviews: [
            setNumber, weightLabel, repsLabel, checkboxBtn
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
            
            checkboxBtn.widthAnchor.constraint(greaterThanOrEqualToConstant: 24),
            checkboxBtn.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
            
            view.heightAnchor.constraint(equalToConstant: 37),
        ])

        return view
    }
    
    @objc private func didToggleCheckboxSet(_ sender: UIButton) {
        sender.isSelected.toggle()
        // save it to the database
        guard let exercise = currentExercise else { return }
        
        let setOrder = sender.tag
        viewModel.toggleSetCompletion(for: exercise, setOrder: setOrder, isCompleted: sender.isSelected)
                
        // Update UI
        checkboxButton.isSelected = exercise.isCompleted
        
        // Notify delegate
        delegate?.didToggleExerciseCompletion(exercise)
    }
    
    @objc private func didToggleCheckboxExercise(_ sender: UIButton) {
        sender.isSelected.toggle()
        guard let exercise = currentExercise else { return }
        
        viewModel.toggleExerciseCompletion(for: exercise, isCompleted: sender.isSelected)
        
        // Update UI
        for view in setsContainer.arrangedSubviews {
            if let checkboxBtn = view.subviews.first(where: { $0 is UIButton }) as? UIButton {
                checkboxBtn.isSelected = sender.isSelected
            }
        }
        
        // Notify delegate
        delegate?.didToggleExerciseCompletion(exercise)
    }
    
    @objc private func editExercise() {
        guard let exercise = currentExercise else { return }
        delegate?.didTapEditExercise(exercise)
    }
}

extension ExerciseCheckCell {
    func addSeparator() {
        let separator = UIView()
        separator.backgroundColor = .colorSecondary
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 2),
        ])
    }
}
