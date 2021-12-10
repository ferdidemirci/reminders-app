//
//  ViewController.swift
//  RemindersApp
//
//  Created by Ferdi DEMİRCİ on 9.12.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var reminders = [Reminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonAdd(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController else { return }
        vc.title = "New Reminder"
        vc.completion = { (title, body, date) in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let newReminder = Reminder(title: title, body: body, date: date, identifer: "id_\(title)")
                self.reminders.append(newReminder)
                self.tableView.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("Hata var la gardaş")
                    }
                })
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonRefresh(_ sender: Any) {
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = reminders[indexPath.row]
        
        cell.textLabel?.text = row.title!
        
        let formeter = DateFormatter()
        formeter.dateFormat = "dd, MMMM, YYYY"
        cell.detailTextLabel?.text = formeter.string(from: row.date!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: { (aciton, sourceView, completionHandler) in
            
            self.reminders.remove(at: indexPath.row)
            self.tableView.reloadData()
            completionHandler(true)
        })
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .destructive, title: nil, handler: { (aciton, sourceView, completionHandler) in
            let reminder = self.reminders[indexPath.row]
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                if success {
                    self.scheduletest(title: reminder.title!, body: reminder.body!)
                }else if error != nil {
                    print(error?.localizedDescription ?? "Error")
                }
            })
            completionHandler(true)
        })
        doneAction.image = UIImage(systemName: "checkmark")
        doneAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func scheduletest(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default
        content.body = body
        print(title)
        let targetDate = Date().addingTimeInterval(5)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .minute, .second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("Hata var la gardaş")
            }
        })
    }
}
