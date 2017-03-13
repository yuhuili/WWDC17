import UIKit

class SPInfoViewController: UIViewController, UIGestureRecognizerDelegate {
    private var woodBackgroundView: UIImageView?
    private var woodCloseButton: UIButton?
    private var details: UITextView?
    public weak var mainViewController: SPViewController?
    
    public var text: NSAttributedString? {
        didSet {
            details?.attributedText = text
        }
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        setupGestureRecognizer()
        setupBackground()
        setupTextView()
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func close() {
        mainViewController?.dismissChildVC()
    }
    
    @objc private func handleBackgroundTap(_ gestureRecognizer: UITapGestureRecognizer) {
        mainViewController?.dismissChildVC()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: view)
        if woodBackgroundView?.frame.contains(point) == false {
            handleBackgroundTap(gestureRecognizer as! UITapGestureRecognizer)
            return true
        }
        return false
    }
    
    private func setupBackground() {
        woodBackgroundView = UIImageView(image: UIImage(named: "retina_wood"))
        if let woodBackgroundView = woodBackgroundView {
            woodBackgroundView.layer.cornerRadius = 5
            woodBackgroundView.layer.masksToBounds = true
            woodBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(woodBackgroundView)
            
            let views = ["view": view, "wood": woodBackgroundView]
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[wood]-(20)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(20)-[wood]-(20)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            
            view.addConstraints(horizontalConstraints)
            view.addConstraints(verticalConstraints)
        }
        
        woodCloseButton = UIButton()
        if let woodCloseButton = woodCloseButton, let woodBackgroundView = woodBackgroundView {
            woodCloseButton.addTarget(self, action: #selector(close), for: .touchUpInside)
            woodCloseButton.setImage(UIImage(named: "button_close"), for: .normal)
            woodCloseButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(woodCloseButton)
            
            let widthConstraint = NSLayoutConstraint(item: woodCloseButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
            let heightConstraint = NSLayoutConstraint(item: woodCloseButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
            let leftConstraint = NSLayoutConstraint(item: woodCloseButton, attribute: .left, relatedBy: .equal, toItem: woodBackgroundView, attribute: .left, multiplier: 1, constant: 10)
            let topConstraint = NSLayoutConstraint(item: woodCloseButton, attribute: .top, relatedBy: .equal, toItem: woodBackgroundView, attribute: .top, multiplier: 1, constant: 10)
            
            view.addConstraints([widthConstraint, heightConstraint, leftConstraint, topConstraint])
        }
    }
    
    private func setupTextView() {
        details = UITextView()
        if let details = details, let woodBackgroundView = woodBackgroundView {
            details.translatesAutoresizingMaskIntoConstraints = false
            if let text = text {
                details.attributedText = text
            }
            details.backgroundColor = UIColor.clear
            view.addSubview(details)
            
            let topConstraint = NSLayoutConstraint(item: details, attribute: .top, relatedBy: .equal, toItem: woodBackgroundView, attribute: .top, multiplier: 1, constant: 40)
            let bottomConstraint = NSLayoutConstraint(item: details, attribute: .bottom, relatedBy: .equal, toItem: woodBackgroundView, attribute: .bottom, multiplier: 1, constant: -10)
            let leftConstraint = NSLayoutConstraint(item: details, attribute: .left, relatedBy: .equal, toItem: woodBackgroundView, attribute: .left, multiplier: 1, constant: 10)
            let rightConstraint = NSLayoutConstraint(item: details, attribute: .right, relatedBy: .equal, toItem: woodBackgroundView, attribute: .right, multiplier: 1, constant: -10)
            
            view.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        }
    }
}
