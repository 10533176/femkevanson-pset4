//
//  DataBaseHelper.swift
//  femkevanson-pset4
//
//  Created by Femke van Son  on 22-11-16.
//  Copyright © 2016 Femke van Son . All rights reserved.
//

import Foundation

import SQLite

class DataBaseHelper {
    
    private let notes = Table("notes")
    
    private let note = Expression<String?>("note")
    
    private let id = Expression<Int64>("id")

    private var db: Connection?
    
    // initialise data file
    init? () {
        
        do {
            
            try setupDataBase()
        
        } catch {
            
            print (error)
            return nil
     
        }
    }
    
    
    
    private func setupDataBase() throws {
        
        // use to save the data in path
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
        do {
            
            db = try Connection("\(path)/db.sqlite3")
            try createTable()
        
        } catch {
            throw error
            
        }
        
        // deletes whole list
        //try db?.run(notes.delete())
    
    }
    
    //function to create table with columnns 
    private func createTable() throws {
        
        do {
            try db!.run(notes.create(ifNotExists: true) {
                t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(note)
            })
            
        } catch {
            
            throw error
        }
    }
    
    // adding a new note in data base
    func create(note: String) throws {
        
        let insert = notes.insert(self.note <- note)
        do {
            
            let rowID = try db!.run(insert)
            print (rowID)
            
        } catch {
            
            throw error
            
        }
        
    }
    
    // function to read from database, returns array of all the elements
    func read() throws  -> [String] {
    
        var result = [String]()
        for user in try db!.prepare(notes.select(note)) {
            
            result.insert(user[note]!, at: 0)

        }
        print (result)
        return result
    }
    
    // deleting note of the selected row
    func delete(taskName: String) throws {
        let deletedRows = notes.filter(note == taskName)
        
        do {
            del = try db!.run(deletedRows.delete())
            print ("deleted \(del)")
        } catch {
            throw error
        }
    }

}


    
    
