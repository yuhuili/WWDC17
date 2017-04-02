import UIKit
import SpriteKit
import AVFoundation

public class SPViewController: UIViewController {
    // MARK: Controllers
    public var arrangementController: SPArrangementController?
    private var infoVC: SPMenuViewController?
    
    // MARK: SpriteKit
    private var boardView: SKView?
    private var board: SPBoard?
    private var cloudView: SKView?
    private var cloudScene: SPCloudScene?
    
    // MARK: UI
    var logoImageView: UIImageView?
    var buttonsStackView: UIStackView?
    var selectionSortButton: UIButton?
    var bubbleSortButton: UIButton?
    var quickSortButton: UIButton?
    var bogoSortButton: UIButton?
    var grassImageView: UIImageView?
    var menuButton: UIButton?
    var musicButton: UIButton?
    var funcButton: UIButton?
    
    var musicPlayer: AVAudioPlayer?
    var soundPlayer: AVAudioPlayer?
    
    public var shouldTerminate: Bool {
        didSet {
            arrangementController?.shouldTerminate = shouldTerminate
        }
    }
    
    private var showBubble: Bool
    private var showSelection: Bool
    private var showQuick: Bool
    private var showBogo: Bool
    
    // MARK: Constraints for different view sizes
    private var buttonsWidthConstraintNarrow: NSLayoutConstraint?
    private var buttonsWidthConstraintWideLeft: NSLayoutConstraint?
    private var buttonsWidthConstraintWideRight: NSLayoutConstraint?
    private var buttonsHeightConstraintTall: NSLayoutConstraint?
    private var buttonsHeightConstraintShort: NSLayoutConstraint?

    
    // MARK: - Exposed functions for Contents.swift
    // Note: These functions are not following Swift conventions but are instead trying to mimic the feel of a class for a beginner audience.
    public var performBubbleSort: ((_ arrangementController: SPArrangementController) -> Void)? {
        didSet {
            arrangementController?.performBubbleSort = performBubbleSort
        }
    }
    
    public var performSelectionSort: ((_ arrangementController: SPArrangementController) -> Void)? {
        didSet {
            arrangementController?.performSelectionSort = performSelectionSort
        }
    }
    
    public var performQuickSort: ((_ arrangementController: SPArrangementController) -> Void)? {
        didSet {
            arrangementController?.performQuickSort = performQuickSort
        }
    }
    
    public var performBogoSort: ((_ arrangementController: SPArrangementController) -> Void)? {
        didSet {
            arrangementController?.performBogoSort = performBogoSort
        }
    }
    
    public var shuffle: ((_ count: Int) -> Void)? {
        didSet {
            arrangementController?.shuffle = shuffle
        }
    }
    
    // MARK: - User Interaction and Animations
    @objc private func bubbleSort() {
        disableBoard()
        disableButtons()
        self.board?.hideHandIfNeeded()
        self.arrangementController?.performBubbleSort!(self.arrangementController!)
    }
    
    @objc private func selectionSort() {
        disableBoard()
        disableButtons()
        self.board?.hideHandIfNeeded()
        self.arrangementController?.performSelectionSort!(self.arrangementController!)
    }
    
    @objc private func quickSort() {
        disableBoard()
        disableButtons()
        self.board?.hideHandIfNeeded()
        self.arrangementController?.performQuickSort!(self.arrangementController!)
    }
    
    @objc private func bogoSort() {
        disableBoard()
        disableButtons()
        self.board?.hideHandIfNeeded()
        self.arrangementController?.performBogoSort!(self.arrangementController!)
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
        
        funcButton?.setTitle("Shuffle", for: .normal)
        funcButton?.isUserInteractionEnabled = true
        funcButton?.alpha = 1
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
        
        funcButton?.setTitle("Stop", for: .normal)
    }
    
