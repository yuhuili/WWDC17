import UIKit
import SpriteKit

public class SPViewController: UIViewController {
    var boardView: SKView?
    var board: SPBoard?
    var cloudView: SKView?
    var cloudScene: SPCloudScene?
    var arrangementController: SPArrangementController?
    var logoImageView: UIImageView?
    var buttonsStackView: UIStackView?
    var selectionSortButton: UIButton?
    var bubbleSortButton: UIButton?
    var quickSortButton: UIButton?
    var bogoSortButton: UIButton?
    var grassImageView: UIImageView?
    private var buttonsWidthConstraintNarrow: NSLayoutConstraint?
    private var buttonsWidthConstraintWideLeft: NSLayoutConstraint?
    private var buttonsWidthConstraintWideRight: NSLayoutConstraint?
    private var buttonsHeightConstraintTall: NSLayoutConstraint?
    private var buttonsHeightConstraintShort: NSLayoutConstraint?
    private var titleColor = UIColor.white
    
    // MARK: - User Interaction and Animations
    @objc private func selectionSort() {
        disableBoard()
        disableButtons()
        self.arrangementController?.performSelectionSort!(self.arrangementController!)
    }
    
    public var performSelectionSort: ((_ arrangementController: SPArrangementController) -> Void)? {
        didSet {
            arrangementController?.performSelectionSort = performSelectionSort
        }
    }
    
    @objc private func bubbleSort() {
        disableBoard()
        disableButtons()
        self.arrangementController?.performBubbleSort!(self.arrangementController!)
    }
    
    public var performBubbleSort: ((_ arrangementController: SPArrangementController) -> Void)? {
        didSet {
            arrangementController?.performBubbleSort = performBubbleSort
        }
    }
    
    @objc private func quickSort() {
        disableBoard()
        disableButtons()
        self.arrangementController?.performQuickSort!(self.arrangementController!)
    }
    
    public var performQuickSort: ((_ arrangementController: SPArrangementController) -> Void)? {
        didSet {
            arrangementController?.performQuickSort = performQuickSort
        }
    }
    
    public var labelText: String? {
        didSet {
            board?.labelText = labelText
        }
    }
    
    public func enableBoard() {
        board?.isUserTouchEnabled = true
    }
    
    public func disableBoard() {
        board?.isUserTouchEnabled = false
    }
    
