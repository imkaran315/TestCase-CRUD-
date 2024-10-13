//
//  GalleryViewController.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 08/10/24.
//



import UIKit
import FirebaseCore

class GalleryVC: UIViewController{

    @IBOutlet weak var headingView: UIView!
    
    var collectionView: UICollectionView!
     // To hold the sections data
    
    
    var imageSections: [(date: Timestamp, images: [ImageItem])] = []{
        didSet{
            print("Sections didSet")
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        convertToSections()
        
        collectionView.center.x = view.frame.width
        headingView.center.x = view.frame.width
        
        NotificationCenter().addObserver(self, selector: #selector(refresh), name: Notification.Name("dataUpdated"), object: nil)
    }
    
//    @IBAction func plusBtnPressd(_ sender: Any) {
//        handleAddImage()
//    }
    
    @objc func refresh(){
        print("refresh data")
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animate the collection view to its final position
        UIView.animate(withDuration: 0.6) {
            self.collectionView.frame.origin.x = 30
            self.headingView.frame.origin.x = 30
        }
    }
}

// MARK: - Helper Methods
extension GalleryVC {
    
    private func setupView(){
        let buttonFrame = CGRect(x: view.frame.width - 80, y: view.frame.height - 100, width: 51, height: 51)
        let _ = ExpandableButton(frame: buttonFrame, parentView: self.view, isGalleryVC: true, actions: [
            {self.navigationController?.popViewController(animated: true)},
        ])
        
    }
    
//    private func handleAddImage(){
//        PHPickerManager.shared.presentPicker(from: self) {[weak self] image in
//            if let image{
////                DispatchQueue.main.async{
////                    letimage
////                    UserModelManager.shared.imageItems.append(Im)
////                }
//                print("Added ui image")
//                self?.uploadImage(image: image)
//            }
//        }
//    }
    
//    private func uploadImage(image: UIImage){
//        FirebaseManager().uploadImage(image) {[weak self] url in
//            if let url{
//                self?.addImageInfoToFirestore(with: url)
//            }else{
//                print("couldn't get url")
//            }
//        }
//    }
    
//    private func convertToSections() {
//        // Step 1: Group ImageItems by dateCreated (ignoring time)
//        var groupedItems = [Timestamp: [ImageItem]]()
//        
//        let imageItems = UserModelManager.shared.imageItems
//        print("items in imageItems = \(imageItems.count)")
//        
//        for item in imageItems {
//            // Extract the date part of Timestamp and store as Timestamp (ignoring time)
//            let dateCreated = item.dateCreated
//            let calendar = Calendar.current
//            let dateComponents = calendar.dateComponents([.year, .month, .day], from: dateCreated.dateValue())
//            if let dateOnly = calendar.date(from: dateComponents) {
//                let dateOnlyTimestamp = Timestamp(date: dateOnly)
//
//                if groupedItems[dateOnlyTimestamp] == nil {
//                    groupedItems[dateOnlyTimestamp] = []
//                }
//                groupedItems[dateOnlyTimestamp]?.append(item)
//            }
//        }
//
//        // Step 2: Initialize an empty array for new sections
//        var newSections: [(date: Timestamp, images: [ImageItem])] = []
//        
//        // Step 3: Loop through each grouped date and split items into sections (max 4 per section)
//        for (dateOnlyTimestamp, items) in groupedItems {
//            var remainingItems = items
//            while !remainingItems.isEmpty {
//                // Take up to 4 items to create a section
//                let sectionItems = Array(remainingItems.prefix(4))
//                newSections.append((date: dateOnlyTimestamp, images: sectionItems))
//                
//                // Remove the first 4 items from the remaining items
//                remainingItems = Array(remainingItems.dropFirst(4))
//            }
//        }
//        // Step 4: Sort sections by Timestamp in reverse chronological order
//        newSections.sort { $0.date.seconds > $1.date.seconds }
//
//        // Step 5: Update the imageSections with the newly created sections
//        imageSections = newSections
//    }
    
    private func convertToSections(){
        var sections: [String: (date: Timestamp, images: [ImageItem])] = [:]
        
        let imageItems = UserModelManager.shared.imageItems
        
           for item in imageItems {
               if var section = sections[item.sessionId] {
                   section.images.append(item)
                   if item.dateCreated.dateValue() < section.date.dateValue() {
                       section.date = item.dateCreated
                   }
                   sections[item.sessionId] = section
               } else {
                   sections[item.sessionId] = (date: item.dateCreated, images: [item])
               }
           }
           
           // Sort images in each section and sort sections
        imageSections =  sections.values.map { (date: $0.date, images: $0.images.sorted { $0.dateCreated.dateValue() < $1.dateCreated.dateValue() }) }
            .sorted { $0.date.dateValue() < $1.date.dateValue() }
    }
    
    private func addImageInfoToFirestore(with url: String){
        print("add image info in firestore")
        DispatchQueue.global().async {
            FirebaseManager().storeImageInfoInFirestore(imageURL: url) { status in}
        }
    }
    
    private func getData(){
        FirebaseManager().retrieveImagesFromStorage {[weak self] status in
            self?.convertToSections()
        }
    }
}

// MARK: - Collection View methods
extension GalleryVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        // Set up the collection view
        
        let frame = CGRect(x: 30, y: 178, width: view.frame.width * 0.6, height: view.frame.height - 178)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.rgb(237, 237, 237)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        
        // Register cell and header
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")

        view.addSubview(collectionView)
    }
    
    // Number of Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return imageSections.count
    }

    // Number of items per section (2x2 grid, so max 4 items)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSections[section].images.count // Ensure a max of 4 items
    }

    // Cell configuration
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let imageItem = imageSections[indexPath.section].images[indexPath.row]
        
        // Configure the cell
        cell.configure(with: imageItem)
        return cell
    }

    // Section header configuration
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
            let section = imageSections[indexPath.section]
            header.configure(with: section.date)
            return header
        }
        return UICollectionReusableView()
    }

    // Set size for cells (2x2 grid)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 30
        let availableWidth = collectionView.frame.width - padding
        let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    // Set height for section headers
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
}


