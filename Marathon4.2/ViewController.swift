//
//  ViewController.swift
//  Marathon4.2
//
//  Created by юра on 11.03.23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var button = UIBarButtonItem()
    var isSelectedArray: [Bool] = []
    var selectedItems: [String: Bool] = [:]
    
    var myDataArray = (0...30).map { String($0) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8065623045, green: 0.841209352, blue: 0.8440656066, alpha: 1)
        table.layer.cornerRadius = 10
        table.layer.masksToBounds = true
        button = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleCells))
        navigationItem.rightBarButtonItem = button
        navigationItem.title = "Task 4"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8065623045, green: 0.841209352, blue: 0.8440656066, alpha: 1)
        button.tintColor = .black
        
    }
    
    @objc func shuffleCells() {
        let animate = true
        UIView.transition(with: table, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.myDataArray.shuffle()
            self.isSelectedArray.shuffle()
            self.table.reloadData()

            if animate {
                for i in 0..<self.table.numberOfRows(inSection: 0) {
                    if let cell = self.table.cellForRow(at: IndexPath(row: i, section: 0)) {
                        let translation = CGAffineTransform(translationX: CGFloat.random(in: -100...100), y:0)
                        let rotation = CGAffineTransform(rotationAngle: CGFloat.random(in: -CGFloat.pi/2...CGFloat.pi/2))
                        cell.transform = translation.concatenating(rotation)
                        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                            cell.transform = .identity
                        }, completion: nil)
                    }
                }
            }
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = myDataArray[indexPath.row]
        cell.textLabel?.text = item
        
        if let isSelected = selectedItems[item], isSelected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        tableView.separatorStyle = .singleLine
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = myDataArray[indexPath.row]
        if let isSelected = selectedItems[item], isSelected {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .none
            }
            selectedItems.removeValue(forKey: item)
        } else {
            selectedItems[item] = true
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            let selectedItem = myDataArray[indexPath.row]
            myDataArray.remove(at: indexPath.row)
            myDataArray.insert(selectedItem, at: 0)
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: indexPath.section))
            tableView.deselectRow(at: IndexPath(row: 0, section: indexPath.section), animated: true)
            tableView.separatorStyle = .singleLine
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
