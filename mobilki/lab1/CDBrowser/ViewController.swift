//
//  ViewController.swift
//  CDBrowser
//
//  Created by Użytkownik Gość on 10.10.2017.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let delegate = UIApplication.shared.delegate as! AppDelegate
    var albums: [AnyObject] = []

    //pasted from https://stackoverflow.com/questions/41163026/how-to-convert-json-string-into-array-of-dictionaries-in-ios-swift-3
    func convertToDictionary(text: String) -> Any? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Any
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "https://isebi.net/albums.php")
        if url != nil {
            let task = URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    
                    let urlContent = NSString(data: data!, encoding: String.Encoding.ascii.rawValue) as NSString!
                    if let contentDict = self.convertToDictionary(text: urlContent as! String ) as? [AnyObject] {
                        print(contentDict as Any)
                        self.albums = contentDict
                    }
                    
                }
            })
            task.resume()
        }

        print(albums)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

