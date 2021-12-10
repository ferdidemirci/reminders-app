//
//  AddViewController.swift
//  RemindersApp
//
//  Created by Ferdi DEMİRCİ on 9.12.2021.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textFieldBody: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    public var completion: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(buttonSave))
    }
    @objc func buttonSave() {
        if let titleText = textFieldTitle.text, !titleText.isEmpty,
           let bodyText = textFieldBody.text, !bodyText.isEmpty {
            let targetDate = datePicker.date
            
            completion?(titleText, bodyText, targetDate)
        }
    }

}
