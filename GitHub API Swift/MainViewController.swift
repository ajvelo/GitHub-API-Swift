//
//  MainViewController.swift
//  GitHub API Swift
//
//  Created by Andreas Velounias on 02/10/2018.
//  Copyright © 2018 Andreas Velounias. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DataSet().getData(completionHandler: {array in
            let destVC = self.storyboard?.instantiateViewController(withIdentifier: "swiping") as? SwipingController
            destVC?.pageArray = array
            self.present(destVC!, animated: true, completion: nil)
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
