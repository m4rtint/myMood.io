//
//  FirebaseDB.swift
//  myMood
//
//  Created by Martin Tsang on 2017-09-05.
//  Copyright © 2017 Hirad. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import MapKit

final class FirebaseDBController {
    var ref:DatabaseReference!
    
    //Shared instance
    static let shared = FirebaseDBController()
    
    init() {
        ref = Database.database().reference()
        
        //Sample code + Firebase Setup
        ref.child("Users").child("User_id").updateChildValues(["Name":"Sample",
                                                              "Email":"Sample",
                                                              "Password":"Sample",
                                                              "Entries":""
            ])
        //TODO - Each Entry Id needs some sort of detail e.g. title, date, some sort of string
        ref.child("Users").child("User_id").child("Entries").updateChildValues(["Entry_id":"Sample"])
        
        ref.child("Entries").child("Entry_id").updateChildValues(["Date":"Sample",
                                                                 "Description":"Sample",
                                                                 "PhotoURL":"Sample",
                                                                 "Location":"Sample",
                                                                 "Mood":"Sample"])
        
        
        //ref.child("Photos").child("Photo_1").updateChildValues(["url":"Sample"])
    }
    
    //TODO
    //GET all data for the user
    func getAllEntries() -> NSDictionary {
        let userID = Auth.auth().currentUser?.uid
        var dict:NSDictionary?
        ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapShot) in
            //Get user value
            dict =  (snapShot.value as! NSDictionary)
        }) { (error) in
            print(error.localizedDescription)
        }
        return dict!
    }
    
    //TODO  - Change to receive one entry model object
    //Insert Entry
    func insertEntry(entry:Entry) {
        let userId = Auth.auth().currentUser?.uid
        
        //Date
        let date:String = DateFormatter().string(from: entry.date)
        
        //TODO  Get Photo URL
        //Add current Photos
        
        
        //Change location to string
        var location:String
        if let loc = entry.location {
            location = "\(loc.coordinate.latitude),\(loc.coordinate.longitude)"
        } else {
            location = ""
        }
        
        //Auto generate entry id
        let newRef = ref.child("Entries").childByAutoId()
        
        newRef.setValue(["Date":date,
                         "Description":entry.description,
                         "PhotoURL":entry.photo!.photoURL,
                         "Location":location,
                         "Mood":entry.mood])
        
        //Set entryID on entry Object
        let entryID = newRef.key
        entry.ID = entryID
        
        //insert entry to list of entry in user
        //TODO - entryID:some sort of string to represent the entry to display
        ref.child("Users").child(userId!).child("Entries").updateChildValues([entryID:true])
        
    }
    
    //Update specific properties in entry
    func updateEventProperty(entry:Entry) {
        //TODO - get photo URL
        
        
        //Change location to string
        var location:String
        if let loc = entry.location {
            location = "\(loc.coordinate.latitude),\(loc.coordinate.longitude)"
        } else {
            location = ""
        }
        
        ref.child("Entries").child(entry.ID).updateChildValues(["Description":entry.description,
                                                                      "PhotoURL":entry.photo!.photoURL,
                                                                      "Location":location,
                                                                      "Mood":entry.mood])
    }
    
    //TODO
    //Delete Specific Entry
    func deleteEntry() {
        
    }
    
    //TODO
    //Insert Photo into Storage
    func insertPhoto(photo:Photo) {
        
    }
    
    //TODO
    //Delete specific photo
    func deletePhoto(entry:Entry){
        
    }
    
}
