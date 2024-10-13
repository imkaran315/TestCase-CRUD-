//
//  HeaderView.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 08/10/24.
//

import UIKit
import FirebaseCore

class HeaderView: UICollectionReusableView {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    let daysAgoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(dateLabel)
        addSubview(daysAgoLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        daysAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            daysAgoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            daysAgoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with date: Timestamp) {
        dateLabel.text = date.dateValue().formatted(date: .abbreviated, time: .omitted)
        
        // Calculate days ago

        guard let daysAgo = Calendar.current.dateComponents([.dayOfYear], from: date.dateValue(), to: .now).dayOfYear else {return}
        
        if daysAgo == 0{
            daysAgoLabel.text = "Today"
        }
        else{
            daysAgoLabel.text = "\(daysAgo) Days Ago"
        }
        
    }
}
