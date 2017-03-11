import UIKit
import SpriteKit

public class SPViewController: UIViewController {
    var boardView: SKView?
    var board: SKBoard?
    var arrangementController: SPArrangementController?
    var logoImageView: UIImageView?
    var buttonsStackView: UIStackView?
    var selectionSortButton: UIButton?
    var bubbleSortButton: UIButton?
    var quickSortButton: UIButton?
    var bogoSortButton: UIButton?
    var buttonsWidthConstraintNarrow: NSLayoutConstraint?
    var buttonsWidthConstraintWideLeft: NSLayoutConstraint?
    var buttonsWidthConstraintWideRight: NSLayoutConstraint?
    var buttonsHeightConstraintTall: NSLayoutConstraint?
    var buttonsHeightConstraintShort: NSLayoutConstraint?
    private var titleColor = UIColor.white
    
    public var performSelectionSort: ((_ arrangementController: SPArrangementController) -> Void)? {
        didSet {
            arrangementController?.performSelectionSort = performSelectionSort
        }
    }
    
    public func enableBoard() {
        board?.isUserTouchEnabled = true
    }
    
    public func disableBoard() {
        board?.isUserTouchEnabled = false
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        arrangementController = SPArrangementController(viewSize: CGSize(width: 1000, height: 300), offsetFromSuperview: CGPoint(x: 75 + 40, y: 100 + 40), itemSize: CGSize(width: 150, height: 200), itemCount: 6, interItemDistance: 20, velocity: 425)
        if let arrangementController = arrangementController {
            arrangementController.viewController = self
            board = SKBoard(arrangementController: arrangementController, viewSize: CGSize(width: 1080, height: 320))
        }
        
        boardView = SKView()
        if let boardView = boardView {
            boardView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(boardView)
            
            let views = ["view": view, "boardView": boardView]
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[boardView]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            
            let heightConstraint = NSLayoutConstraint(item: boardView, attribute: .height, relatedBy: .equal, toItem: boardView, attribute: .width, multiplier: 320.0/1080.0, constant: 0)
            
            
            let bottomConstraint = NSLayoutConstraint(item: boardView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            let topConstraint = NSLayoutConstraint(item: boardView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .top, multiplier: 1, constant: 40)
            topConstraint.priority = 800
            
            view.addConstraints(horizontalConstraints)
            view.addConstraints([heightConstraint, bottomConstraint, topConstraint])
            
            boardView.presentScene(board)
        }
        
        buttonsStackView = UIStackView()
        selectionSortButton = UIButton(type: .system)
        bubbleSortButton = UIButton(type: .system)
        quickSortButton = UIButton(type: .system)
        bogoSortButton = UIButton(type: .system)
        if let buttonsStackView = buttonsStackView,
            let selectionSortButton = selectionSortButton,
            let bubbleSortButton = bubbleSortButton,
            let quickSortButton = quickSortButton,
            let bogoSortButton = bogoSortButton {
            
            selectionSortButton.setTitle("Selection", for: .normal)
            selectionSortButton.setTitleColor(UIColor.black, for: .normal)
            
            bubbleSortButton.setTitle("Bubble", for: .normal)
            bubbleSortButton.setTitleColor(UIColor.black, for: .normal)
            
            quickSortButton.setTitle("Quick", for: .normal)
            quickSortButton.setTitleColor(UIColor.black, for: .normal)
            
            bogoSortButton.setTitle("Bogo", for: .normal)
            bogoSortButton.setTitleColor(UIColor.black, for: .normal)
            
            buttonsStackView.axis = .vertical
            buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
            buttonsStackView.addArrangedSubview(selectionSortButton)
            buttonsStackView.addArrangedSubview(bubbleSortButton)
            buttonsStackView.addArrangedSubview(quickSortButton)
            buttonsStackView.addArrangedSubview(bogoSortButton)
            buttonsStackView.distribution = .fillEqually
            view.addSubview(buttonsStackView)
            
            let horizontalConstraint = NSLayoutConstraint(item: buttonsStackView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
            buttonsWidthConstraintNarrow = NSLayoutConstraint(item: buttonsStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 180)
            
            buttonsWidthConstraintWideLeft = NSLayoutConstraint(item: buttonsStackView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 30)
            buttonsWidthConstraintWideRight = NSLayoutConstraint(item: buttonsStackView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 30)
            buttonsWidthConstraintWideLeft?.isActive = false
            buttonsWidthConstraintWideRight?.isActive = false
            
            buttonsHeightConstraintTall = NSLayoutConstraint(item: buttonsStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 140)
            buttonsHeightConstraintShort = NSLayoutConstraint(item: buttonsStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
            buttonsHeightConstraintShort?.isActive = false
            
            //heightConstraint.priority = 0.4
            let bottomConstraint = NSLayoutConstraint(item: buttonsStackView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: boardView, attribute: .top, multiplier: 1, constant: -20)
            
            view.addConstraints([horizontalConstraint, buttonsWidthConstraintNarrow!, buttonsWidthConstraintWideLeft!, buttonsWidthConstraintWideRight!,buttonsHeightConstraintTall!, buttonsHeightConstraintShort!, bottomConstraint])
        }
        
        logoImageView = UIImageView()
        if let logoImageView = logoImageView {
            logoImageView.image = UIImage(named: "logo")
            logoImageView.contentMode = .scaleAspectFit
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(logoImageView)
            
            let views = ["view": view, "logoImageView": logoImageView]
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[logoImageView]-(20)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            view.addConstraints(horizontalConstraints)
            
            let horizontalConstraint = NSLayoutConstraint(item: logoImageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
            let topConstraint = NSLayoutConstraint(item: logoImageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10)
            let heightConstraint = NSLayoutConstraint(item: logoImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 130)
            let heightConstraint2 = NSLayoutConstraint(item: logoImageView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
            heightConstraint.priority = 800
            
            
            let bottomConstraint = NSLayoutConstraint(item: logoImageView, attribute: .bottom, relatedBy: .equal, toItem: buttonsStackView!, attribute: .top, multiplier: 1, constant: -10)
            
            view.addConstraints([horizontalConstraint, topConstraint, heightConstraint, heightConstraint2, bottomConstraint])
            
        }
        
        view.backgroundColor = UIColor.white
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.arrangementController?.performSelectionSort!(self.arrangementController!)
        }
        
        
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        /*let alertController = UIAlertController(title: "Things are happening", message: "Pleas confirm?", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)*/
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
            self.view.setNeedsLayout()
        }
        
        print(buttonsStackView?.frame.width, buttonsStackView?.frame.height, buttonsStackView?.frame.origin.x, buttonsStackView?.frame.origin.y)
    }
    
    public override func viewWillLayoutSubviews() {
        /*let alertController = UIAlertController(title: "Things are happening", message: String(format:"%f", self.view.frame.height), preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)*/
        
        print(view.frame.height)
        if view.frame.height < 400 {
            buttonsHeightConstraintTall?.isActive = false
            buttonsHeightConstraintShort?.isActive = true
            buttonsWidthConstraintNarrow?.isActive = false
            buttonsWidthConstraintWideLeft?.isActive = true
            buttonsWidthConstraintWideRight?.isActive = true
            buttonsStackView?.axis = .horizontal
        } else {
            buttonsHeightConstraintTall?.isActive = true
            buttonsHeightConstraintShort?.isActive = false
            buttonsWidthConstraintNarrow?.isActive = true
            buttonsWidthConstraintWideLeft?.isActive = false
            buttonsWidthConstraintWideRight?.isActive = false
            buttonsStackView?.axis = .vertical
        }
    }
}
