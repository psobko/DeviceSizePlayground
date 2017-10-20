//: A UIKit based Playground which resizes for each device

import UIKit
import PlaygroundSupport

struct DeviceSize {
    static let iPhone4 = CGSize(width:320, height:480)
    static let iPhone5 = CGSize(width:320, height:568)
    static let iPhone8 = CGSize(width:375, height:667)
    static let iPhone8Plus = CGSize(width:414, height:736)
    static let iPhoneX = CGSize(width:375, height:812)
    static let iPad = CGSize(width:768, height:1024)
    static let iPadPro = CGSize(width:1024, height:1366)
    
    static let all = [iPhone4, iPhone5, iPhone8, iPhone8Plus, iPhoneX, iPad]
    
    static func stringForSize(_ size: CGSize) -> String {
        switch size {
        case DeviceSize.iPhone4: return "iPhone 4"
        case DeviceSize.iPhone5: return "iPhone SE"
        case DeviceSize.iPhone8: return "iPhone 8"
        case DeviceSize.iPhone8Plus: return "iPhone 8+"
        case DeviceSize.iPhoneX: return "iPhone X"
        case DeviceSize.iPad: return "iPad"
        case DeviceSize.iPadPro: return "iPad Pro"
        default: return "Unknown"
        }
    }
}

class MyViewController : UIViewController {
    let textField = UITextView()
    var size = DeviceSize.iPhone8
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        textField.textAlignment = .center
        textField.text = "When you tap here the entire keyboard should be visible"
        textField.sizeToFit()
        view.addSubview(textField)
        
        self.view = view
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.frame = CGRect(origin: CGPoint(x:0,y:0), 
                                 size: size)
        textField.center = CGPoint(x:view.frame.midX,
                                   y: 50)
    }
    
    @objc func doa(sender:UIButton) {
        size = DeviceSize.all[sender.tag]
        view.layoutSubviews()
        viewWillLayoutSubviews()
        viewDidLayoutSubviews()
        for subview in (sender.superview?.subviews)! {
            if subview is UIButton {
                (subview as? UIButton)?.isSelected = false
            }
        }
        sender.isSelected = true
    }
}

let window = UIWindow(frame: CGRect(x: 0,
                                    y: 0,
                                    width: 768,
                                    height: 1024))
let viewController = MyViewController()

extension UIWindow {
    public func addDeviceButtons() {
        for index in 0...DeviceSize.all.count-1 {
            let btn = UIButton.init(frame: CGRect(x: Int(self.frame.maxX)-150,
                                                  y: 35 * Int(index),
                                                  width: 150,
                                                  height: 30))
            btn.backgroundColor = #colorLiteral(red: 0.9418308139, green: 0.9425446987, blue: 0.9419413209, alpha: 1)
            btn.setTitleColor(#colorLiteral(red: 0.4358252287, green: 0.4361768961, blue: 0.4358797669, alpha: 1), for: .normal)
            btn.setTitleColor(#colorLiteral(red: 0.01681548543, green: 0.4095681608, blue: 0.9422318935, alpha: 1), for: .selected)
            btn.tag = index
            btn.layer.cornerRadius = 5
            btn.setTitle(DeviceSize.stringForSize(DeviceSize.all[index]),
                         for: .normal)
            btn.addTarget(viewController,
                          action: #selector(MyViewController.doa),
                          for: .touchUpInside)
            self.addSubview(btn)
            
            if index == 2
            {
                viewController.doa(sender: btn)
            }
        }
    }
}

// Present the view controller in the Live View window

window.backgroundColor = #colorLiteral(red: 0.2858114839, green: 0.2861355543, blue: 0.2639463544, alpha: 1)
window.rootViewController = viewController
window.makeKeyAndVisible()
window.addDeviceButtons()
PlaygroundPage.current.liveView = window

