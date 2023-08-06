//
//  MyButton.swift
//  Calculator App
//
//  Created by Cansu Aktas on 2023-08-06.
//

import Foundation
import UIKit
@IBDesignable class CalculatorButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func equalizeHeightAndWidth() {
        if(frame.size.height > frame.width) {
            frame.size.height = frame.width
            
        } else {
            frame.size.width = frame.height
        }
    }
    
    func updateCornerRadius() {
        if(rounded) {equalizeHeightAndWidth()}
        else {frame.size.height = frame.width / 2}
        layer.cornerRadius = rounded ? frame.size.width / 2 : frame.size.height / 2
    }
}

