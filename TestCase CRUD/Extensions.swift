//
//  Extensions.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 06/10/24.
//
import UIKit
import Foundation
import Firebase

extension UIColor{
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> UIColor{
        return UIColor(red: red/256, green: green/256, blue: blue/256, alpha: alpha)
    }
}


extension Dictionary {
    func toUserModel()-> UserModel?{
        if let userInfo = self as? [String: Any]{
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
            return myModel
        }
        return nil
    }
}

extension URL {
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: self) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
