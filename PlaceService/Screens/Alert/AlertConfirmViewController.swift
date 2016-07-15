//
//  AlertConfirmViewController.swift
//  PlaceService
//
//  Created by Dung Vu on 7/15/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import UIKit

protocol AlertConfirmDelegate:class {
    func alertFindRoute(_ alert: UIViewController)
    func alertCancel(_ alert: UIViewController)
    
}

class AlertSegue: UIStoryboardSegue {
    
    private lazy var transition = AnimationAlertDelegate()
    override func perform() {
        let sourceController = self.sourceViewController as? ViewController
        guard let destinationController = self.destinationViewController as? AlertConfirmViewController else {
            return
        }
        
        destinationController.delegate = sourceController
        destinationController.modalPresentationStyle = .custom
        destinationController.transitioningDelegate = sourceController?.transition
        sourceController?.present(destinationController, animated: true, completion: nil)
        
    }
}


class AlertConfirmViewController: UIViewController {
    
    weak var delegate: AlertConfirmDelegate?
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.alpha = 0
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 3
        containerView.layer.borderColor = #colorLiteral(red: 0.2409129441, green: 0.15413481, blue: 0.04118768871, alpha: 1).cgColor
        containerView.layer.masksToBounds = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Animation appear for Alert
        containerView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.containerView.transform = CGAffineTransform.identity
            self?.containerView.alpha = 1
            }, completion: nil)
        
        
        
    }
    
    @IBAction func tapByFindRoute(_ sender: AnyObject) {
        self.delegate?.alertFindRoute(self)
    }
    
    @IBAction func tapByCancel(_ sender: AnyObject) {
        self.delegate?.alertCancel(self)
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Animation Disappear for Alert
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {[weak self] in
            self?.containerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }, completion: nil)
    }
    
    deinit {
        
    }
}
