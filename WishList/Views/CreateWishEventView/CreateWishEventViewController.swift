//
//  CreateWishEventViewController.swift
//  WishList
//
//  Created by Egor Kolobaev on 16.03.2025.
//

import UIKit

final class CreateWishEventViewController: UIViewController {

    private let addEvent: (WishEventDataModel) -> ()

    private let stack: UIStackView = UIStackView()
    private let titleInput: UITextField = UITextField()
    private let descriptionInput: UITextField = UITextField()

    private let startDateStack: UIStackView = UIStackView()
    private let startDateTitle: UILabel = UILabel()
    private let startDatePicker: UIDatePicker = UIDatePicker()

    private let endDateStack: UIStackView = UIStackView()
    private let endDateTitle: UILabel = UILabel()
    private let endDatePicker: UIDatePicker = UIDatePicker()

    private let calendarService: CalendarEventsService = CalendarEventsServiceImpl()

    init(addEvent: @escaping (WishEventDataModel) -> ()) {
        self.addEvent = addEvent

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Constants.createTitleText,
            style: .done,
            target: self,
            action: #selector(createEvent)
        )
        navigationItem.title = Constants.mainHeader
        navigationController?.navigationBar.prefersLargeTitles = true

        configureUI()
    }

    private func configureUI() {
        stack.axis = .vertical
        view.addSubview(stack)
        stack.spacing = Constants.spacing

        for subview in [
            titleInput,
            descriptionInput,
            startDateStack,
            endDateStack
        ] {
            stack.addArrangedSubview(subview)
        }

        configureTitleInput()
        configureDescriptionInput()
        configureDatePicker(
            stack: startDateStack,
            title: startDateTitle,
            picker: startDatePicker,
            titleText: Constants.startDateSelect
        )

        configureDatePicker(
            stack: endDateStack,
            title: endDateTitle,
            picker: endDatePicker,
            titleText: Constants.endDateSelect
        )

        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.spacing),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.leadingStack),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.leadingStack.negative)
        ])
    }

    private func configureTitleInput() {
        titleInput.font = Constants.titleFont
        titleInput.textColor = .black
        titleInput.placeholder = Constants.titlePlaceholder
        titleInput.borderStyle = .roundedRect
        titleInput.layer.borderColor = UIColor.systemGray4.cgColor

        titleInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleInput.heightAnchor.constraint(equalToConstant: Constants.titleHeight)
        ])
    }

    private func configureDescriptionInput() {
        descriptionInput.font = Constants.descriptionFont
        descriptionInput.textColor = .black
        descriptionInput.placeholder = Constants.descriptionPlaceholder
        descriptionInput.borderStyle = .roundedRect
        descriptionInput.layer.borderColor = UIColor.systemGray4.cgColor

        descriptionInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionInput.heightAnchor.constraint(equalToConstant: Constants.descriptionHeight)
        ])
    }

    private func configureDatePicker(
        stack: UIStackView,
        title: UILabel,
        picker: UIDatePicker,
        titleText: String
    ) {
        stack.axis = .horizontal
        stack.spacing = Constants.horizontalSpacing

        for subview in [title, picker] {
            stack.addArrangedSubview(subview)
        }

        title.text = titleText
        title.textColor = .systemBlue
        title.translatesAutoresizingMaskIntoConstraints = false

        picker.datePickerMode = .dateAndTime
        picker.center = view.center
        picker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.dateLabelHeight),
            stack.heightAnchor.constraint(equalToConstant: Constants.dateStackHeight)
        ])
    }

    @objc
    private func createEvent() {
        guard let title = titleInput.text, !title.isEmpty else {
            let alert = UIAlertController(title: Constants.titleEmpty, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        let model = WishEventDataModel(
            title: title,
            description: descriptionInput.text ?? "",
            startDate: startDatePicker.date,
            endDate: endDatePicker.date
        )

        if calendarService.create(eventModel: model.calendarEvent) {
            addEvent(model)
            dismiss(animated: true)
        }
        else {
            let alert = UIAlertController(title: Constants.errorCalendarTitle, message: Constants.errorCalendarMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

}

private enum Constants {
    static let createTitleText: String = "Create"
    static let mainHeader: String = "Create wish event"
    static let titlePlaceholder: String = "Enter title"
    static let descriptionPlaceholder: String = "Enter description"
    static let startDateSelect: String = "Select start date"
    static let endDateSelect: String = "End start date"
    static let errorCalendarTitle: String = "Can't add the event to the calendar"
    static let errorCalendarMessage: String = "Check that you've granted the access to the calendar"
    static let titleEmpty: String = "Title field is in fact empty"

    static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
    static let descriptionFont: UIFont = .systemFont(ofSize: 14)

    static let spacing: CGFloat = 20
    static let horizontalSpacing: CGFloat = 50
    static let borderWidth: CGFloat = 1
    static let cornerRadius: CGFloat = 8
    static let leadingStack: CGFloat = 15

    static let dateLabelHeight: CGFloat = 20
    static let titleHeight: CGFloat = 30
    static let descriptionHeight: CGFloat = 40
    static let dateStackHeight: CGFloat = 40
}
