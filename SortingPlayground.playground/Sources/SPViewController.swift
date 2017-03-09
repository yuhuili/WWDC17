import UIKit
import SpriteKit

public class SPViewController: UIViewController {
    var boardView: SKView?
    var board: SKBoard?
    var arrangementController: SPArrangementController?
    var appTitlePrimary: UILabel?
    var appTitleSecondary: UILabel?
    private var titleColor = UIColor.white
    
    public var performSelectionSort: ((_ arrangementController: SPArrangementController) -> Void)? {
        didSet {
            arrangementController?.performSelectionSort = performSelectionSort
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        arrangementController = SPArrangementController(viewSize: CGSize(width: 1000, height: 300), offsetFromSuperview: CGPoint(x: 75 + 40, y: 100 + 40), itemSize: CGSize(width: 150, height: 200), itemCount: 6, interItemDistance: 20, velocity: 425)
        if let arrangementController = arrangementController {
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
            
            view.addConstraints(horizontalConstraints)
            view.addConstraints([heightConstraint, bottomConstraint])
            
            boardView.presentScene(board)
        }
        
        appTitlePrimary = UILabel()
        if let appTitlePrimary = appTitlePrimary {
            appTitlePrimary.text = "Sorting"
            appTitlePrimary.font = UIFont(name: "akaDylan Collage", size: 50)
            appTitlePrimary.textAlignment = .center
            appTitlePrimary.minimumScaleFactor = 0.4
            appTitlePrimary.adjustsFontSizeToFitWidth = true
            appTitlePrimary.textColor = titleColor
            appTitlePrimary.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(appTitlePrimary)
            
            let views = ["view": view, "appTitlePrimary": appTitlePrimary]
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(40)-[appTitlePrimary]-(40)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(80)-[appTitlePrimary(60)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            
            view.addConstraints(horizontalConstraints)
            view.addConstraints(verticalConstraints)
        }
        
        appTitleSecondary = UILabel()
        if let appTitleSecondary = appTitleSecondary {
            appTitleSecondary.text = "Playground"
            appTitleSecondary.font = UIFont(name: "akaDylan Collage", size: 50)
            appTitleSecondary.textAlignment = .center
            appTitleSecondary.minimumScaleFactor = 0.4
            appTitleSecondary.adjustsFontSizeToFitWidth = true
            appTitleSecondary.textColor = titleColor
            appTitleSecondary.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(appTitleSecondary)
            
            let views = ["appTitlePrimary": appTitlePrimary, "appTitleSecondary": appTitleSecondary]
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(40)-[appTitleSecondary]-(40)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[appTitlePrimary]-[appTitleSecondary(50)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            
            view.addConstraints(horizontalConstraints)
            view.addConstraints(verticalConstraints)
        }
        
        
        view.backgroundColor = UIColor.black
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.arrangementController?.performSelectionSort!(self.arrangementController!)
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(view.frame.width)
    }
}
