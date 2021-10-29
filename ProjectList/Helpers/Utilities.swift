//
//  Utilities.swift
//
//
//  Created by Apple on 01/10/2021.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = #colorLiteral(red: 0.2777348757, green: 0.4748598337, blue: 0.9792121053, alpha: 1)
        button.layer.cornerRadius = 15
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    static func styleTitleLabel(_ label:UILabel) {
        label.font = UIFont.systemFont(ofSize: 29, weight: .bold)
        label.textColor = .black
    }
    
    static func styleDeleteButton(_ button:UIButton) {
        let plusImage = UIImage(systemName: "minus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .medium))
        button.setImage(plusImage, for: .normal)
        button.tintColor = .systemRed
        button.backgroundColor =  #colorLiteral(red: 0.9010927081, green: 0.9243850708, blue: 0.9953681827, alpha: 1)
        button.layer.cornerRadius = 15
    }
    
}

