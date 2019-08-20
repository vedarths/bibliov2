//
//  ViewManager.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/20/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit

public class ViewManager {
    var defaultView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    static let shared = ViewManager()
    
    public func showView(view: UIView) {
        defaultView = UIView(frame: UIScreen.main.bounds)
        defaultView.backgroundColor = UIColor(red: 0, green:0, blue: 0, alpha: 0.5)
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityIndicator.center = defaultView.center
        defaultView.addSubview(activityIndicator)
        activityIndicator.stopAnimating()
        view.addSubview(defaultView)
    }
    
    public func hideDefaultView() {
        activityIndicator.stopAnimating()
        defaultView.removeFromSuperview()
    }
    
    public func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
}
