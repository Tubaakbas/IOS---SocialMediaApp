//
//  ViewController.swift
//  SocialMediaApp
//
//  Created by iOS-Lab11 on 22.05.2024.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewConroller: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sifreTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func girisYapTiklandi(_ sender: Any) {
        if emailTextField.text != "" && sifreTextField.text != ""{
            Auth.auth().signIn(withEmail: emailTextField.text!, password: sifreTextField.text!) { authdataresult, error in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata!", messageInput: error!.localizedDescription)
                } else{
                    //Herhangi bir hata yoksa Feed sayfasına git
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            self.hataMesaji(titleInput: "Hata!", messageInput: "E-Mail ve Parola Giriniz")
        }
      
    }
    
    @IBAction func kayitOlTiklandi(_ sender: Any) {
        
      // e-mail ve şifre boş değilse kayıt olma işlemi yapılabilir
        if emailTextField.text != "" && sifreTextField.text != "" {
            //Firebase için authentication'ını yöneten sınıf: Auth
            //Auth sınıfının nesnesi auth()
            //completion: bu işlem tamamlanınca ne yapılacağını verir. Kullanıcı oluşturulamadığında Firebase üzerinden bir hata mesajı gelir.
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!) { authdataresult, error in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata!", messageInput: error!.localizedDescription)
                }else{
                    //hata yoksa
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            hataMesaji(titleInput: "Hata!", messageInput: "E-Mail ve Parola Giriniz")
        }
    }
    //kullanıcı hangi başlıkta ve mesajda hata mesajı oluşturmak istiyor
    func hataMesaji(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        //handler: tıklanınca ne olacağını gösterir
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        //self burada SignInVC'a referans verir
        self.present(alert, animated: true, completion: nil)
    }
}

