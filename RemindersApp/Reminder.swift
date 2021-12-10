//
//  Reminders.swift
//  RemindersApp
//
//  Created by Ferdi DEMİRCİ on 9.12.2021.
//

import Foundation
import UIKit

class Reminder {
    var title:String?
    var body:String?
    var date:Date?
    var identifer:String?
    
    init() {
        
    }
    
    init(title:String, body:String, date:Date, identifer:String) {
        self.title = title
        self.body = body
        self.date = date
        self.identifer = identifer
    }
}
