//
//  UIBezierPath+Extensions.swift
//  Pizza App
//
//  Created by Akshansh Thakur on 03/08/20.
//  Copyright © 2020 Akshansh Thakur. All rights reserved.
//

import Foundation
import UIKit

extension UIBezierPath {
    
    func getSlightArc(viewBounds: CGRect, topOffset: CGFloat = 30.0) {
        
        move(to: CGPoint(x: 0.0, y: viewBounds.height))
        
        addLine(
            to: CGPoint(
                x: 0.0,
                y: topOffset
        ))
        
        addQuadCurve(
            to: CGPoint(
                x: viewBounds.width,
                y: topOffset
            ),
            controlPoint: CGPoint(
                x: viewBounds.width / 2.0,
                y: -topOffset
        ))
        
        addLine(
            to: CGPoint(
                x: viewBounds.width,
                y: viewBounds.height
        ))
        
        close()
        
    }
    
    func getArc(viewBounds: CGRect, topOffset: CGFloat = 30.0) {
        
        move(to: CGPoint(x: 0.0, y: topOffset))
        
        addQuadCurve(
            to: CGPoint(
                x: viewBounds.width,
                y: topOffset
            ),
            controlPoint: CGPoint(
                x: viewBounds.width / 2.0,
                y: -topOffset
        ))
        
    }
    
    func getRedArc(viewBounds: CGRect, topOffset: CGFloat = 30.0) {
        
        let calculator = ArcUnitCalculator()
        
        calculator.startPoint = CGPoint(x: 0.0, y: 30.0)
        calculator.endPoint = CGPoint(x: viewBounds.width, y: 30.0)
        calculator.bezierPoint = CGPoint(x: viewBounds.width / 2.0, y: -30.0)
        calculator.offsetFactor = 0.3
        calculator.controlPointDistance = 60.0
        
        let initialOffsetX = calculator.startPointXOnArc(viewBounds: viewBounds)
        let initialOffsetY = calculator.startPointYOnArc(viewBounds: viewBounds) + 2.0

        let finalOffsetX = calculator.endPointXOnArc(viewBounds: viewBounds)
        let finalOffsetY = calculator.endPointYOnArc(viewBounds: viewBounds) + 2.0

        move(to: CGPoint(x: initialOffsetX, y: initialOffsetY))
        
        addQuadCurve(
            to: CGPoint(
                x: finalOffsetX,
                y: finalOffsetY
            ),
            controlPoint: CGPoint(
                x: (finalOffsetX + initialOffsetX) / 2.0,
                y: -initialOffsetY
        ))
        
    }
    
    func getCurvedSlider(viewBounds: CGRect) {
        
        let xOffset: CGFloat = 8.0
        let yOffset: CGFloat = viewBounds.maxY / 2.0
        
//        var arcDelta: CGFloat {
//            return CGFloat(
//                (
//                    (sqrt(2 * (bottomOffset * bottomOffset)) + radius)
//                        /
//                        sqrt(2.0))
//                    - bottomOffset
//            )
//        }
        
        move(to: CGPoint(x: xOffset, y: yOffset - 7.0))
        
        addLine(to: CGPoint(x: viewBounds.maxX - xOffset, y: yOffset - 7.0))
        
//        addArc(withCenter: CGPoint(x: bottomOffset + arcDelta, y: viewBounds.height - (bottomOffset + arcDelta)), radius: radius, startAngle: 3 * (CGFloat.pi / 4.0), endAngle: 5 * (CGFloat.pi / 4.0), clockwise: true)
//
//        let beforeFirstQuadCurvePoint = currentPoint
//
//        addQuadCurve(to: CGPoint(x: viewBounds.width - beforeFirstQuadCurvePoint.x, y: beforeFirstQuadCurvePoint.y), controlPoint: CGPoint(x: viewBounds.width / 2.0, y: -(viewBounds.height) + 16.0))
//
//        addArc(withCenter: CGPoint(x: viewBounds.width - (bottomOffset + arcDelta), y: viewBounds.height - (bottomOffset + arcDelta)), radius: radius, startAngle: 7 * (CGFloat.pi / 4.0), endAngle: 3 * (CGFloat.pi / 4.0), clockwise: true)
//
//        let beforeSecondQuadCurvePoint = currentPoint
//
//        addQuadCurve(to: CGPoint(x: viewBounds.width - beforeSecondQuadCurvePoint.x, y: beforeSecondQuadCurvePoint.y), controlPoint: CGPoint(x: viewBounds.width / 2.0, y: -(viewBounds.height) + 16.0 + radius * 2))
//
//        addArc(withCenter: CGPoint(x: bottomOffset + arcDelta, y: viewBounds.height - (bottomOffset + arcDelta)), radius: radius, startAngle: (CGFloat.pi / 4.0), endAngle: 3 * (CGFloat.pi / 4.0), clockwise: true)
        
    }
    
    func getCurvedSliderFor(bounds viewBounds: CGRect, withX x: CGFloat, withY y: CGFloat) {
        
        let xOffset: CGFloat = 8.0
        let yOffset: CGFloat = viewBounds.maxY / 2.0
                
        move(to: CGPoint(x: xOffset, y: yOffset - 7.0))
        addLine(to: CGPoint(x: x, y: yOffset - 7.0))
        
        //addQuadCurve(to: CGPoint(x: x, y: viewBounds.height - y), controlPoint: CGPoint(x: (x + bottomOffset) / 2.0, y: (viewBounds.height - y) / 2.0))
    }
    
    func getCurvedSliderPath(viewBounds: CGRect, x: CGFloat, y: CGFloat) {
        
        let bottomOffset: CGFloat = 8
        let radius: CGFloat = 10.0
        
        move(to: CGPoint(x: bottomOffset, y: viewBounds.height - bottomOffset))
        
        addQuadCurve(to: CGPoint(x: x, y: y), controlPoint: CGPoint(x: viewBounds.width / 2.0, y: -(viewBounds.height) + 16.0))
        
    }
    
}
