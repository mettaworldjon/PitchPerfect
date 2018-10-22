//
//  ContentMode.swift
//  PitchPerfect
//
//  Created by Jonathan Dowdell on 10/21/18.
//  Copyright © 2018 Jonathan Dowdell. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setContentMode(mode:UIView.ContentMode, imageView:[UIImageView?]) {
        for imageToAdjust in imageView {
            if let safeImage = imageToAdjust {
                safeImage.contentMode = mode
            }
        }
    }
    
}
