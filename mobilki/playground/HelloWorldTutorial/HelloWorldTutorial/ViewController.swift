//
//  ViewController.swift
//  HelloWorldTutorial
//
//  Created by Patryk Gałczyński on 22/10/2017.
//  Copyright © 2017 Patryk Gałczyński. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func showMessage(sender: UIButton) {
        let alertController = UIAlertController(title: "Hello world message", message: "Hello darkness my old friend", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

