//
//  ViewController.swift
//  femkevanson-pset4
//
//  Created by Femke van Son  on 22-11-16.
//  Copyright © 2016 Femke van Son . All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //variable aanmaken
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var note: UITextField!
    @IBOutlet weak var addNote: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var currentPosition: Int?
    var text = [String]()
    var row = [Int]()
    
    
    private let db = DataBaseHelper()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if let bundle = Bundle.main.bundleIdentifier {
          //UserDefaults.standard.removePersistentDomain(forName: bundle)
        //}
        
        //check if dataBase != nil
        if db == nil {
            print ("Error")
        }
        
        // read in stored data
        read()
        reloadTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    // read data from database
    func read() {
        do {
            text = try db!.read()
        } catch {
            print (error)
        }
    }
    
    //when creating a new note 
    @IBAction func create(_ sender: Any) {
        do {
            try db!.create(note: note.text!)
        } catch {
            print (error)
        }
        
        note.text = ""
        note.placeholder = "To do..."
        read()
        reloadTableView()
        
    }
    
    
    // return number of cells for the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return text.count
        
    }
    
    // function to show to do notes in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotesCell
        
        cell.noteLabel.text = text[indexPath.row]
    
        return cell
    }
    
    // if row is clicked, mark as checked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        row.insert(indexPath.row, at: 0)
        
        let cell = tableView.cellForRow(at: indexPath) as! NotesCell
        
        cell.checkButton.setImage(UIImage(named: "tick-check-box-md.png"), for: UIControlState.normal)
        
    }

    // function to delete todo item
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let task = text[indexPath.row]
            
            do {
                try db!.delete(taskName: task)
            } catch {
                print ("error deleting task")
            }
        }
    }
}
