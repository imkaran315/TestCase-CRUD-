//
//  FirebaseManager.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 07/10/24.
//
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class FirebaseManager{
    func getUserInfo(completion: @escaping (Bool) -> Void) {
            guard let userId = UserDefaults.standard.value(forKey: "userId") as? String else { return }
            
            let db = Firestore.firestore()
            let ref = db.collection("users").document(userId)
            
            ref.getDocument { doc, error in
                if let error {
                    print("Error while retrieving data : \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                if let document = doc, document.exists {
                    print("Doc retrieved:")
                    if let userInfo = document.data(){
                        let myModel = UserModel(
                                userId: userInfo["userId"] as? String ?? "",
                                email: userInfo["email"] as? String ?? "",
                                firstName: userInfo["firstName"] as? String ?? "",
                                lastName: userInfo["lastName"] as? String ?? "",
                                tenantId: userInfo["tenantId"] as? String ?? "",
                                role: userInfo["role"] as? String ?? "",
                                dateCreated: userInfo["dateCreated"] as? Timestamp ?? Timestamp(),
                                mobileNumber: userInfo["mobileNumber"] as? String ?? "",
                                photoURL: userInfo["photoURL"] as? String ?? ""
                            )
                        UserModelManager.shared.userModel = myModel
                        completion(true)
                    }
                }
                else {
                    print("No doc found")
                    completion(false)
                }
            }
        }
    
    func updateUserData(_ firstName: String? = nil, _ lastName: String? = nil, _ mobileNumber : String? = nil,_ photoURL: String? = nil, completion: @escaping (Bool)->Void){
        
        var userInfo = [String: Any]()
        if let firstName{
            userInfo["firstName"] = firstName
        }
        if let lastName{
            userInfo["lastName"] = lastName
        }
        if let mobileNumber{
            userInfo["mobileNumber"] = mobileNumber
        }
        if let photoURL{
            userInfo["photoURL"] = photoURL
        }
        
        let db = Firestore.firestore()
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? String else { return }
        let docRef = db.collection("users").document(userId)
        
        docRef.updateData(userInfo) { error in
            if error != nil{
                print("Could not update data")
                completion(false)
            }else{
                print("updated data")
                completion(true)
            }
        }
    }
    
    func deleteUser(completion : @escaping (Bool) -> Void){
        
        let userId = Auth.auth().currentUser?.uid ?? ""
        let db = Firestore.firestore()
        
        let documentReference = db.collection("users").document(userId)
        documentReference.delete { error in
            if error != nil{
                completion(false)
            }else{
                Auth.auth().currentUser?.delete(completion: { error in
                    if error != nil{
                        completion(false)
                    }
                    else{
                        completion(true)
                    }
                })
            }
        }
        
    }
}

// MARK: - Methods for Images
extension FirebaseManager {
    func uploadImage(_ image : UIImage, completion: @escaping (String?) -> Void){
        let storage = Storage.storage().reference()
        let ref = storage.child("images/\(UUID().uuidString)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}
        
        ref.putData(imageData) { meta, error in
            if let error{
                print("Error in uploading image", error.localizedDescription)
                completion(nil)
            }
            else{
                
                ref.downloadURL { url, error in
                    if let error{
                        print("Error in getting url", error.localizedDescription)
                        completion(nil)
                    }else{
                        completion(url?.absoluteString)
                    }
                }
            }
        }
    }
    
    
    func storeImageInfoInFirestore(imageURL: String, completion: @escaping (Bool) -> Void) {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? String else { return }
        guard let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String else { return }
        
        let db = Firestore.firestore()
        let documentId = UUID().uuidString
        
        // Data to be saved in Firestore
        let imageData: [String: Any] = [
            "imageURL": imageURL,
            "userId": userId,
            "dateCreated": Timestamp(),
            "tenantId" : "TESLA",
            "sessionId" : sessionId,
            "imageId" : UUID().uuidString
        ]
        
        db.collection("images").document(documentId).setData(imageData) { error in
            if let error = error {
                print("Error storing image info: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Image info saved successfully")
                self.retrieveImagesFromStorage { _ in}
                completion(true)
            }
        }
    }
    
    func retrieveImagesFromStorage(completion: @escaping (Bool) ->Void){
        // temp array to hold images items
        var imageItems = [ImageItem]()
        
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            print("User ID not found")
            return
        }
        
        let db = Firestore.firestore()
        let imagesCollection = db.collection("images")
        
        imagesCollection.whereField("userId", isEqualTo: userId).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
                return
            }
            
            for document in querySnapshot!.documents {
                let data = document.data()
                
                if let url = data["imageURL"] as? String,
                    let createdDate = data["dateCreated"] as? Timestamp,
                    let imageId = data["imageId"] as? String,
                    let sessionId = data["sessionId"] as? String{
                        let item = ImageItem(imageId: imageId,
                                             imageUrl: url,
                                             dateCreated: createdDate,
                                             sessionId: sessionId)
                        imageItems.append(item)
                }
            }
            
            DispatchQueue.main.async {
                UserModelManager.shared.imageItems = imageItems
            }
            completion(true)
        }
    }
}