    public func enableButtons() {
        buttonsStackView?.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.2) {
            self.buttonsStackView?.alpha = 1
        }
        selectionSortButton?.setTitleColor(NormalColorOnWood, for: .normal)
        bubbleSortButton?.setTitleColor(NormalColorOnWood, for: .normal)
        quickSortButton?.setTitleColor(NormalColorOnWood, for: .normal)
        bogoSortButton?.setTitleColor(NormalColorOnWood, for: .normal)
    }
    
    public func disableButtons() {
        buttonsStackView?.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2) { 
            self.buttonsStackView?.alpha = 0.7
        }
        selectionSortButton?.setTitleColor(DisabledColorOnWood, for: .normal)
        bubbleSortButton?.setTitleColor(DisabledColorOnWood, for: .normal)
        quickSortButton?.setTitleColor(DisabledColorOnWood, for: .normal)
        bogoSortButton?.setTitleColor(DisabledColorOnWood, for: .normal)
    }
    
    // MARK: - UIViewController
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        arrangementController = SPArrangementController(viewSize: CGSize(width: 1000, height: 300), offsetFromSuperview: CGPoint(x: 75 + 40, y: 100 + 40), itemSize: CGSize(width: 150, height: 200), itemCount: 6, interItemDistance: 20, velocity: 425)
        if let arrangementController = arrangementController {
            arrangementController.viewController = self
            board = SPBoard(arrangementController: arrangementController, viewSize: CGSize(width: 1080, height: 320))
        }
        view.backgroundColor = UIColor.white
        
        setupGradient()
        //setupCloudView()
        setupGrassImageView()
        setupBoardView()
        setupButtons()
        setupLogo()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
            self.view.setNeedsLayout()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.cloudScene?.size = (self.cloudView?.frame.size)!
            self.cloudScene?.restartTimer()
        }
    }
    
    public override func viewWillLayoutSubviews() {
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
    
    public override func viewDidLayoutSubviews() {
        cloudScene?.size = (cloudView?.frame.size)!
        cloudScene?.restartTimer()
        
        if view.frame.height < 400 {
            cloudScene?.minimumY = 160
        } else {
            cloudScene?.minimumY = nil
        }
    }
    
    // MARK: - Set up views
    private func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = SkyGradient
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setupGrassImageView() {
        grassImageView = UIImageView()
        if let grassImageView = grassImageView {
            grassImageView.image = UIImage(named: "grass")
            grassImageView.contentMode = .scaleAspectFit
            grassImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(grassImageView)
            
            let views = ["view": view, "grassImageView": grassImageView]
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[grassImageView]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            let heightConstraint = NSLayoutConstraint(item: grassImageView, attribute: .height, relatedBy: .equal, toItem: grassImageView, attribute: .width, multiplier: 596.0/1024.0, constant: 0)
            
            let topConstraint = NSLayoutConstraint(item: grassImageView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .top, multiplier: 1, constant: 40)
            let bottomConstraint = NSLayoutConstraint(item: grassImageView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            bottomConstraint.priority = 800
            
            view.addConstraints(horizontalConstraints)
            view.addConstraints([heightConstraint, topConstraint, bottomConstraint])
        }
    }
    
    private func setupCloudView() {
        cloudView = SKView()
        if let cloudView = cloudView {
            cloudView.allowsTransparency = true
            cloudView.translatesAutoresizingMaskIntoConstraints = false
            cloudView.contentMode = .scaleToFill
            view.addSubview(cloudView)
            
            let views = ["view": view, "cloudView": cloudView]
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[cloudView]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[cloudView]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            
            view.addConstraints(horizontalConstraints)
            view.addConstraints(verticalConstraints)
            
            cloudScene = SPCloudScene()
            
            cloudView.presentScene(cloudScene)
        }
    }
    
    private func setupBoardView() {
        boardView = SKView()
        if let boardView = boardView {
            boardView.allowsTransparency = true
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
    }
    
    private func setupButtons() {
        buttonsStackView = UIStackView()
        selectionSortButton = UIButton.createSPButton()
        bubbleSortButton = UIButton.createSPButton()
        quickSortButton = UIButton.createSPButton()
        bogoSortButton = UIButton.createSPButton()
        if let buttonsStackView = buttonsStackView,
            let selectionSortButton = selectionSortButton,
            let bubbleSortButton = bubbleSortButton,
            let quickSortButton = quickSortButton,
            let bogoSortButton = bogoSortButton {
            
            bubbleSortButton.setTitle("Bubble", for: .normal)
            bubbleSortButton.addTarget(self, action: #selector(bubbleSort), for: .touchUpInside)
            
            selectionSortButton.setTitle("Selection", for: .normal)
            selectionSortButton.addTarget(self, action: #selector(selectionSort), for: .touchUpInside)
            
            quickSortButton.setTitle("Quick", for: .normal)
            quickSortButton.addTarget(self, action: #selector(quickSort), for: .touchUpInside)
            
            bogoSortButton.setTitle("Bogo", for: .normal)
            
            buttonsStackView.axis = .vertical
            buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
            buttonsStackView.addArrangedSubview(bubbleSortButton)
            buttonsStackView.addArrangedSubview(selectionSortButton)
            buttonsStackView.addArrangedSubview(quickSortButton)
            buttonsStackView.addArrangedSubview(bogoSortButton)
            buttonsStackView.distribution = .fillEqually
            buttonsStackView.spacing = 8
            view.addSubview(buttonsStackView)
            
            let horizontalConstraint = NSLayoutConstraint(item: buttonsStackView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
            buttonsWidthConstraintNarrow = NSLayoutConstraint(item: buttonsStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
            
            buttonsWidthConstraintWideLeft = NSLayoutConstraint(item: buttonsStackView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 50)
            buttonsWidthConstraintWideRight = NSLayoutConstraint(item: buttonsStackView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -50)
            buttonsWidthConstraintWideLeft?.isActive = false
            buttonsWidthConstraintWideRight?.isActive = false
            
            buttonsHeightConstraintTall = NSLayoutConstraint(item: buttonsStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 160)
            buttonsHeightConstraintShort = NSLayoutConstraint(item: buttonsStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
            buttonsHeightConstraintShort?.isActive = false
            
            let bottomConstraint = NSLayoutConstraint(item: buttonsStackView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: boardView, attribute: .top, multiplier: 1, constant: -10)
            
            view.addConstraints([horizontalConstraint, buttonsWidthConstraintNarrow!, buttonsWidthConstraintWideLeft!, buttonsWidthConstraintWideRight!,buttonsHeightConstraintTall!, buttonsHeightConstraintShort!, bottomConstraint])
        }
    }
    
    private func setupLogo() {
        logoImageView = UIImageView()
        if let logoImageView = logoImageView {
            logoImageView.image = UIImage(named: "logo")?.withRenderingMode(.alwaysTemplate)
            logoImageView.tintColor = UIColor.white
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
    }
}
