//
//  DetailTableViewController.swift
//  PG_Advanced_UI
//
//  Created by Patryk Gałczyński on 31/10/2017.
//  Copyright © 2017 Patryk Gałczyński. All rights reserved.
//

import Foundation

import UIKit

class DetailTableViewController: UITableViewController {
    @IBOutlet weak var artistTextBox: UITextField!
    @IBOutlet weak var albumTextBox: UITextField!
    @IBOutlet weak var genereTextBox: UITextField!
    @IBOutlet weak var yearTextBox: UITextField!
    @IBOutlet weak var tracksTextBox: UITextField!
    
    var albumHasChanged: Bool = false
    
    var detailItem: [String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(detailItem)
        artistTextBox.text = detailItem["artist"] as? String
        albumTextBox.text = detailItem["album"] as? String
        genereTextBox.text = detailItem["genre"] as? String
        yearTextBox.text = String(describing: detailItem["year"]!)
        tracksTextBox.text = String(describing: detailItem["tracks"]!)
    }
    
    @IBAction func valueHasChanged(_ sender: Any) {
        albumHasChanged = true;
        detailItem["artist"] = artistTextBox.text
        detailItem["album"] = albumTextBox.text
        detailItem["genre"] = genereTextBox.text
        detailItem["year"] = yearTextBox.text
        detailItem["tracks"] = tracksTextBox.text
    }
}
