//
//  HistoryVC.swift
//  GetTracks
//
//  Created by Ринат Гареев on 11.01.2022.
//

import UIKit

class HistoryVC: UIViewController {
    
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Data for table
    var history: [SearchHistory]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        safeArea = view.safeAreaLayoutGuide
        
        self.navigationItem.title = "History"
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "history-cell")
        
        setupTableView()
    }
    
    private func setupTableView() {
        
        // Configure tableView
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
    
    private func fetchSearchHistory() {
        
        // Fetch the data from CoreData
        do {
            self.history = try context.fetch(SearchHistory.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Unable to fetch data from CoreData")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch the data from CoreData
        do {
            self.history = try context.fetch(SearchHistory.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Unable to fetch data from CoreData")
        }
    }
}

extension HistoryVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "history-cell", for: indexPath)
        
        let search = history![indexPath.row]
        
        cell.textLabel?.text = search.searchText
        
        return cell
    }
}


extension HistoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            action, view, completionHandler in
            
            let searchToRemove = self.history![indexPath.row]
            
            self.context.delete(searchToRemove)
            
            do {
                try self.context.save()
            } catch {
                print("Could not save to database after removing")
            }
            self.fetchSearchHistory()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tappedHistory = self.history![indexPath.row].searchText
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.string(forKey: "history")
        userDefaults.set(tappedHistory, forKey: "history")
        self.tabBarController?.selectedIndex = 0
    }
}
