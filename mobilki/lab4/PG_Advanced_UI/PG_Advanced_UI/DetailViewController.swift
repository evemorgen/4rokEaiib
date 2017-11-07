//
//  DetailViewController.swift
//  PG_Advanced_UI
//
//  Created by Patryk Gałczyński on 31/10/2017.
//  Copyright © 2017 Patryk Gałczyński. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    //UI elements bindings
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    
    var tableDetailController: DetailTableViewController!
    var albumHasChanged: Bool = false

    //variables
    var numberOfTracksInAlbum: Int = 0 {
        didSet {
            configureView()
        }
    }
    var trackNumber: Int = 0 {
        didSet {
            configureView()
        }
    }
    
    var detailItem: [String: Any]? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        self.navBar.title = "Record \(trackNumber+1) out of \(numberOfTracksInAlbum)"
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.title = "Record \(trackNumber) out of \(numberOfTracksInAlbum)"
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showTable") {
            tableDetailController = segue.destination as! DetailTableViewController
            if(detailItem != nil) {
                tableDetailController.detailItem = detailItem!
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        albumHasChanged = tableDetailController.albumHasChanged
        detailItem = tableDetailController.detailItem
    }
}

