
import Foundation
import UIKit

func buttonSetup(element: UILabel, CornerRadius: CGFloat, ShadowColor: UIColor, ShadowRadius: CGFloat, ShadowOpacity: CGFloat,
                 ShadowOffset: CGSize, ShadowOffsetWidth: CGFloat, ShadowOffsetHeight: CGFloat) {
    element.layer.cornerRadius = CornerRadius
    element.layer.shadowColor = ShadowColor.cgColor
    element.layer.shadowRadius = ShadowRadius
    element.layer.shadowOpacity = Float(ShadowOpacity)
    element.layer.shadowOffset = CGSize(width: ShadowOffsetWidth, height: ShadowOffsetHeight)
}
