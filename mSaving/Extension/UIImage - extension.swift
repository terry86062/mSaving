//
//  UIImage - extension.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/30.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

enum ImageAsset: String {
    
    // Category Icon
    case cutleryForkKnife
    case beverageMilkShake
    
    case car
    case trainSideView01
    
    case home
    case waterTap
    case contact
    case footprint
    
    case eightNote
    case dumbbells
    case aeroplane
    
    case shoppingBag
    case menTShirt
    
    case bookOpen
    case color
    
    case pill
    
    case gift
    
    case stockExchange
    case addShield
    
    case cash

}

extension UIImage {

    func resizeImage(targetSize: CGSize = CGSize(width: 36, height: 36)) -> UIImage {

        let size = self.size

        let widthRatio = targetSize.width / size.width

        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle

        var newSize: CGSize

        if widthRatio > heightRatio {

            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)

        } else {

            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)

        }

        // This is the rect that we've calculated out and this is what is actually used below

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)

        self.draw(in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return newImage!

    }

    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

}
