//
//  HeaderView.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 08/10/24.
//

import UIKit

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
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            
            daysAgoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            daysAgoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        dateLabel.text = formatter.string(from: date)
        
        // Calculate days ago
        let daysAgo = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        
        if daysAgo == 0{
            daysAgoLabel.text = "Today"
        }
        else{
            daysAgoLabel.text = "\(daysAgo) Days Ago"
        }
        
    }
}
