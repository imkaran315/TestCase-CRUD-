//
//  PHPickerManager.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 08/10/24.
//


import PhotosUI
import UIKit

class PHPickerManager: NSObject, PHPickerViewControllerDelegate {
    
    // Completion handler to return the picked image
    private var completion: ((UIImage?) -> Void)?
    
    // Singleton instance for easy access
    static let shared = PHPickerManager()
    
    private override init() {}
    
    // Function to present the image picker
    func presentPicker(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1 // To select only 1 image
        configuration.filter = .images // Only images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        // Present the picker from the given view controller
        viewController.present(picker, animated: true, completion: nil)
    }
    
    // PHPicker Delegate Method
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let result = results.first else {
            completion?(nil) // If no image is selected, return nil
            return
        }
        
        // Load the picked image
        result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                    self.completion?(nil)
                } else if let image = image as? UIImage {
                    self.completion?(image)
                } else {
                    self.completion?(nil)
                }
            }
        }
    }
}
