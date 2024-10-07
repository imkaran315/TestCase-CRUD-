//
//  FirebaseManager.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 07/10/24.
//

import FirebaseFirestore
import FirebaseAuth

class FirebaseManager{
    func getUserInfo(completion: @escaping (Bool, UserModel?) -> Void) {
            guard let userId = UserDefaults.standard.value(forKey: "userId") as? String else { return }
            
            let db = Firestore.firestore()
            let ref = db.collection("users").document(userId)
            
            ref.getDocument { doc, error in
                if let error {
                    print("Error while retrieving data : \(error.localizedDescription)")
                    completion(false, nil)
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
                                dateCreated: userInfo["dateCreated"] as? Int ?? 0,
                                mobileNumber: userInfo["mobileNumber"] as? String ?? "",
                                photoURL: userInfo["photoURL"] as? String ?? ""
                            )
                        completion(true, myModel)
                    }
                }
                else {
                    print("No doc found")
                    completion(false, nil)
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
