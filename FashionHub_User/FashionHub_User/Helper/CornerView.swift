import UIKit

@IBDesignable
class CornerView: UIView {
  
  @IBInspectable var leftTopRadius : CGFloat = 0{
    didSet{
      self.applyMask()
    }
  }
  @IBInspectable var rightTopRadius : CGFloat = 0{
    didSet{
      self.applyMask()
    }
  }
  @IBInspectable var rightBottomRadius : CGFloat = 0{
    didSet{
      self.applyMask()
    }
  }
  
  @IBInspectable var leftBottomRadius : CGFloat = 0{
    didSet{
      self.applyMask()
    }
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    self.applyMask()
  }
  func applyMask() {
    let shapeLayer = CAShapeLayer(layer: self.layer)
    shapeLayer.path = self.pathForCornersRounded(rect:self.bounds).cgPath
    shapeLayer.frame = self.bounds
    shapeLayer.masksToBounds = true
    self.layer.mask = shapeLayer
  }
  func pathForCornersRounded(rect:CGRect) ->UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0 + leftTopRadius , y: 0))
    path.addLine(to: CGPoint(x: rect.size.width - rightTopRadius , y: 0))
    path.addQuadCurve(to: CGPoint(x: rect.size.width , y: rightTopRadius), controlPoint: CGPoint(x: rect.size.width, y: 0))
    path.addLine(to: CGPoint(x: rect.size.width , y: rect.size.height - rightBottomRadius))
    path.addQuadCurve(to: CGPoint(x: rect.size.width - rightBottomRadius , y: rect.size.height), controlPoint: CGPoint(x: rect.size.width, y: rect.size.height))
    path.addLine(to: CGPoint(x: leftBottomRadius , y: rect.size.height))
    path.addQuadCurve(to: CGPoint(x: 0 , y: rect.size.height - leftBottomRadius), controlPoint: CGPoint(x: 0, y: rect.size.height))
    path.addLine(to: CGPoint(x: 0 , y: leftTopRadius))
    path.addQuadCurve(to: CGPoint(x: 0 + leftTopRadius , y: 0), controlPoint: CGPoint(x: 0, y: 0))
    path.close()
    
    return path
  }
}
extension UIView {
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.2
    layer.shadowOffset = .zero
    layer.shadowRadius = 10
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
