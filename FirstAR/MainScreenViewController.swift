import UIKit

class MainScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Home Indicator
        let gradientView = GradientView(frame: UIScreen.main.bounds)
        view.addSubview(gradientView)
        let data = ["hello","world","its","me"]
        let customViews = [ CustomView(text: "Beginner", image: UIImage(named: "progress")!),
                            CustomView(text: "Middle", image: UIImage(named: "progress-2")!),
                            CustomView(text: "High", image: UIImage(named: "progress-3")!) ]
        
        let stackView = StackView(views: customViews)
        
        self.view.addSubview(stackView)
        
    }
    
       
    

}
