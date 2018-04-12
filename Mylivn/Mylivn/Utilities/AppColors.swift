//
//  AppColors.swift
//  Mylivn
//
//  Created by Karthik Kumar on 05/04/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import UIKit


enum AppColors: Int {
    case theme
    case none
    
    func getColor() -> UIColor {
        switch self {
        case .theme:
            return UIColor(red: 33/255, green: 33/255, blue: 44/255, alpha: 0.7)
        default:
            return UIColor.white
        }
    }
}
