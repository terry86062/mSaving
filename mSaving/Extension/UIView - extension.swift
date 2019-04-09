//
//  UIView - extension.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/3/31.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

@IBDesignable

extension UIView {

    @IBInspectable var msShadowOffset: CGSize {

        get {

            return layer.shadowOffset

        }

        set {

            layer.shadowOffset = newValue

        }

    }

    @IBInspectable var msShadowOpacity: Float {

        get {

            return layer.shadowOpacity

        }

        set {

            layer.shadowOpacity = newValue

        }

    }

    @IBInspectable var msShadowRadius: CGFloat {

        get {

            return layer.shadowRadius

        }

        set {

            layer.shadowRadius = newValue

        }

    }

    @IBInspectable var msShadowColor: UIColor? {

        get {

            guard let shadowColor = layer.shadowColor else {

                return nil

            }

            return UIColor(cgColor: shadowColor)

        }

        set {

            layer.shadowColor = newValue?.cgColor

        }

    }

    @IBInspectable var msBorderColor: UIColor? {

        get {

            guard let borderColor = layer.borderColor else {

                return nil

            }

            return UIColor(cgColor: borderColor)

        }

        set {

            layer.borderColor = newValue?.cgColor

        }

    }

    @IBInspectable var msBorderWidth: CGFloat {

        get {

            return layer.borderWidth

        }

        set {

            layer.borderWidth = newValue

        }

    }

    @IBInspectable var msCornerRadius: CGFloat {

        get {

            return layer.cornerRadius

        }

        set {

            layer.cornerRadius = newValue

        }

    }

    @IBInspectable var msZPosition: CGFloat {

        get {

            return layer.zPosition

        }

        set {

            layer.zPosition = newValue

        }

    }

}
