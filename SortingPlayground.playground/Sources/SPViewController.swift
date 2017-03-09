import UIKit
import SpriteKit

public class SPViewController: UIViewController {
    var boardView: SKView?
    var board: SKBoard?
    var arrangementController: SPArrangementController?
    
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
        
        
        view.backgroundColor = UIColor.black
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(view.frame.width)
    }
}
