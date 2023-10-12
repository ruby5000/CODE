//
//  UILabel+Extention.swift
//  Brain Hack
//
//  Created by Darshan on 30/07/23.
//

import Foundation
import UIKit

@IBDesignable
class GradientLabel: UILabel {

    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) {
        didSet { setNeedsLayout() }
    }

    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1) {
        didSet { setNeedsLayout() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateTextColor()
    }

    private func updateTextColor() {
        let image = UIGraphicsImageRenderer(bounds: bounds).image { _ in
            let gradient = GradientView(frame: bounds)
            gradient.topColor = topColor
            gradient.bottomColor = bottomColor
            gradient.drawHierarchy(in: bounds, afterScreenUpdates: true)
        }

        textColor = UIColor(patternImage: image)
    }
}
