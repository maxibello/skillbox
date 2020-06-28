//
//  CustomTextfield.swift
//  skillbox_11.1
//
//  Created by Максим Кузнецов on 17.06.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class CustomTextField: UIControl {
    
    public struct TextFieldStatus: Equatable {
        let message: String
        let progressOffset: Float
        let color: UIColor
        let lettersCount: Int
    }
    
    public var statuses: [TextFieldStatus] = [
        TextFieldStatus(message: "Слишком короткий пароль", progressOffset: 0.33, color: .red, lettersCount: 3),
        TextFieldStatus(message: "Добавьте еще немного символов", progressOffset: 0.66, color: .yellow, lettersCount: 6),
        TextFieldStatus(message: "Еще совсем чуть-чуть", progressOffset: 0.66, color: .blue, lettersCount: 8),
        TextFieldStatus(message: "Надежный пароль", progressOffset: 1, color: .green, lettersCount: 9)
    ]
    
    var statusOffset: CGFloat {
        return bounds.size.width / CGFloat(statuses.count)
    }
    
    public var currentStatus: TextFieldStatus? {
        didSet {
            updateStatus()
        }
    }
    
    public var textFieldHeight: CGFloat = 31
    public var verticalSpacing: CGFloat = 3
    public var messageLabelHeight: CGFloat = 15
    public var statusHeight: CGFloat = 5
    
    public var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var statusView: UIView = {
        let statusView = UIView()
        statusView.translatesAutoresizingMaskIntoConstraints = false
        return statusView
    }()
    
    private var currentStatusConstraint: NSLayoutConstraint!
    
    private var currentStatusView: UIView = {
        let currentStatusView = UIView()
        currentStatusView.translatesAutoresizingMaskIntoConstraints = false
        return currentStatusView
    }()
    
    private var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(checkStatus), for: .editingChanged)
        statusView.backgroundColor = .lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue", size: 12.0)
        
        addSubview(textField)
        addSubview(statusView)
        addSubview(currentStatusView)
        addSubview(messageLabel)
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        currentStatusConstraint = currentStatusView.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.widthAnchor.constraint(equalToConstant: bounds.size.width),
            textField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            statusView.leadingAnchor.constraint(equalTo: leadingAnchor),
            statusView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: verticalSpacing),
            statusView.widthAnchor.constraint(equalToConstant: bounds.size.width),
            statusView.heightAnchor.constraint(equalToConstant: statusHeight),
            currentStatusView.leadingAnchor.constraint(equalTo: leadingAnchor),
            currentStatusView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: verticalSpacing),
            currentStatusView.heightAnchor.constraint(equalToConstant: statusHeight),
            currentStatusConstraint,
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: verticalSpacing),
            messageLabel.widthAnchor.constraint(equalToConstant: bounds.size.width),
            messageLabel.heightAnchor.constraint(equalToConstant: messageLabelHeight)
        ])
    }
    
    @objc func checkStatus() {
        guard let lettersCount = textField.text?.count else {
            return
        }
            
        if let statusIndex = statuses.firstIndex(where: { item in
            item.lettersCount > lettersCount
        }) {
            print(statusIndex)
            currentStatus = statuses[statusIndex]
        } else if !statuses.isEmpty {
            currentStatus = statuses[statuses.count - 1]
        }
        
    }
    
    func updateStatus() {
        if let currentStatus = currentStatus {
            currentStatusConstraint.constant = CGFloat((statuses.firstIndex(of: currentStatus) ?? 0) + 1) * self.statusOffset
            UIView.animate(withDuration: 0.2, animations: {
                self.currentStatusView.backgroundColor = currentStatus.color
                self.messageLabel.text = currentStatus.message
                self.setNeedsLayout()
            })

        }
    }
    
}
