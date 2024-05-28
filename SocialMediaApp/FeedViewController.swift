//
//  FeedViewController.swift
//  SocialMediaApp
//
//  Created by iOS-Lab11 on 23.05.2024.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // email, yorum ve gorsel için boş bir dizi oluşturuldu. Tarih'e göre çekme işlemi yapılacağı için burada tarih için dizi oluşturulmadı
    
    var emailDizisi = [String]()
    var yorumDizisi = [String]()
    var gorselDizisi = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseVerileriAl()
    }
    
    // viewDidLoad veya başka bir fonksiyonda sonradan kullanabilmek için fonksiyon yaşam döngüsünün altında oluşturuldu
    func firebaseVerileriAl(){
        let firestoreDatabesa = Firestore.firestore()
        //collectiona ulaşma burada isimlerin aynı olması önemlidir
        //whereField ile filtreleme yapılabilir
        //order ile neye göre dizileceğine karar verilebilir
        firestoreDatabesa.collection("Post").order(by: "tarih", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                //snapshot boş ve nil değil ise
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    // uygulama upload edildiğinde feed sayfasındaki görsellerin ve bilgilerin tekrar yüklenmemesi için keepingCapacity:false olmalı
                    self.emailDizisi.removeAll(keepingCapacity: false)
                    self.yorumDizisi.removeAll(keepingCapacity: false)
                    self.gorselDizisi.removeAll(keepingCapacity: false)
                    
                    //firebase'de Post altında bulunan bütün dokümanların gelmesi
                    
                    for document in snapshot!.documents{
                        /* documentler sözlük gibidir. id şuan lazım değil fakat eğer almak istersek aşağıdaki şekilde alınabilir
                        let documentId = document.documentID
                        print("ID: ", documentId) */
                        
                        // başta bu değerleri [String: Any] olarak ayarladığımız için şu an Any olarak gelmekte bu yüzden Stringe cast edildi
                        if let gorselUrl = document.get("gorselUrl") as? String{
                            
                            //gorsel dizisine ekleme işlemi
                            self.gorselDizisi.append(gorselUrl)
                        }
                        
                        if let yorum = document.get("yorum") as? String {
                            self.yorumDizisi.append(yorum)
                        }
                        
                        if let email = document.get("email") as? String {
                            self.emailDizisi.append(email)
                        }
                    }
                    // yeni verinin gelmesi ve burada görüntülenmesi için
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailDizisi.count
    }
    
    // FeedTableViewCell sınıfına cest edildi
    // cell ile FeedTableView sınıfında bulunan özellikleri erişilebilirx
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        cell.emailText.text = emailDizisi[indexPath.row]
        cell.yorumText.text = yorumDizisi[indexPath.row]
        // assetteki fotoğrafı almak için aşağıdaki kod kullanılır biz veri tabanından fotoğraf alacağımız için sd_setImage fonksiyonunu kullanıyoruz
        // cell.postImageView.image = UIImage(named: "share-icon")
        cell.postImageView.sd_setImage(with: URL(string: self.gorselDizisi[indexPath.row]))
        return cell
       
    }


}
