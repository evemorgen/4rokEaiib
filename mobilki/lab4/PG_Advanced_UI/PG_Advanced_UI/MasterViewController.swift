//
//  MasterViewController.swift
//  PG_Advanced_UI
//
//  Created by Patryk Gałczyński on 31/10/2017.
//  Copyright © 2017 Patryk Gałczyński. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
}


class MasterViewController: UITableViewController {
    let persistentData = UserDefaults.standard
    var detailViewController: DetailViewController? = nil
    var anotherController: DetailViewController!
    
    //var objects = [Any]()
    var songs: [[String:Any]] = []
    var _currentTrackNumber: Int = 1;
    var numberOfTracks: Int = 0;
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AlbumCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! AlbumCell!
        cell.artistLabel.text = self.songs[indexPath.row]["artist"] as? String
        cell.titleLabel.text = self.songs[indexPath.row]["album"] as? String
        cell.yearLabel.text = String(describing: self.songs[indexPath.row]["year"]!)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let savedAlbums: [[String:Any]] = persistentData.object(forKey: "savedAlbums") as! [[String : Any]]
        
        tableView.delegate = self
        tableView.dataSource = self

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        let url = URL(string: "https://isebi.net/albums.php")
        let task = URLSession.shared.dataTask(with: url!) { data, resposnse, error in
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]]
            self.numberOfTracks = (json??.count)!
            self.songs = json!!
            if savedAlbums != nil {
                for album in savedAlbums {
                    let filtered = self.songs.filter { $0["album"] as! String == album["album"] as! String }
                    if filtered.count == 0 {
                        self.songs.append(album)
                    }
                }
                self.persistentData.set(self.songs, forKey: "savedAlbums")
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        if(anotherController != nil) {
            if(anotherController.albumHasChanged) ?? false {
                self.songs[(anotherController.trackNumber)] = anotherController.detailItem!
                self.tableView.reloadData()
                persistentData.set(self.songs, forKey: "savedAlbums")
            }
        }
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        songs.insert([
            "artist": "Artist name",
            "album":"Album name",
            "genre":"",
            "year": "year",
            "tracks": ""
        ], at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = songs[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                anotherController = controller
                controller.detailItem = object
                controller.trackNumber = indexPath.row
                controller.numberOfTracksInAlbum = self.songs.count
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

}

