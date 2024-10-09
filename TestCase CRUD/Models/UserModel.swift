//
//  userModel.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 07/10/24.
//

import Foundation
import Firebase

struct UserModel {
    var userId :String
    var email : String
    var firstName : String
    var lastName : String
    var tenantId : String
    var role: String
    var dateCreated: Timestamp
    var mobileNumber : String
    var photoURL : String
}

class UserModelManager {
    static let shared = UserModelManager()
    var userModel : UserModel?
    var imageItems : [ImageItem] = []{
        didSet{
            print("imageItems updated")
            self.downloadImages()
          
        }
    }
    var images: [String : UIImage] = [:]{
        didSet{
            NotificationCenter().post(Notification(name: Notification.Name("dataUpdated")))
        }
    }
    private init(){}
    
    private func downloadImages() {
        
        for imageItem in imageItems {
            if !images.keys.contains(imageItem.imageId) {
                if let url = URL(string: imageItem.imageUrl) {
                    url.loadImage {[weak self] image in
                        if let image{
                            DispatchQueue.main.async {
                                self?.images[imageItem.imageId] = image
                                print("image downloaded")
                            }
                        }
                    }
                }
            }
        }
    }
    
}
