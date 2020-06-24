//
//  CustomTextfield.swift
//  skillbox_11.1
//
//  Created by Максим Кузнецов on 17.06.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class CustomTextField: UIControl {
    
    public struct TextFieldStatus {
        let message: String
        let progressOffset: Float
        let color: UIColor
    }
    
    public var statuses: [TextFieldStatus] = [
        TextFieldStatus(message: "Слишком короткий пароль", progressOffset: 0.33, color: .red),
        TextFieldStatus(message: "Добавьте еще немного символов", progressOffset: 0.66, color: .yellow),
        TextFieldStatus(message: "Надежный пароль", progressOffset: 1, color: .green)
    ]
    
    public var currentStatus: TextFieldStatus? {
        didSet {
            updateStatus()
        }
    }
    
    public var width = 300
    public var textFieldHeight = 31
    public var verticalSpacing = 3
    public var messageLabelHeight = 15
    public var statusHeight = 5
    
    public var textField = UITextField(frame: CGRect.zero)
    private var statusView = UIView(frame: CGRect.zero)
    private var currentStatusView = UIView(frame: CGRect.zero)
    private var messageLabel = UILabel(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        var yOrigin = 0
        textField = UITextField(frame: CGRect(x: 0, y: yOrigin, width: width, height: textFieldHeight))
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(checkStatus), for: .editingChanged)
        
        yOrigin += textFieldHeight + verticalSpacing
        statusView = UIView(frame: CGRect(x: 0, y: yOrigin, width: width, height: statusHeight))
        statusView.backgroundColor = .lightGray
        
        currentStatusView = UIView(frame: CGRect(x: 0, y: yOrigin, width: 0, height: statusHeight))

        yOrigin += statusHeight + verticalSpacing
        messageLabel = UILabel(frame: CGRect(x: 0, y: yOrigin, width: width, height: messageLabelHeight))
        messageLabel.font = UIFont(name: "HelveticaNeue", size: 12.0)
        
        addSubview(textField)
        addSubview(statusView)
        addSubview(currentStatusView)
        addSubview(messageLabel)
    }
    
    @objc func checkStatus() {
        guard let lettersCount = textField.text?.count else {
            return
        }
        switch lettersCount {
        case 1..<4:
            currentStatus = statuses[0]
        case 4..<8:
            currentStatus = statuses[1]
        case 8..<20:
            currentStatus = statuses[2]
        default:
            currentStatus = nil
        }
    }
    
    func updateStatus() {
        if let currentStatus = currentStatus {
            UIView.animate(withDuration: 0.3, animations: {
                self.currentStatusView.frame.size.width = CGFloat(self.width) * CGFloat(currentStatus.progressOffset)
                self.currentStatusView.backgroundColor = currentStatus.color
                self.messageLabel.text = currentStatus.message
            })

        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.currentStatusView.frame.size.width = 0
                self.messageLabel.text = ""
            })
            
        }
    }
    
}
