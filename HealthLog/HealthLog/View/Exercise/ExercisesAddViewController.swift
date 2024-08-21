//
//  ExercisesAddViewController.swift
//  HealthLog
//
//  Created by user on 8/17/24.
//

import Combine
import UIKit

class ExercisesAddViewController: UIViewController {
    
    // MARK: - Declare
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = ExerciseViewModel()
    private let numberOnlyDelegate = NumberOnlyTextFieldDelegate()
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    let titleStackView = UIStackView()
    let titleLabel = UILabel()
    let titleTextField = UITextField()
    let titleWarningLabel = UILabel()
    
    let bodypartStackView = UIStackView()
    let bodypartLabel = UILabel()
    var bodypartButtonStackView = CustomBodyPartButtonStackView()
    
    let recentWeightStackView = UIStackView()
    let recentWeightLabel = UILabel()
    let recentWeightTextField = UITextField()
    let recentWeightKGLabel = UILabel()
    
    let maxWeightStackView = UIStackView()
    let maxWeightLabel = UILabel()
    let maxWeightTextField = UITextField()
    let maxWeightKGLabel = UILabel()
    
    let descriptionStackView = UIStackView()
    let descriptionLabel = UILabel()
    let descriptionTextField = UITextField()
    
    
    let imageStackView = UIStackView()
    let imageLabel = UILabel()
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupNavigationBar()
        setupTitleStackView()
        setupBodypartStackView()
        setupRecentWeightStackView()
        setupMaxWeightStackView()
        setupDescriptionStackView()
        setupImageStackView()
        setupBindings()
    }
    
    // MARK: - Setup
    
    func setupNavigationBar() {
        title = "운동 추가"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // MARK: addButton
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
        self.navigationItem.rightBarButtonItem = doneButton
        
        // MARK: - scrollView
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
        ])
        
        // MARK: stackView
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.backgroundColor = .color252525
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupTitleStackView() {
        // MARK: titleStackView
        titleStackView.axis = .vertical
        titleStackView.distribution = .equalSpacing
        titleStackView.spacing = 10
        titleStackView.backgroundColor = .color1E1E1E
        stackView.addArrangedSubview(titleStackView)
        
        // MARK: titleLabel
        titleLabel.textColor = .white
        let titleLabelText = "운동 이름 *"
        let attributedString = NSMutableAttributedString(string: titleLabelText)
        let range = (titleLabelText as NSString).range(of: "*")
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        titleLabel.attributedText = attributedString
        titleStackView.addArrangedSubview(titleLabel)
        
        // MARK: titleTextField
        titleTextField.textColor = .white
        titleStackView.addArrangedSubview(titleTextField)
        
        // MARK: titleWarningLabel
        titleWarningLabel.text = "이미 존재하는 운동 이름입니다."
        titleWarningLabel.numberOfLines = 1
        titleWarningLabel.textColor = .red
        titleStackView.addArrangedSubview(titleWarningLabel)
    }
    
    func setupBodypartStackView() {
        // MARK: bodypartStackView
        bodypartStackView.axis = .vertical
        bodypartStackView.distribution = .equalSpacing
        bodypartStackView.spacing = 10
        bodypartStackView.alignment = .leading
        bodypartStackView.backgroundColor = .color1E1E1E
        stackView.addArrangedSubview(bodypartStackView)
        
        // MARK: bodypartLabel
        bodypartLabel.textColor = .white
        let bodypartLabelText = "운동 부위 *"
        let attributedString = NSMutableAttributedString(string: bodypartLabelText)
        let range = (bodypartLabelText as NSString).range(of: "*")
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        bodypartLabel.attributedText = attributedString
        bodypartStackView.addArrangedSubview(bodypartLabel)
        
        // MARK: bodypartButtonStackView
        bodypartStackView.addArrangedSubview(bodypartButtonStackView)
    }
    
    func setupRecentWeightStackView() {
        // MARK: recentWeightStackView
        recentWeightStackView.axis = .vertical
        recentWeightStackView.distribution = .equalSpacing
        recentWeightStackView.spacing = 10
        recentWeightStackView.backgroundColor = .color1E1E1E
        stackView.addArrangedSubview(recentWeightStackView)
        
        // MARK: recentWeightLabel
        recentWeightLabel.textColor = .white
        recentWeightLabel.text = "최근 무게"
        recentWeightStackView.addArrangedSubview(recentWeightLabel)
        
        // MARK: recentWeightTextField
        recentWeightTextField.textColor = .white
        recentWeightTextField.delegate = numberOnlyDelegate
        recentWeightTextField.keyboardType = .numberPad
        recentWeightStackView.addArrangedSubview(recentWeightTextField)
    }
    
    func setupMaxWeightStackView() {
        // MARK:  maxWeightStackView
        maxWeightStackView.axis = .vertical
        maxWeightStackView.distribution = .equalSpacing
        maxWeightStackView.spacing = 10
        maxWeightStackView.backgroundColor = .color1E1E1E
        stackView.addArrangedSubview( maxWeightStackView)
        
        // MARK:  maxWeightLabel
        maxWeightLabel.textColor = .white
        maxWeightLabel.text = "최대 무게"
        maxWeightStackView.addArrangedSubview( maxWeightLabel)
        
        // MARK: maxWeightTextField
        maxWeightTextField.textColor = .white
        maxWeightTextField.delegate = numberOnlyDelegate
        maxWeightTextField.keyboardType = .numberPad
        maxWeightStackView.addArrangedSubview(maxWeightTextField)
    }
    
    func setupDescriptionStackView() {
        // MARK: descriptionStackView
        descriptionStackView.axis = .vertical
        descriptionStackView.distribution = .equalSpacing
        descriptionStackView.spacing = 10
        descriptionStackView.backgroundColor = .color1E1E1E
        stackView.addArrangedSubview(descriptionStackView)
        
        // MARK: descriptionLabel
        descriptionLabel.textColor = .white
        descriptionLabel.text = "운동 설명"
        descriptionStackView.addArrangedSubview(descriptionLabel)
        
        // MARK: descriptionTextField
        descriptionTextField.textColor = .white
        descriptionStackView.addArrangedSubview(descriptionTextField)
    }
    
    func setupImageStackView() {
        // MARK: ImageStackView
        imageStackView.axis = .vertical
        imageStackView.distribution = .equalSpacing
        imageStackView.spacing = 10
        imageStackView.backgroundColor = .color1E1E1E
        stackView.addArrangedSubview(imageStackView)
        
        // MARK: imageLabel
        imageLabel.textColor = .white
        imageLabel.text = "운동 이미지"
        imageStackView.addArrangedSubview(imageLabel)
    }
    
    
    private func setupBindings() {
        // MARK: checkDuplicateExerciseName Warning
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: titleTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { text in
                self.viewModel.checkDuplicateExerciseName(to: text)
                self.viewModel.exerciseName = text
                print("titleTextField change - \(self.viewModel.exerciseName)")
            }
            .store(in: &cancellables)
        
        // MARK: bodypartButtonStackView
        
        
        // MARK: recentWeightTextField
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: recentWeightTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { text in
                print("recentWeightTextField change")
                self.viewModel.exerciseRecentWeight = Int(text) ?? 0
            }
            .store(in: &cancellables)
        
        // MARK: maxWeightTextField
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: maxWeightTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { text in
                print("maxWeightTextField change")
                self.viewModel.exerciseMaxWeight = Int(text) ?? 0
            }
            .store(in: &cancellables)
        
        // MARK: descriptionTextField
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: descriptionTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { text in
                print("descriptionTextField change")
                self.viewModel.exerciseDescription = text
            }
            .store(in: &cancellables)
        
        // MARK: Duplicate ExerciseName Warning
        viewModel.$hasDuplicateExerciseName
            .sink { [weak self] isDuplicateExerciseName in
                self?.titleWarningLabel.isHidden = !isDuplicateExerciseName
            }
            .store(in: &cancellables)
    }

    // MARK: - Methods
    
    @objc func doneButtonTapped() {
        print("doneButtonTapped!")
        viewModel.realmWriteExercise()
        navigationController?.popViewController(animated: true)
    }
}


class NumberOnlyTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString = textField.text ?? ""
        let updatedString = (currentString as NSString)
            .replacingCharacters(in: range, with: string)
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: updatedString)
        
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
