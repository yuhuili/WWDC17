import UIKit

class SPMenuViewController: UIViewController, UIGestureRecognizerDelegate {
    private var backboardView: UIImageView?
    private var backboardStackView: UIStackView?
    private var questionButton: UIButton?
    private var suggestionButton: UIButton?
    private var authorButton: UIButton?
    public weak var mainViewController: SPViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        setupGestureRecognizer()
        setupBackboard()
    }
    
    @objc private func handleQuestionButtonTap() {
        mainViewController?.openQuestions()
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleBackgroundTap(_ gestureRecognizer: UITapGestureRecognizer) {
        mainViewController?.dismissChildVC()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: view)
        if backboardView?.frame.contains(point) == false {
            handleBackgroundTap(gestureRecognizer as! UITapGestureRecognizer)
            return true
        }
        return false
    }
    
    private func setupBackboard() {
        backboardView = UIImageView(image: UIImage(named: "backboard_shadow"))
        if let backboardView = backboardView {
            backboardView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(backboardView)
            
            let horizontalConstraint = NSLayoutConstraint(item: backboardView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: backboardView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            
            let views = ["view": view, "backboardView": backboardView]
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[backboardView]-(20)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            
            let heightConstraint = NSLayoutConstraint(item: backboardView, attribute: .height, relatedBy: .equal, toItem: backboardView, attribute: .width, multiplier: 240.0/1040.0, constant: 0)
            
            view.addConstraints(horizontalConstraints)
            
            view.addConstraints([heightConstraint, horizontalConstraint, verticalConstraint])
        }
        
        questionButton = UIButton()
        questionButton?.translatesAutoresizingMaskIntoConstraints = false
        questionButton?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        questionButton?.setImage(UIImage(named: "button_help"), for: .normal)
        questionButton?.addTarget(self, action: #selector(handleQuestionButtonTap), for: .touchUpInside)
        
        suggestionButton = UIButton()
        suggestionButton?.translatesAutoresizingMaskIntoConstraints = false
        suggestionButton?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        suggestionButton?.setImage(UIImage(named: "button_task"), for: .normal)
        
        authorButton = UIButton()
        authorButton?.translatesAutoresizingMaskIntoConstraints = false
        authorButton?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        authorButton?.setImage(UIImage(named: "button_human"), for: .normal)
        
        if let questionButton = questionButton, let suggestionButton = suggestionButton, let authorButton = authorButton {
            backboardStackView = UIStackView(arrangedSubviews: [questionButton, suggestionButton, authorButton])
            if let backboardView = backboardView, let backboardStackView = backboardStackView {
                
                let subviews = ["view": view, "questionButton": questionButton, "suggestionButton": suggestionButton, "authorButton": authorButton]
                let vq = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[questionButton]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: subviews)
                let vs = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[suggestionButton]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: subviews)
                let va = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[authorButton]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: subviews)
                let qheight = NSLayoutConstraint(item: questionButton, attribute: .height, relatedBy: .equal, toItem: questionButton, attribute: .width, multiplier: 1, constant: 0)
                let sheight = NSLayoutConstraint(item: suggestionButton, attribute: .height, relatedBy: .equal, toItem: suggestionButton, attribute: .width, multiplier: 1, constant: 0)
                let aheight = NSLayoutConstraint(item: authorButton, attribute: .height, relatedBy: .equal, toItem: authorButton, attribute: .width, multiplier: 1, constant: 0)
                backboardStackView.addConstraints(vq)
                backboardStackView.addConstraints(vs)
                backboardStackView.addConstraints(va)
                backboardStackView.addConstraints([qheight, sheight, aheight])
                
                backboardStackView.distribution = .equalCentering
                backboardStackView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(backboardStackView)
                
                let horizontalConstraint = NSLayoutConstraint(item: backboardStackView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
                let verticalConstraint = NSLayoutConstraint(item: backboardStackView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
                let leftConstraint = NSLayoutConstraint(item: backboardStackView, attribute: .left, relatedBy: .equal, toItem: backboardView, attribute: .left, multiplier: 1, constant: 30)
                let rightConstraint = NSLayoutConstraint(item: backboardStackView, attribute: .right, relatedBy: .equal, toItem: backboardView, attribute: .right, multiplier: 1, constant: -30)
                let topConstraint = NSLayoutConstraint(item: backboardStackView, attribute: .top, relatedBy: .equal, toItem: backboardView, attribute: .top, multiplier: 1, constant: 10)
                let bottomConstraint = NSLayoutConstraint(item: backboardStackView, attribute: .bottom, relatedBy: .equal, toItem: backboardView, attribute: .bottom, multiplier: 1, constant: -10)
                
                view.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint, horizontalConstraint, verticalConstraint])
            }
        }
    }
}
