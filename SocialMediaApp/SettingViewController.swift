//
//  SettingViewController.swift
//  SocialMediaApp
//
//  Created by iOS-Lab11 on 23.05.2024.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cikisYapTiklandi(_ sender: Any) {
        
        //burada signOut fonksiyon do try catch bloğunda kullanılmalıdır hata olabilir örneğin kullanıcı olmayabilir.
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toVC", sender: nil)
        } catch {
            print("hata")
        }
        
      
    }
    

}
