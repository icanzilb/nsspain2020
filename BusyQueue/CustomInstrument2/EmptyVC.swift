//
//  EmptyVC.swift
//  CustomInstrument2
//
//  Created by Marin Todorov on 11/5/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import UIKit

class EmptyVC: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = UIColor.blue
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
    
    @objc func didTap() {
        view.window!.rootViewController = storyboard?.instantiateViewController(withIdentifier: "VC")
    }
}
