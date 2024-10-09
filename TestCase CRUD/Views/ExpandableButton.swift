import UIKit

class ExpandableButton: UIView {
    private let mainButton = UIButton()
    private let actionButtons: [UIButton]
    
    private var isGalleryVC = false
    private var isExpanded = false
    private var actions: [(() -> Void)?]
    
    private let buttonSize: CGFloat = 50
    private let buttonSpacing: CGFloat = -3 // Remove spacing between buttons
    
    init(frame: CGRect, parentView: UIView, isGalleryVC: Bool = false, actions: [(() -> Void)?]) {
        self.actions = actions
        self.isGalleryVC = isGalleryVC
        self.actionButtons = (0..<4).map { _ in UIButton() }
        super.init(frame: frame)
        setupButtons()
        parentView.addSubview(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtons() {
        setupMainButton()
        
        let images = [(isGalleryVC ? "house" : "camera"), "trophy", "triangle.lefthalf.filled", "circle.circle"]
        for (index, button) in actionButtons.enumerated() {
            setupActionButton(button: button, image: UIImage(systemName: images[index]), index: index)
        }
        
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
    
    private func setupActionButton(button: UIButton, image: UIImage?, index: Int) {
        button.frame = bounds
        button.backgroundColor = UIColor.rgb(40, 34, 139)
        button.layer.cornerRadius = 3
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.alpha = 0
        
        button.tag = index
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        addSubview(button)
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        print("Button \(sender.tag) tapped")
        
        UIView.animate(withDuration: 0.1, animations: {
            sender.imageView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.imageView?.transform = .identity
            }
        }
        
        if let action = actions[sender.tag] {
            DispatchQueue.main.async {
                action()
            }
        } else {
            print("No action set for button \(sender.tag)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.toggleExpand()
        }
    }
    
    @objc private func toggleExpand() {
        isExpanded.toggle()
        print("Toggling expand. isExpanded: \(isExpanded)")
        
        if isExpanded {
            expand()
        } else {
            collapse()
        }
    }
    
    private func expand() {
        UIView.animate(withDuration: 0.3) {
            for (index, button) in self.actionButtons.enumerated() {
                let yOffset = -CGFloat(index + 1) * (self.buttonSize + self.buttonSpacing)
                button.frame = self.bounds.offsetBy(dx: 0, dy: yOffset)
                button.alpha = 1
            }
            self.mainButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        }
    }
    
    private func collapse() {
        UIView.animate(withDuration: 0.3) {
            for button in self.actionButtons {
                button.frame = self.bounds
                button.alpha = 0
            }
            self.mainButton.setImage(UIImage(systemName: "square.stack.3d.up"), for: .normal)
        }
    }
    
    private func toggleButtonVisibility(isHidden: Bool) {
        let alpha: CGFloat = isHidden ? 0 : 1
        for button in actionButtons {
            button.alpha = alpha
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if isExpanded {
            for button in actionButtons {
                if button.frame.contains(point) {
                    return true
                }
            }
        }
        return bounds.contains(point)
    }
}

//import UIKit
//
//class ExpandableButton: UIView {
//    private let mainButton = UIButton()
//    private let actionButtons: [UIButton]
//    
//    private var isExpanded = false
//    private var actions: [(() -> Void)?]
//    
//    init(frame: CGRect, parentView: UIView, actions: [(() -> Void)?]) {
//        self.actions = actions
//        self.actionButtons = (0..<4).map { _ in UIButton() }
//        super.init(frame: frame)
//        setupButtons()
//        parentView.addSubview(self)
//        
//        // Debug: Print the number of actions
//        print("Number of actions: \(actions.count)")
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupButtons() {
//        setupMainButton()
//        
//        let images = ["camera", "trophy", "triangle.lefthalf.filled", "circle.circle"]
//        for (index, button) in actionButtons.enumerated() {
//            setupActionButton(button: button, image: UIImage(systemName: images[index]), index: index)
//        }
//        
//        toggleButtonVisibility(isHidden: true)
//    }
//    
//    private func setupMainButton() {
//        mainButton.frame = bounds
//        mainButton.backgroundColor = UIColor.rgb(40, 34, 139)
//        mainButton.tintColor = .white
//        mainButton.layer.cornerRadius = 3
//        mainButton.setImage(UIImage(systemName: "square.stack.3d.up"), for: .normal)
//        mainButton.addTarget(self, action: #selector(toggleExpand), for: .touchUpInside)
//        mainButton.layer.shadowColor = UIColor.black.cgColor
//        mainButton.layer.shadowOpacity = 0.4
//        mainButton.layer.shadowOffset = .init(width: 2, height: -4)
//        mainButton.layer.shadowRadius = 4
//        addSubview(mainButton)
//        
//        // Debug: Print main button frame
//        print("Main button frame: \(mainButton.frame)")
//    }
//    
//    private func setupActionButton(button: UIButton, image: UIImage?, index: Int) {
//        button.frame = bounds
//        button.backgroundColor = UIColor.rgb(40, 34, 139)
//        button.layer.cornerRadius = 3
//        button.setImage(image, for: .normal)
//        button.tintColor = .white
//        button.alpha = 0
//        
//        button.tag = index
//        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
//        
//        addSubview(button)
//        
//        // Debug: Print action button setup
//        print("Action button \(index) setup. Frame: \(button.frame)")
//    }
//    
//    @objc private func buttonAction(_ sender: UIButton) {
//        print("Button \(sender.tag) tapped") // Debug: Print when a button is tapped
//        if let action = actions[sender.tag] {
//            action()
//        } else {
//            print("No action set for button \(sender.tag)") // Debug: Print if no action is set
//        }
//    }
//    
//    @objc private func toggleExpand() {
//        isExpanded.toggle()
//        print("Toggling expand. isExpanded: \(isExpanded)") // Debug: Print toggle state
//        
//        if isExpanded {
//            UIView.animate(withDuration: 0.3, animations: {
//                for (index, button) in self.actionButtons.enumerated() {
//                    button.transform = CGAffineTransform(translationX: 0, y: CGFloat(-48 * (index + 1)))
//                    print("Expanding button \(index). New frame: \(button.frame)") // Debug: Print new frame
//                }
//                
//                self.mainButton.layer.cornerRadius = 3
//                
//                self.toggleButtonVisibility(isHidden: false)
//                self.mainButton.setImage(UIImage(systemName: "xmark"), for: .normal)
//            })
//        } else {
//            UIView.animate(withDuration: 0.3, animations: {
//                for (index, button) in self.actionButtons.enumerated() {
//                    button.transform = .identity
//                    print("Collapsing button \(index). New frame: \(button.frame)") // Debug: Print new frame
//                }
//                
//                self.mainButton.layer.cornerRadius = 5
//                
//                self.toggleButtonVisibility(isHidden: true)
//                self.mainButton.setImage(UIImage(systemName: "square.stack.3d.up"), for: .normal)
//            })
//        }
//    }
//    
//    private func toggleButtonVisibility(isHidden: Bool) {
//        let alpha: CGFloat = isHidden ? 0 : 1
//        for (index, button) in actionButtons.enumerated() {
//            button.alpha = alpha
//            print("Toggling visibility for button \(index). Alpha: \(alpha)") // Debug: Print visibility change
//        }
//    }
//    
//    // Debug: Override hitTest to check if touch events are reaching the buttons
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let result = super.hitTest(point, with: event)
//        print("Hit test at point \(point). Result: \(result?.description ?? "nil")")
//        return result
//    }
//}
