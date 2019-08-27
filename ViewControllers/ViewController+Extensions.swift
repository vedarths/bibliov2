//
//  ViewController+Extensions.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/12/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

extension UIViewController {
    
    
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func checkReachable() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        
        if (isNetworkReachable(with: flags)) {
            print(flags)
            if flags.contains(.isWWAN) {
                //showInfo(withMessage: "Connected to Internet Via Cellular data")
                return true
            }
            //showInfo(withMessage: "Connected to Internet Via Wifi")
            return true
        } else if (!isNetworkReachable(with: flags)) {
            showError(message: "Please ensure Network connectivity!")
            print(flags)
            return false
        }
        return false
    }
    
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    func showInfo(withTitle: String = "Info", withMessage: String, action: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in
                action?()
            }))
            self.present(ac, animated: true)
        }
    }
    
    func showError(message: String, dismissButtonTitle: String = "OK") {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default) { (action: UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
        })
        self.present(controller, animated: true, completion: nil)
    }
    
    public func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    func fetchPerson(username: String) -> Person? {
        var person: Person? = nil
        if (username != "") {
            do {
                person = try DataController.getInstance().fetchPerson(id: username, entityName: "Person")!
            } catch {
                fatalError("The fetch could not be performed: \(error.localizedDescription)")
            }
        }
        return person
    }
}
