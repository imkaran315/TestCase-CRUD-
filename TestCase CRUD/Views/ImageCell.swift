//
//  ImageCell.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 08/10/24.
//

import UIKit


class ImageCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
   
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: ImageItem) {
        
        if UserModelManager.shared.images.keys.contains(item.imageId){
            DispatchQueue.main.async {
                self.imageView.image = UserModelManager.shared.images[item.imageId]
            }
        }
        else{
            if let url = URL(string: item.imageUrl){
                url.loadImage {[weak self] image in
                    self?.imageView.image = image
                }
            }
        }
    }
}
