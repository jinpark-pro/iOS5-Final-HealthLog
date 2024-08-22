//
//  SelectedExerciseCell.swift
//  HealthLog
//
//  Created by seokyung on 8/13/24.
//

import UIKit

class SelectedExerciseCell: UITableViewCell, UITextFieldDelegate {
    var exerciseTitleLabel = UILabel()
    var deleteButton = UIButton(type: .system)
    let stepperLabel = UILabel()
    private let containerView = UIView()
    private let stackView = UIStackView()
    private var weightTextFields: [UITextField] = []
    private var repsTextFields: [UITextField] = []
    var deleteButtonTapped: (() -> Void)?
    var setsDidChange: ((_ sets: [ScheduleExerciseSetStruct]) -> Void)?
    private var currentSetCount: Int = 4
    private let stepper = UIStepper()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.backgroundColor = .colorPrimary
        
        exerciseTitleLabel.font = UIFont(name: "Pretendard-Semibold", size: 18)
        exerciseTitleLabel.textColor = .white
        exerciseTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(exerciseTitleLabel)
        
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = .white
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        // 컨테이너 뷰 설정
        containerView.backgroundColor = .colorSecondary
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // 스택뷰 설정
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        setupStepperComponents()
        updateSetInputs(for: currentSetCount)
        
