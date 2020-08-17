//
//  BezierView.swift
//  Pizza App
//
//  Created by Akshansh Thakur on 03/08/20.
//  Copyright © 2020 Akshansh Thakur. All rights reserved.
//

import Foundation
import UIKit

class BezierView: UIView {
    
    func setup() {
        
        let bezierPath = UIBezierPath()
        bezierPath.getArc(viewBounds: bounds)
        layer.shadowPath = bezierPath.cgPath
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        layer.shadowRadius = 8
        layer.masksToBounds = false
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = createRoundedPath().cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        layer.addSublayer(shapeLayer)
        
    }
    
    func getRedArcLayer() {
        let redArcLayer = CAShapeLayer()
        
        redArcLayer.path = createRedArcPath().cgPath
        redArcLayer.strokeColor = UIColor.softRed.cgColor
        redArcLayer.lineWidth = 4.0
        redArcLayer.fillColor = UIColor.white.cgColor
        
        layer.addSublayer(redArcLayer)
    }
    
    var slierArc: CAShapeLayer = CAShapeLayer()
    
    var sliderArcBackUp: CAShapeLayer {
        get { return slierArc }
        set {
            slierArc = newValue
        }
    }
    
    var slierArcMask: CAShapeLayer = CAShapeLayer()
    
    var sliderArcMaskBackUp: CAShapeLayer {
        get { return slierArcMask }
        set {
            slierArcMask = newValue
        }
    }
    
    func addSliderArcLayer() {
        let sliderArcLayer = CAShapeLayer()
        
        sliderArcLayer.path = createSliderArcPath().cgPath
        sliderArcLayer.cornerRadius = 7.0
        sliderArcLayer.lineWidth = 14.0
        sliderArcLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        sliderArcLayer.fillColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        
        sliderArcBackUp = sliderArcLayer
        sliderArcLayer.addSublayer(getPartialSliderArcLayer(x: 8.0, y: 8.0))
        layer.addSublayer(sliderArcLayer)
    }
    
    func getPartialSliderArcLayer(x: CGFloat, y: CGFloat) -> CAShapeLayer {
        let sliderArcLayer = CAShapeLayer()
        
        sliderArcLayer.path = createPartialPathForSliderArcPath(x: x, y: y).cgPath
        sliderArcLayer.lineWidth = 14.0
        sliderArcLayer.strokeColor = UIColor.softRed.cgColor
        sliderArcLayer.fillColor = UIColor.clear.cgColor
        
        sliderArcMaskBackUp = sliderArcLayer
        return sliderArcLayer
    }
    
    func resetPath() {
        let xOffset: CGFloat = 8.0
        let yOffset: CGFloat = bounds.maxY / 2.0
        
        sliderArcMaskBackUp.path = createPartialPathForSliderArcPath(x: xOffset, y: yOffset - 7.0).cgPath
    }
    
    func updatePath(x: CGFloat, y: CGFloat) {
        
        sliderArcMaskBackUp.path = createPartialPathForSliderArcPath(x: x, y: y).cgPath
    }
    
    func createRoundedPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        path.getSlightArc(viewBounds: bounds)
        return path
        
    }
    
    func createRedArcPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        path.getRedArc(viewBounds: bounds)
        return path
        
    }
    
    func createSliderArcPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        path.getCurvedSlider(viewBounds: bounds)
        return path
        
    }
    
    func createSliderArcPathLine(x: CGFloat, y: CGFloat) -> UIBezierPath {
        
        let path = UIBezierPath()
        path.getCurvedSliderPath(viewBounds: bounds, x: x, y: y)
        return path
        
    }
    
    func createPartialPathForSliderArcPath(x: CGFloat, y: CGFloat) -> UIBezierPath {
        
        let path = UIBezierPath()
        path.getCurvedSliderFor(bounds: bounds, withX: x, withY: y)
        return path
        
    }
    
}
