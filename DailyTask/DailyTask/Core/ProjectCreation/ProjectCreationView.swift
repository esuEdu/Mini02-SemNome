//
//  ProjectCreationViewController.swift
//  DailyTask
//
//  Created by Leonardo Mesquita Alves on 23/09/23.
//

import UIKit

class ProjectCreationView: UIViewController {
    
    var projectCreationViewModel: ProjectCreationViewModel?

    // MARK: - OFICIAL
    
    let iconButton: ChooseIconComponent = {
        let iconPicker = ChooseIconComponent()
        iconPicker.horizontalPadding = 10
        iconPicker.verticalPadding = 15
        iconPicker.iconName = "pencil.tip"
        iconPicker.translatesAutoresizingMaskIntoConstraints = false
        return iconPicker
    }()
    
    let textFieldToGetTheName: TextFieldToName = {
        let textField = TextFieldToName()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let colorChooser = ColorChooseComponent()
    
    let createButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        #warning("NSLocalized")
        button.setTitle("Criar no projeto", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let methodologyButton: ChooseMethodologyComponent = ChooseMethodologyComponent(font: UIFont.preferredFont(forTextStyle: .body), text: "Metodologia", textColor: .white)
    
    let descriptionTextField: TextDescriptionComponent = {
        let textField = TextDescriptionComponent()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.horizontalPadding = 10
        textField.verticalPadding = 10
        return textField
    }()
    
    // MARK: - Não oficial
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    
    let startDatePicker: DatePickerView <Date> = {
        let datePicker = DatePickerView <Date>()
        datePicker.datePickerMode = .dateAndTime
        return datePicker
    }()
    
    let endDatePicker: DatePickerView = {
        let datePicker = DatePickerView <Date>()
        datePicker.datePickerMode = .dateAndTime
        
        return datePicker
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        addAllConstraints()
        sendDateToViewModel()

    }
    
    
    func setUpUI(){
        methodologyButton.delegate = self
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = createRightButtom()
        self.navigationItem.leftBarButtonItem = createLeftButtom()
        self.title = "Criar projeto"
        self.view.addSubview(stackView)
        self.view.addSubview(iconButton)
        self.view.addSubview(textFieldToGetTheName)
        self.view.addSubview(colorChooser)
        stackView.addArrangedSubview(methodologyButton)
        stackView.addArrangedSubview(startDatePicker)
        stackView.addArrangedSubview(endDatePicker)
        view.addSubview(descriptionTextField)
        
        view.addSubview(createButton)
        
        iconButton.menu = setIcon()
        createButton.addTarget(self, action: #selector(defineProjectData), for: .touchUpInside)
        
    }

    
    func addAllConstraints(){
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: iconButton.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            iconButton.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20),
            iconButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            iconButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            iconButton.heightAnchor.constraint(equalToConstant: 93),
            iconButton.widthAnchor.constraint(equalToConstant: 93),
            
            textFieldToGetTheName.leadingAnchor.constraint(equalTo: iconButton.trailingAnchor, constant: 20),
            textFieldToGetTheName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textFieldToGetTheName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            
            colorChooser.topAnchor.constraint(equalTo: textFieldToGetTheName.bottomAnchor, constant: 12),
            colorChooser.leadingAnchor.constraint(equalTo: textFieldToGetTheName.leadingAnchor),
            colorChooser.trailingAnchor.constraint(equalTo: textFieldToGetTheName.trailingAnchor),
            colorChooser.bottomAnchor.constraint(equalTo: iconButton.bottomAnchor),
            
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            
            descriptionTextField.heightAnchor.constraint(equalToConstant: 132),
            descriptionTextField.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    #warning("REFATORAR")
    @objc func defineProjectData(){
        projectCreationViewModel?.colors = colorChooser.returnColorCGFloat()
        
        if (projectCreationViewModel?.compareDates() == .orderedAscending){
            self.projectCreationViewModel?.name = textFieldToGetTheName.textFieldToGetTheName.text == "" ? self.projectCreationViewModel?.name : textFieldToGetTheName.textFieldToGetTheName.text
            self.projectCreationViewModel?.description = descriptionTextField.getText() == "" ? self.projectCreationViewModel?.description : descriptionTextField.getText()
            
            self.projectCreationViewModel?.createAProject()
            self.projectCreationViewModel?.removeTopView()
        } else{
            print("")
            #warning("Temporary")
            let alert = UIAlertController(title: "Erro de criação", message: "Você não pode criar um projeto que termine no passado, a máquina do tempo não foi inventada ainda", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tentar de novo", style: .destructive))
            self.present(alert, animated: true)
        }
        
    }
    
    @objc func removeTheView(){
        projectCreationViewModel?.removeTopView()
    }

}

#warning("REFATORAR")
extension ProjectCreationView {

    func sendDateToViewModel(){
        startDatePicker.valueChangedHandler = { selectedDate in
            self.projectCreationViewModel?.start = selectedDate
            print(selectedDate)
        }
        
        endDatePicker.valueChangedHandler = { selectedDate in
            self.projectCreationViewModel?.end = selectedDate
            print(selectedDate)
        }
    }
    
    func createRightButtom() -> UIBarButtonItem{
        let buttonToContinue: UIBarButtonItem = {
            let button = UIBarButtonItem()
            button.title = "Concluido"
            button.target = self
            button.action = #selector(defineProjectData)
            return button
        }()

        return buttonToContinue
    }

    func createLeftButtom() -> UIBarButtonItem{
        let buttonToContinue: UIBarButtonItem = {
            let button = UIBarButtonItem()
            button.title = "Cancelar"
            button.tintColor = .systemRed
            button.target = self
            button.action = #selector(removeTheView)
            return button
        }()

        return buttonToContinue
    }

    func setIcon() -> UIMenu{
        let menuItems = UIMenu(title: "", options: .displayAsPalette, children: [
            
            UIAction(title: "Globo", image: UIImage(systemName: "globe.americas.fill"), handler: { _ in
                self.iconButton.iconName = "globe.americas.fill"
                self.projectCreationViewModel?.icon = self.iconButton.iconName
            }),
            
            UIAction(title: "PaperPlane", image: UIImage(systemName: "paperplane.fill"), handler: { _ in
                self.iconButton.iconName = "paperplane.fill"
                self.projectCreationViewModel?.icon = self.iconButton.iconName
            }),
            
            UIAction(title: "Pencil", image: UIImage(systemName: "pencil.tip.crop.circle.badge.plus") , handler: { _ in
                self.iconButton.iconName = "pencil.tip.crop.circle.badge.plus"
                self.projectCreationViewModel?.icon = self.iconButton.iconName
            }),
            
            
        ])
        
        return menuItems
    }

}

extension ProjectCreationView: ChooseMethodologyComponentDelegate {
    
    func setUpMenuFunction(type: Methodologies) {
        self.projectCreationViewModel?.methodology = type
        self.methodologyButton.methodology.text = "Methodology \(String(describing: self.projectCreationViewModel!.methodology!.rawValue))"
        self.methodologyButton.layoutIfNeeded()
        print("OI")
    }
}

