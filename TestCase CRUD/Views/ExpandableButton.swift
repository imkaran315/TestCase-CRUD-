import UIKit

class ExpandableButton: UIView {
    private let mainButton = UIButton()
    private let button1 = UIButton()
    private let button2 = UIButton()
    private let button3 = UIButton()
    private let button4 = UIButton()
    
    private var isExpanded = false
    
    init(frame: CGRect, parentView: UIView) {
        super.init(frame: frame)
        setupButtons()
        parentView.addSubview(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtons() {
        setupMainButton()
        setupActionButton(button: button1, image: UIImage(systemName: "camera"))
        setupActionButton(button: button2, image: UIImage(systemName: "trophy"))
        setupActionButton(button: button3, image: UIImage(systemName: "triangle.lefthalf.filled"))
        setupActionButton(button: button4, image: UIImage(systemName: "circle.circle"))
        
        toggleButtonVisibility(isHidden: true)
    }
    
    private func setupMainButton() {
        mainButton.frame = bounds
        mainButton.backgroundColor = UIColor.rgb(40, 34, 139)
        mainButton.tintColor = .white
        mainButton.layer.cornerRadius = 3
        mainButton.setImage(UIImage(systemName: "square.stack.3d.up"), for: .normal)
        mainButton.addTarget(self, action: #selector(toggleExpand), for: .touchUpInside)
        mainButton.layer.shadowColor = UIColor.black.cgColor
        mainButton.layer.shadowOpacity = 0.4
        mainButton.layer.shadowOffset = .init(width: 2, height: -4)
        mainButton.layer.shadowRadius = 4
        addSubview(mainButton)
    }
    
    private func setupActionButton(button: UIButton, image: UIImage?) {
        button.frame = bounds
        button.backgroundColor = UIColor.rgb(40, 34, 139)
        button.layer.cornerRadius = 3
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.alpha = 0
        addSubview(button)
    }
    
    @objc private func toggleExpand() {
        isExpanded.toggle()
        
        if isExpanded {
            UIView.animate(withDuration: 0.3, animations: {
                self.button1.transform = CGAffineTransform(translationX: 0, y: -48)
                self.button2.transform = CGAffineTransform(translationX: 0, y: -96)
                self.button3.transform = CGAffineTransform(translationX: 0, y: -144)
                self.button4.transform = CGAffineTransform(translationX: 0, y: -192)
                
                self.mainButton.layer.cornerRadius = 3
                
                self.toggleButtonVisibility(isHidden: false)
                self.mainButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.button1.transform = .identity
                self.button2.transform = .identity
                self.button3.transform = .identity
                self.button4.transform = .identity
                
                self.mainButton.layer.cornerRadius = 5
                
                self.toggleButtonVisibility(isHidden: true)
                self.mainButton.setImage(UIImage(systemName: "square.stack.3d.up"), for: .normal)
            })
        }
    }
    
    private func toggleButtonVisibility(isHidden: Bool) {
        let alpha: CGFloat = isHidden ? 0 : 1
        self.button1.alpha = alpha
        self.button2.alpha = alpha
        self.button3.alpha = alpha
        self.button4.alpha = alpha
    }
}

