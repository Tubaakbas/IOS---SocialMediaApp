//
//  UploadViewController.swift
//  SocialMediaApp
//
//  Created by iOS-Lab11 on 23.05.2024.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var yorumTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //imageview'e tıklayarak işlem yapmak
        imageView.isUserInteractionEnabled = true
        // UITapGestureRecognizer oluşturma
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        //olusturulan gestureRecognizer imageView'a eklenir
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func gorselSec(){
        // gorsel secmek icin VC'dan UIImagePickerControllerDelegate ve UINavigationControllerDelegate eklenir
        // bir resim seçmek için bir kullanıcı arabirimi olusturulur ve
        // bu resmi seçtikten sonra ne yapılacağını belirlemek için bir delegasyon yöntemi çağrılır
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        //fotoğrafın nereden alınacağı
        pickerController.sourceType = .photoLibrary
        // kütüphaneden alınan fotoğrafı ekran üzerinde görünür hale getirmek için
        present(pickerController, animated: true, completion: nil)
        
    }
    //Kütüphaneden fotoğraf alındıktan sonra ne yapılacak?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //fotoğraf galireden alındıktan sonra değiştirilebiler
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func paylasTiklandi(_ sender: Any) {
        // Gorsel seçildikten sonra depoya yüklenmelidir.
        // yorum yapılacak,
        // kim postu paylaştı,
        // post tarihi gibi bilgiler firebase storage da tutulur.
        
        let storage = Storage.storage()
        //referanslar şu an da ana yere referans veriyor
        let storageReference = storage.reference()
        
        //ana lokasyonun altına bir medya klasoru acma
        let mediaFolder = storageReference.child("media")
        //imageView'i byte çevirme
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            
            //alinan veriyi medyaya ekleme
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { storagemetadata, error in
            if error != nil
                {
                    self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz!")
                } else {
                    //kaydetme urlsini alma
                    imageReference.downloadURL{ [self](url, error) in
                        if error == nil{
                            //url'nin string'e çevrilmiş halini verir
                            let imageUrl = url?.absoluteString
                            // Eğer yükleme yapılabilirse yükleme yapılacak yerin adresi url'si verilcektir.
                            // print("URL= ", imageUrl)
                            
                            
                            //imageUrl değeri string opsiyonel olduğu için if let yapıldı
                            if let imageUrl = imageUrl {
                                
                                // Auth.auth() veya Storage.storage() yaptığımız gibi Firestore.firestore() yapıldı
                                // Bu API çağrısı, Firestore veritabanına erişim sağlar ve veri okuma, yazma ve sorgulama işlemlerini gerçekleştirir
                                let firestoreDatabase = Firestore.firestore()
                                var fireStoreReference : DocumentReference? = nil
                                       
                                // field-value yapısı ile verileri sözlük içerisinde tutma
                                let firestorePost = [ "gorselUrl": imageUrl,
                                                      "yorum": self.yorumTextField.text!,
                                                      "email": Auth.auth().currentUser!.email,
                                                      "tarih": FieldValue.serverTimestamp()]as [String:Any]
                                       
                                // koleksiyon oluşturduktan sonra .addDocument diyerek ekleme yapılabilir
                                fireStoreReference = firestoreDatabase.collection("Post").addDocument(data: firestorePost) { error in
                                    if error != nil {
                                        // eğer hata mesajı varsa kullanıcıya hatayı gösterme
                                        self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz!")
                                    } else {

                                        // kaydetme işleminden sonra yorum kutusunu boşaltıyoruz
                                        self.yorumTextField.text = " "
                                        //imageview'ı da eski haline getiriyoruz
                                        self.imageView.image = UIImage(named: "share-icon")
                                        // seçilmiş indeksi değiştirmek için tabBarController kullanılır
                                        // şu anda upload tabBarda yani 1'de bunu 0 yaparak feed tabBarına alıyoruz
                                        self.tabBarController?.selectedIndex = 0
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func hataMesaji(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        //handler: tıklanınca ne olacağını gösterir
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        //self burada SignInVC'a referans verir
        self.present(alert, animated: true, completion: nil)
    }
    
}