    public func handleFunc() {
        if funcButton?.title(for: .normal) == "Shuffle" {
            arrangementController?.shuffle!((arrangementController?.cards.count)!)
        } else {
            shouldTerminate = true
            
            funcButton?.setTitle("Stopping", for: .normal)
            funcButton?.isUserInteractionEnabled = false
            funcButton?.alpha = 0.7
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2, execute: {
                self.labelText = ""
                self.shouldTerminate = false
                self.enableBoard()
                self.enableButtons()
                self.arrangementController?.appendAction(type: .terminate, index1: nil, index2: nil)
                self.arrangementController?.executeActions()
            })
        }
    }
    
    public func adjustSpeed(_ sender: UISlider) {
        arrangementController?.animationSpeed = Double(sender.maximumValue - (sender.value - sender.minimumValue))
    }
    
    public func playShuffle() {
        soundPlayer?.stop()
        soundPlayer?.currentTime = 0
        soundPlayer?.play()
    }
    
    @objc private func toggleMusic() {
        if let musicPlayer = musicPlayer {
            if musicPlayer.isPlaying {
                musicButton?.setImage(UIImage(named: "music_icon_off"), for: .normal)
                musicPlayer.stop()
            } else {
                musicButton?.setImage(UIImage(named: "music_icon_on"), for: .normal)
                musicPlayer.play()
            }
        }
    }
    
    // MARK: - Menu Control
    public func showMenu() {
        let vc = SPMenuViewController()
        vc.mainViewController = self
        self.addChildViewController(vc)
        vc.view.frame = view.frame
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    public func dismissChildVC() {
        if let vc = childViewControllers.last {
            vc.willMove(toParentViewController: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParentViewController()
        }
    }
    
    private func openInfoViewController() -> SPInfoViewController {
        dismissChildVC()
        
        let vc = SPInfoViewController()
        vc.mainViewController = self
        self.addChildViewController(vc)
        vc.view.frame = view.frame
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        
        return vc
    }
    
    public func openQuestions() {
        let vc = openInfoViewController()
        openRTF("Questions", vc: vc, prependString: nil)
    }
    
    public func openSuggestions() {
        let vc = openInfoViewController()
        openRTF("Suggestions", vc: vc, prependString: nil)
    }
    
    public func openAbout() {
        let textAttachment = NSTextAttachment()
        textAttachment.image = UIImage(named: "me")
        textAttachment.setImageHeight(height: 80)
        
        let stringWithImage = NSAttributedString(attachment: textAttachment)
        let mutableStringWithImage = NSMutableAttributedString()
        mutableStringWithImage.append(stringWithImage)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        mutableStringWithImage.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: mutableStringWithImage.length))
        
        let vc = openInfoViewController()
        openRTF("About", vc: vc, prependString: mutableStringWithImage)
    }
    
    private func openRTF(_ name: String, vc: SPInfoViewController, prependString: NSAttributedString?) {
        if let rtfPath = Bundle.main.url(forResource: name, withExtension: "rtf") {
            do {
                let attributedString = try NSAttributedString(url: rtfPath, options: [NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType], documentAttributes: nil)
                if let prependString = prependString {
                    let res = NSMutableAttributedString()
                    res.append(prependString)
                    res.append(NSAttributedString(string: "\n\n\n"))
                    res.append(attributedString)
                    vc.text = res
                    return
                }
                vc.text = attributedString
            } catch {
                
            }
        }
    }
    
    // MARK: - UIViewController
    public init(showBubble: Bool, showSelection: Bool, showQuick: Bool, showBogo: Bool) {
        self.showBubble = showBubble
        self.showSelection = showSelection
        self.showQuick = showQuick
        self.showBogo = showBogo
        self.shouldTerminate = false
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        arrangementController = SPArrangementController(viewSize: SPArrangementAreaSizeSecondary, offsetFromSuperview: CGPoint(x: 75 + 40, y: 100 + 40), itemSize: SPCardSize, itemCount: 6, interItemDistance: SPCardInterItemDistance, velocity: SPCardVelocity)
        if let arrangementController = arrangementController {
            arrangementController.viewController = self
            board = SPBoard(arrangementController: arrangementController, viewSize: SPBoardSize)
        }
        view.backgroundColor = UIColor.white
        
        setupGradient()
        setupCloudView()
        setupGrassImageView()
        setupBoardView()
        setupButtons()
        setupLogo()
        setupMenuButton()
        setupMusicButton()
        setupOverlayButtons()
        
        do {
            let backgroundMusicURL = Bundle.main.url(forResource: "GreenHills", withExtension: "mp3")
            let shuffleURL = Bundle.main.url(forResource: "shuffle", withExtension: "mp3")
            if let backgroundMusicURL = backgroundMusicURL, let shuffleURL = shuffleURL {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                musicPlayer = try AVAudioPlayer(contentsOf: backgroundMusicURL)
                musicPlayer?.volume = 0.1
                musicPlayer?.numberOfLoops = -1
                musicPlayer?.prepareToPlay()
                musicPlayer?.play()
                
                soundPlayer = try AVAudioPlayer(contentsOf: shuffleURL)
                soundPlayer?.volume = 0.05
                soundPlayer?.prepareToPlay()
            }
        } catch {
            
        }
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
        if view.frame.height < 400 && ((showBubble ? 1 : 0) + (showSelection ? 1 : 0) + (showQuick ? 1 : 0) + (showBogo ? 1 : 0)) > 1 {
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
    
    // MARK: - View Setups
    private func setupMenuButton() {
        menuButton = UIButton(type: .infoDark)
        if let menuButton = menuButton {
            menuButton.tintColor = UIColor.white
            menuButton.translatesAutoresizingMaskIntoConstraints = false
            menuButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
            view.addSubview(menuButton)
            
            let views = ["view": view, "menuButton": menuButton]
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[menuButton(22)]-(10)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[menuButton(22)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            
            view.addConstraints(horizontalConstraints)
            view.addConstraints(verticalConstraints)
        }
    }
    
    private func setupMusicButton() {
        musicButton = UIButton()
        if let musicButton = musicButton {
            musicButton.setImage(UIImage(named: "music_icon_on"), for: .normal)
            musicButton.translatesAutoresizingMaskIntoConstraints = false
            musicButton.addTarget(self, action: #selector(toggleMusic), for: .touchUpInside)
            view.addSubview(musicButton)
            
            let views = ["view": view, "musicButton": musicButton]
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[musicButton(22)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[musicButton(22)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            
            view.addConstraints(horizontalConstraints)
            view.addConstraints(verticalConstraints)
        }
    }
    
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
            
            buttonsStackView.axis = .vertical
            buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
            
            if showBubble {
                bubbleSortButton.setTitle("Bubble", for: .normal)
                bubbleSortButton.addTarget(self, action: #selector(bubbleSort), for: .touchUpInside)
                buttonsStackView.addArrangedSubview(bubbleSortButton)
            }
            
            if showSelection {
                selectionSortButton.setTitle("Selection", for: .normal)
                selectionSortButton.addTarget(self, action: #selector(selectionSort), for: .touchUpInside)
                buttonsStackView.addArrangedSubview(selectionSortButton)
            }
            
            if showQuick {
                quickSortButton.setTitle("Quick", for: .normal)
                quickSortButton.addTarget(self, action: #selector(quickSort), for: .touchUpInside)
                buttonsStackView.addArrangedSubview(quickSortButton)
            }
            
            if showBogo {
                bogoSortButton.setTitle("Bogo", for: .normal)
                bogoSortButton.addTarget(self, action: #selector(bogoSort), for: .touchUpInside)
                buttonsStackView.addArrangedSubview(bogoSortButton)
            }
            
            buttonsStackView.distribution = .fillEqually
            buttonsStackView.spacing = 8
            view.addSubview(buttonsStackView)
            
            let horizontalConstraint = NSLayoutConstraint(item: buttonsStackView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
            
            buttonsWidthConstraintNarrow = NSLayoutConstraint(item: buttonsStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
            
            buttonsWidthConstraintWideLeft = NSLayoutConstraint(item: buttonsStackView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 50)
            buttonsWidthConstraintWideRight = NSLayoutConstraint(item: buttonsStackView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -50)
            buttonsWidthConstraintWideLeft?.isActive = false
            buttonsWidthConstraintWideRight?.isActive = false
            
            let calculatedHeight = 160.0/4 * ((showBubble ? 1 : 0) + (showSelection ? 1 : 0) + (showQuick ? 1 : 0) + (showBogo ? 1 : 0))
            
            buttonsHeightConstraintTall = NSLayoutConstraint(item: buttonsStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(calculatedHeight))
            buttonsHeightConstraintShort = NSLayoutConstraint(item: buttonsStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
            buttonsHeightConstraintShort?.isActive = false
            
            let bottomConstraint = NSLayoutConstraint(item: buttonsStackView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: boardView, attribute: .top, multiplier: 1, constant: -30)
            
            view.addConstraints([horizontalConstraint, buttonsWidthConstraintNarrow!, buttonsWidthConstraintWideLeft!, buttonsWidthConstraintWideRight!,buttonsHeightConstraintTall!, buttonsHeightConstraintShort!, bottomConstraint])
        }
    }
    
    private func setupLogo() {
        logoImageView = UIImageView()
        if let logoImageView = logoImageView {
            logoImageView.image = UIImage(named: "logo")
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
    
    private func setupOverlayButtons() {
        funcButton = UIButton()
        if let funcButton = funcButton, let boardView = boardView {
            funcButton.setTitle("Shuffle", for: .normal)
            funcButton.translatesAutoresizingMaskIntoConstraints = false
            funcButton.titleLabel?.adjustsFontSizeToFitWidth = true
            funcButton.titleLabel?.minimumScaleFactor = 0.2
            funcButton.setBackgroundImage(UIImage(named: "purty_wood"), for: .normal)
            funcButton.setTitleColor(NormalColorOnWood, for: .normal)
            funcButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            funcButton.titleEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2)
            funcButton.layer.cornerRadius = 5
            funcButton.layer.masksToBounds = true
            funcButton.addTarget(self, action: #selector(handleFunc), for: .touchUpInside)
            view.addSubview(funcButton)
            
            let heightConstraint = NSLayoutConstraint(item: funcButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20.0)
            let widthConstraint = NSLayoutConstraint(item: funcButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50.0)
            let topConstraint = NSLayoutConstraint(item: funcButton, attribute: .bottom, relatedBy: .equal, toItem: boardView, attribute: .top, multiplier: 1, constant: 0)
            let centerConstraint = NSLayoutConstraint(item: funcButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
            
            view.addConstraints([widthConstraint, heightConstraint, topConstraint, centerConstraint])
        }
    }
}
