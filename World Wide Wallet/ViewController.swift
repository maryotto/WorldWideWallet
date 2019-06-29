//
//  ViewController.swift
//  World Wide Wallet
//
//  Created by Mary Otto on 6/23/19.
//  Copyright © 2019 Mary Otto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var defaultsData = UserDefaults.standard
    var cards: [Card] = []
    var transactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadDefaultsData()
 
    }
    
    func saveDefaultsData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cards) {
            UserDefaults.standard.set(encoded, forKey: "cards")
            print("*** Hurray! saving cards worked!")
        } else {
            print("ERROR: saving cards did not work")
        }
    }
    
    func loadDefaultsData() {
        guard let cardsEncoded = UserDefaults.standard.value(forKey: "cards") as? Data else {
            print("Coudl not load cards data from UserDefaults")
            return
        }
        let decoder = JSONDecoder()
        if let cards = try? decoder.decode(Array.self, from: cardsEncoded) as [Card] {
            self.cards = cards
        } else {
            print("ERROR: coudl not JSONdecode cards from UserDefaults")
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAccount" {
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.topViewController as! DetailVC
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.card = cards[selectedIndexPath.row]
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromAddCard(segue: UIStoryboardSegue) {
        let source = segue.source as! AddCardViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            cards[selectedIndexPath.row] = source.card
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: cards.count, section: 0)
            cards.append(source.card)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        saveDefaultsData()
    }
    
    @IBAction func unwindFromDetailVC(segue: UIStoryboardSegue) {
//        let source = segue.source as! DetailVC
//        if let selectedIndexPath = tableView.indexPathForSelectedRow {
//            cards[selectedIndexPath.row] = source.card
//            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
//        } else {
//            let newIndexPath = IndexPath(row: cards.count, section: 0)
//            cards.append(source.card)
//            tableView.insertRows(at: [newIndexPath], with: .bottom)
//            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
//        }
//        saveDefaultsData()
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing == true {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cards[indexPath.row].name
        cell.textLabel?.font = UIFont(name:"Avenir Next Condensed", size:30)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cards.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveDefaultsData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = cards[sourceIndexPath.row]
        cards.remove(at: sourceIndexPath.row)
        cards.insert(itemToMove, at: destinationIndexPath.row)
        saveDefaultsData()
    }
}



