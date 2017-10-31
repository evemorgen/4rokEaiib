//
//  ViewController.swift
//  PG_CD_Browser
//
//  Created by Patryk Gałczyński on 22/10/2017.
//  Copyright © 2017 Patryk Gałczyński. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Top
    @IBOutlet weak var trackNumberLabel: UILabel!
    
    //Middle
    @IBOutlet weak var titleTextBox: UITextField!
    @IBOutlet weak var artistTextBox: UITextField!
    
    @IBOutlet weak var genereTextBox: UITextField!
    @IBOutlet weak var yearTextBox: UITextField!
    @IBOutlet weak var nobTextBox: UITextField!
    //Down buttons
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var newRecordButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    //Variables
    var songs: [[String:Any]] = []
    var _currentTrackNumber: Int = 1;
    var numberOfTracks: Int = 0;
    var currentTrackNumber: Int {
        get {
            return _currentTrackNumber
        }
        set(newTrackNumber) {
            if(newTrackNumber == 1) {
                self.previousButton.isEnabled = false
                self.nextButton.isEnabled = true
            } else if (newTrackNumber == numberOfTracks){
                self.previousButton.isEnabled = true
                self.nextButton.isEnabled = true
            } else {
                self.previousButton.isEnabled = true
                self.nextButton.isEnabled = true
            }
            _currentTrackNumber = newTrackNumber
            updateTrackLabel()
        }
        
    };
    
    func updateTrackLabel() {
        self.trackNumberLabel.text = "\(self.currentTrackNumber) out of \(self.numberOfTracks)"
    }
    
    func updateSongFields(number: Int) {
        titleTextBox.text = songs[number-1]["album"] as! String
        artistTextBox.text = songs[number-1]["artist"] as! String
        genereTextBox.text = songs[number-1]["genre"] as! String
        yearTextBox.text = String(describing: songs[number-1]["year"]!)
        nobTextBox.text = String(describing: songs[number-1]["tracks"]!)
    }
    
    @IBAction func nextTrack(sender: UIButton) {
        currentTrackNumber = currentTrackNumber + 1
        if(currentTrackNumber > numberOfTracks) {
            newRecord(sender: UIButton())
        } else {
            updateSongFields(number: currentTrackNumber)
        }
    }
    
    @IBAction func previousTrack(sender: UIButton) {
        currentTrackNumber = currentTrackNumber - 1
        updateSongFields(number: currentTrackNumber)
    }
    
    @IBAction func deleteRecord(sender: UIButton) {
        self.songs.remove(at: currentTrackNumber-1)
        currentTrackNumber = 1
        numberOfTracks -= 1
        updateTrackLabel()
        updateSongFields(number: currentTrackNumber)
    }
    
    @IBAction func newRecord(sender: UIButton) {
        titleTextBox.text = ""
        artistTextBox.text = ""
        genereTextBox.text = ""
        yearTextBox.text = ""
        nobTextBox.text = ""
        currentTrackNumber = numberOfTracks + 1
        saveButton.isEnabled = true
        updateTrackLabel()
    }
    
    @IBAction func saveRecord(sender: UIButton) {
        let toSave = [
            "artist": artistTextBox.text ?? "",
            "album": titleTextBox.text ?? "",
            "tracks": Int(nobTextBox.text!) ?? 0,
            "year": Int(yearTextBox.text!) ?? 1970,
            "genre": genereTextBox.text ?? ""
            ] as [String : Any]
        if(currentTrackNumber > numberOfTracks) {
            self.songs.append(toSave)
            numberOfTracks += 1
        } else {
            self.songs[currentTrackNumber-1] = toSave
        }
        saveButton.isEnabled = false
        updateTrackLabel();
        updateSongFields(number: currentTrackNumber)
    }
    
    @IBAction func textChainged(sender: UITextField) {
        saveButton.isEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveButton.isEnabled = false
        currentTrackNumber = 1;
        let url = URL(string: "https://isebi.net/albums.php")
        let task = URLSession.shared.dataTask(with: url!) { data, resposnse, error in
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]]
            self.numberOfTracks = (json??.count)!
            self.songs = json!!
            DispatchQueue.main.async {
                self.updateTrackLabel()
                self.updateSongFields(number: 1)
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

