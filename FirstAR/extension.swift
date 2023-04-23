import Foundation
import UIKit

extension CGFloat{
    static func random() -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor{
    static func random()-> UIColor{
        return UIColor(
            red: .random(),
            green: .random(),
            blue: .random(),
            alpha: 1.0)
    }
}

//установка градиента фона
class GradientView: UIView {

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }

    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 0.16, green: 0.8, blue: 0.5, alpha: 0.0).cgColor,
            UIColor(red: 0.16, green: 0.8, blue: 0.5, alpha: 0.85).cgColor, //зеленый
            UIColor(red: 0.05, green: 0.06, blue: 0.08, alpha: 1.0).cgColor //черный
        ]
        gradientLayer.locations = [0.0, 0.0, 0.45]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
    }

}

//элемент меню
class CustomView: UIView {
    
    private let imageView: UIImageView
    private let nameLevelLabel: UILabel
    private let pushLabel: UILabel
    private let arrowView: UIImageView
    
    init(text: String, image: UIImage) {
        // set the frame with width of 300px and height of 70px
        //let frame = CGRect(x: 0, y: 0, width: 300, height: 70)
    
        arrowView = UIImageView(frame: CGRect(x: 320, y: 38, width: 15, height: 15))
        imageView = UIImageView(frame: CGRect(x: 15, y: 18, width: 50, height: 50))
        nameLevelLabel = UILabel(frame: CGRect(x: 78, y: 20, width: 100, height: 25))
        pushLabel = UILabel(frame: CGRect(x: 78, y: 45, width: 150, height: 20))
        
        // call the super init with the frame
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 18
        
        self.backgroundColor = .white
        self.alpha = 0.7
        
        //customize the image view with the provided image
        imageView.image = image
        arrowView.image = UIImage(named: "arrow")
        addSubview(arrowView)
        addSubview(imageView)
        
        // customize the label with the provided text
        nameLevelLabel.text = text
        nameLevelLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        nameLevelLabel.textColor = UIColor.black
        addSubview(nameLevelLabel)
        
        pushLabel.text = "выберите сцену"
        pushLabel.font = UIFont(name: "Helvetica-Italic", size: 5)
        pushLabel.textColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.44)
        addSubview(pushLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//класс задающий стеквью
class StackView: UIScrollView {
    
    private var stackView: UIStackView!
    
    init(views: [CustomView]) {
        super.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height/2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2))
        
        stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 60).isActive = true
            view.heightAnchor.constraint(equalToConstant: 90).isActive = true
        }
        
        addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: (UIScreen.main.bounds.width/2) -  ((UIScreen.main.bounds.width - 60)/2)).isActive = true
       // stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
//        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
