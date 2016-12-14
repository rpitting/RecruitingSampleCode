//
//  MenuViewController.swift
//  CodingChallenge
//
//  Created by Reiner Pittinger on 14.12.16.
//  Copyright © 2016 clapp GmbH. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    var navigationEntry: NavigationEntry? {
        didSet {
            title = navigationEntry?.label
        }
    }
    
    var selectedUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let entry = navigationEntry else { return 0 }
        
        if entry.sections.count > 0 {
            return entry.sections.count
        }
        
        // Only nodes and links
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let entry = navigationEntry else { return 0 }
        
        if entry.sections.count > 0 {
            return entry.sections[section].children.count
        }
        
        return entry.children.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NavigationEntry", for: indexPath)

        guard let entry = entry(at: indexPath) else {
            cell.textLabel?.text = "Invalid index path: \(indexPath)"
            return cell
        }
        
        cell.textLabel?.text = entry.label
        
        cell.accessoryType = .none
        if (type(of: entry) == Node.self) {
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }
    
    func entry(at indexPath: IndexPath) -> NavigationEntry? {
        guard let entry = navigationEntry else { return nil }
        
        if entry.sections.count > 0 {
            return entry.sections[indexPath.section].children[indexPath.row] as? NavigationEntry
        }
        
        return entry.children[indexPath.row] as? NavigationEntry
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToRoot" {
            dismiss(animated: true, completion: {})
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let entry = entry(at: indexPath) else { return }
        
        if let link = entry as? Link {
            selectedUrl = link.url
            
            performSegue(withIdentifier: "unwindToRoot", sender: nil)
        } else if let node = entry as? Node {
            guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
            
            menuViewController.navigationEntry = node
            navigationController?.pushViewController(menuViewController, animated: true)
        } else {
            assertionFailure("Unknown entry type")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let entry = navigationEntry else { return nil }
        
        if entry.sections.count > 0 {
            return entry.sections[section].label
        }
        
        return entry.label
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: {})
    }

}

extension MenuViewController {
    
    func loadMenuData() {
        
    }
    
}