        NSLayoutConstraint.activate([
            exerciseTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            exerciseTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            exerciseTitleLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -8),
            
            deleteButton.centerYAnchor.constraint(equalTo: exerciseTitleLabel.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            deleteButton.widthAnchor.constraint(equalToConstant: 14),
            deleteButton.heightAnchor.constraint(equalToConstant: 14),
            
            containerView.topAnchor.constraint(equalTo: exerciseTitleLabel.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -15),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            stackView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func setupStepperComponents() {
        let stepperLabel = UILabel()
        stepperLabel.text = "세트 수"
        stepperLabel.textColor = .white
        stepperLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        stepperLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stepperCountLabel = UILabel()
        stepperCountLabel.text = "\(currentSetCount)"
        stepperCountLabel.textColor = .white
        stepperCountLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        stepperCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.value = Double(currentSetCount)
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        stepper.layer.cornerRadius = 8
        stepper.backgroundColor = .colorAccent
        stepper.translatesAutoresizingMaskIntoConstraints = false
        
        // Stepper의 + 와 - 버튼의 색상 변경
        let config = UIImage.SymbolConfiguration(scale: .medium)
        let plusImage = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(config)
        let minusImage = UIImage(systemName: "minus")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(config)
        stepper.setIncrementImage(plusImage, for: .normal)
        stepper.setDecrementImage(minusImage, for: .normal)
        
        containerView.addSubview(stepperLabel)
        containerView.addSubview(stepperCountLabel)
        containerView.addSubview(stepper)
        
        NSLayoutConstraint.activate([
            stepperLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stepperLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            stepperCountLabel.leadingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -20),
            stepperCountLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            stepper.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stepper.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        //updateSetInputs(for: currentSetCount)
    }
    
    // 새로운 세트 수를 반영하여 UI를 업데이트, 변경된 세트 데이터를 클로저를 통해 뷰모델에 전달
    @objc func stepperValueChanged(sender: UIStepper) {
        let value = Int(sender.value)
        // print("\(exerciseTitleLabel.text ?? "Unknown exercise")의 스텝퍼 세트 수 변경: \(value)")
               
        if let stepperCountLabel = sender.superview?.subviews.compactMap({ $0 as? UILabel }).last {
            stepperCountLabel.text = "\(value)"
        }
        currentSetCount = value
        updateSetInputs(for: value)
        
        if let setsDidChange = setsDidChange {
            let sets = createScheduleExerciseSets()
            setsDidChange(sets)
        }
        
        if let viewController = self.parentViewController as? AddScheduleViewController {
            viewController.validateCompletionButton()
        }
    }
    
    // 세트 수가 변경되면 스택뷰 내의 기존 세트 입력 필드를 제거하고, 새로운 세트 수에 맞게 다시 생성
    // stepperValueChanged와 configure 메서드에서 호출되어 UI를 갱신(순서에 문제가 있음)
    func updateSetInputs(for count: Int) {
        // print("\(exerciseTitleLabel.text ?? "Unknown exercise")의 세트 수: \(count)")
               
        // print("업데이트 전 weightTextFields count: \(weightTextFields.count), repsTextFields count: \(repsTextFields.count)")
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        weightTextFields.removeAll()
        repsTextFields.removeAll()
        
        // 세트 입력 뷰 세트 수만큼 생성해서 스택뷰에 addSubview
        for i in 1...count {
            let setView = createSetInputView(setNumber: i)
            stackView.addArrangedSubview(setView)
        }
        // print("업데이트 후 weightTextFields count: \(weightTextFields.count), repsTextFields count: \(repsTextFields.count)")
        
        // 세트가 변경될 때마다 클로저를 호출해 뷰모델에 알려주기
        if let setsDidChange = setsDidChange {
            let sets = createScheduleExerciseSets() // 세트 생성하고
            setsDidChange(sets) // ViewModel에 업데이트
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // 각 세트에 대한 무게와 횟수 입력을 위한 뷰를 생성하는 메서드 [1세트 _kg _회]
    func createSetInputView(setNumber: Int) -> UIView {
        let setView = UIView()
        
        let setLabel = UILabel()
        setLabel.text = "\(setNumber) 세트"
        setLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        setLabel.textColor = .white
        
        let weightTextField = UITextField()
        weightTextField.font = UIFont.font(.pretendardMedium, ofSize: 14)
        weightTextField.textColor = .white
        weightTextField.textAlignment = .center
        weightTextField.keyboardType = .numberPad
        weightTextField.backgroundColor = .colorSecondary
        weightTextField.layer.cornerRadius = 10
        weightTextField.attributedPlaceholder = NSAttributedString(
            string: "무게",
            attributes: [
                .foregroundColor: UIColor.systemGray,
                .font: UIFont.font(.pretendardMedium, ofSize: 14)
            ]
        )
        
        let weightLabel = UILabel()
        weightLabel.text = "kg"
        weightLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        weightLabel.textColor = .white
        
        let repsTextField = UITextField()
        repsTextField.font = UIFont.font(.pretendardMedium, ofSize: 14)
        repsTextField.textColor = .white
        repsTextField.textAlignment = .center
        repsTextField.keyboardType = .numberPad
        repsTextField.backgroundColor = .colorSecondary
        repsTextField.layer.cornerRadius = 10
        repsTextField.attributedPlaceholder = NSAttributedString(
            string: "횟수",
            attributes: [
                .foregroundColor: UIColor.systemGray,
                .font: UIFont.font(.pretendardMedium, ofSize: 14)
            ]
        )
        
        
        let repsLabel = UILabel()
        repsLabel.text = "회"
        repsLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        repsLabel.textColor = .white
        
        setView.addSubview(setLabel)
        setView.addSubview(weightTextField)
        setView.addSubview(weightLabel)
        setView.addSubview(repsTextField)
        setView.addSubview(repsLabel)
        
        setLabel.translatesAutoresizingMaskIntoConstraints = false
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        repsTextField.translatesAutoresizingMaskIntoConstraints = false
        repsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            setView.heightAnchor.constraint(greaterThanOrEqualToConstant: 35),
            
            setLabel.leadingAnchor.constraint(equalTo: setView.leadingAnchor, constant: 8),
            setLabel.centerYAnchor.constraint(equalTo: setView.centerYAnchor),
            weightTextField.leadingAnchor.constraint(equalTo: setLabel.trailingAnchor, constant: 45),
            weightTextField.centerYAnchor.constraint(equalTo: setView.centerYAnchor),
            weightTextField.widthAnchor.constraint(equalToConstant: 58),
            weightTextField.heightAnchor.constraint(equalToConstant: 35),
            
            weightLabel.leadingAnchor.constraint(equalTo: weightTextField.trailingAnchor, constant: 8),
            weightLabel.centerYAnchor.constraint(equalTo: setView.centerYAnchor),
            
            repsTextField.leadingAnchor.constraint(equalTo: weightLabel.trailingAnchor, constant: 38),
            repsTextField.centerYAnchor.constraint(equalTo: setView.centerYAnchor),
            repsTextField.widthAnchor.constraint(equalToConstant: 58),
            repsTextField.heightAnchor.constraint(equalToConstant: 35),
            
            repsLabel.leadingAnchor.constraint(equalTo: repsTextField.trailingAnchor, constant: 8),
            repsLabel.centerYAnchor.constraint(equalTo: setView.centerYAnchor),
            repsLabel.trailingAnchor.constraint(equalTo: setView.trailingAnchor, constant: -8)
        ])
        weightTextField.delegate = self
        repsTextField.delegate = self
        
        weightTextFields.append(weightTextField)
        repsTextFields.append(repsTextField)
        
        return setView
    }
    
    @objc func deleteTapped() {
        deleteButtonTapped?()
    }
    
    func configure(with exerciseName: String, setCount: Int) {
        exerciseTitleLabel.text = exerciseName
        currentSetCount = setCount // 뷰 모델에서 가져온 세트 수로 설정 -> 이거 때문에 로그에 현재 세트 수 변경 없는 듯
        // print("Configuring cell \(exerciseName), 현재 세트 수: \(currentSetCount)")
        //updateSetInputs(for: currentSetCount) -> 여기서 update하면 무한루프에 빠지고 스텝퍼도 동작 안함
        // setsDidChange 클로저 때문에 뷰모델 업데이트되어서 configure(with:)와 updateSetInputs(for:) 간의 상호 호출이 반복
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if newText.count > 3 {
            return false
        }
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if allowedCharacters.isSuperset(of: characterSet) == false {
            return false
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        DispatchQueue.main.async {
            if let viewController = self.parentViewController as? AddScheduleViewController {
                viewController.validateCompletionButton()
            }
        }
        
        if let setsDidChange = setsDidChange {
            let sets = createScheduleExerciseSets()
            setsDidChange(sets)
        }
    }
    
    func areAllFieldsFilled() -> Bool {
        return stackView.arrangedSubviews.allSatisfy { setView in
            setView.subviews.compactMap { $0 as? UITextField }.allSatisfy { !$0.text!.isEmpty }
        }
    }

    func createScheduleExerciseSets() -> [ScheduleExerciseSetStruct] {
        return (0..<weightTextFields.count).compactMap { index in
            guard let weightText = weightTextFields[index].text, let weight = Int(weightText),
                  let repsText = repsTextFields[index].text, let reps = Int(repsText) else {
                return nil
            }
            let set = ScheduleExerciseSetStruct(order: index, weight: weight, reps: reps, isCompleted: false)
            //print("Created set: \(set)")
            return set
        }
    }
}
