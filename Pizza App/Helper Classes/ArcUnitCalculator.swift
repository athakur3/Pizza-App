//
//  ArcUnitCalculator.swift
//  Pizza App
//
//  Created by Akshansh Thakur on 03/08/20.
//  Copyright © 2020 Akshansh Thakur. All rights reserved.
//

import Foundation
import UIKit

class ArcUnitCalculator {
    
    var startPoint = CGPoint.zero
    var endPoint = CGPoint.zero
    var bezierPoint = CGPoint.zero
    var offsetFactor = CGFloat.zero
    var controlPointDistance = CGFloat.zero
    
    func getLineOneStartPoint(viewBounds: CGRect) -> CGPoint {
        return startPoint
    }
    
    func getJunctionPoint(viewBounds: CGRect) -> CGPoint {
        return bezierPoint
    }

    func getLineTwoEndPoint(viewBounds: CGRect) -> CGPoint {
        return endPoint
    }
    
    func startPointXOnArc(viewBounds: CGRect) -> CGFloat {
        return (viewBounds.width / 2.0) - offsetFactor * (viewBounds.width / 2.0)
    }
    
    func endPointXOnArc(viewBounds: CGRect) -> CGFloat {
        return (viewBounds.width / 2.0) + offsetFactor * (viewBounds.width / 2.0)
    }
    
    func lengthOfLines(viewBounds: CGRect) -> CGFloat {
        let pointOne = getLineOneStartPoint(viewBounds: viewBounds)
        let pointTwo = getJunctionPoint(viewBounds: viewBounds)
        let xDist = pointTwo.x - pointOne.x
        let yDist = pointTwo.y - pointOne.y
        let distance = CGFloat(sqrt(xDist * xDist + yDist * yDist))
        return distance
    }
    
    func centerOfLineOne(viewBounds: CGRect) -> CGPoint {
        let pointOne = getLineOneStartPoint(viewBounds: viewBounds)
        let pointTwo = getJunctionPoint(viewBounds: viewBounds)
        let centerX = (pointTwo.x + pointOne.x) / 2.0
        let centerY = (pointTwo.y + pointOne.y) / 2.0
        return CGPoint(x: centerX, y: centerY)
    }
    
    func centerOfLineTwo(viewBounds: CGRect) -> CGPoint {
        let pointOne = getJunctionPoint(viewBounds: viewBounds)
        let pointTwo = getLineTwoEndPoint(viewBounds: viewBounds)
        let centerX = (pointTwo.x + pointOne.x) / 2.0
        let centerY = (pointTwo.y + pointOne.y) / 2.0
        return CGPoint(x: centerX, y: centerY)
    }
    
    func interpolatedPointOnLineOneForStartPoint(viewBounds: CGRect) -> CGPoint {
        let lineOneCenter = centerOfLineOne(viewBounds: viewBounds)
        let offsetX = lineOneCenter.x - (offsetFactor / 2.0) * (viewBounds.width / 2.0)
        let offsetY = lineOneCenter.y + (offsetFactor / 2.0) * (controlPointDistance / 2.0)
        return CGPoint(x: offsetX, y: offsetY)
    }
    
    func interpolatedPointOnLineTwoForStartPoint(viewBounds: CGRect) -> CGPoint {
        let lineTwoCenter = centerOfLineTwo(viewBounds: viewBounds)
        let offsetX = lineTwoCenter.x - (offsetFactor / 2.0) * (viewBounds.width / 2.0)
        let offsetY = lineTwoCenter.y - (offsetFactor / 2.0) * (controlPointDistance / 2.0)
        return CGPoint(x: offsetX, y: offsetY)
    }
    
    func startPointYOnArc(viewBounds: CGRect) -> CGFloat {
        let pointXOneLine = startPointXOnArc(viewBounds: viewBounds)
        // y = mx + b
        let pointOne = interpolatedPointOnLineOneForStartPoint(viewBounds: viewBounds)
        let pointTwo = interpolatedPointOnLineTwoForStartPoint(viewBounds: viewBounds)
        
        let slope = (pointTwo.y - pointOne.y) / (pointTwo.x - pointOne.x)
        // Every Point on line satisfies y = mx + b.. even (0, 30)
        // y = mx + b (interpolatedPointOnLineOneForStartPoint)
        // y = slope * x + b
        
        // interpolatedPointOnLineTwoForStartPoint.y = slope * interpolatedPointOnLineTwoForStartPoint.x + b
        
        let constantValue: CGFloat = pointOne.y - slope * pointOne.x
        return slope * pointXOneLine + constantValue
    }
    
    func interpolatedPointOnLineOneForEndPoint(viewBounds: CGRect) -> CGPoint {
        let lineOneCenter = centerOfLineOne(viewBounds: viewBounds)
        let offsetX = lineOneCenter.x + (offsetFactor / 2.0) * (viewBounds.width / 2.0)
        let offsetY = lineOneCenter.y - (offsetFactor / 2.0) * (controlPointDistance / 2.0)
        return CGPoint(x: offsetX, y: offsetY)
    }
    
    func interpolatedPointOnLineTwoForEndPoint(viewBounds: CGRect) -> CGPoint {
        let lineTwoCenter = centerOfLineTwo(viewBounds: viewBounds)
        let offsetX = lineTwoCenter.x + (offsetFactor / 2.0) * (viewBounds.width / 2.0)
        let offsetY = lineTwoCenter.y + (offsetFactor / 2.0) * (controlPointDistance / 2.0)
        return CGPoint(x: offsetX, y: offsetY)
    }
    
    func endPointYOnArc(viewBounds: CGRect) -> CGFloat {
        let pointXOneLine = endPointXOnArc(viewBounds: viewBounds)
        // y = mx + b
        let pointOne = interpolatedPointOnLineOneForEndPoint(viewBounds: viewBounds)
        let pointTwo = interpolatedPointOnLineTwoForEndPoint(viewBounds: viewBounds)
        
        let slope = (pointTwo.y - pointOne.y) / (pointTwo.x - pointOne.x)
        // Every Point on line satisfies y = mx + b.. even (0, 30)
        // y = mx + b (interpolatedPointOnLineOneForStartPoint)
        // y = slope * x + b
        
        // interpolatedPointOnLineTwoForStartPoint.y = slope * interpolatedPointOnLineTwoForStartPoint.x + b
        
        let constantValue: CGFloat = pointOne.y - slope * pointOne.x
        return slope * pointXOneLine + constantValue
    }
    
    func pointYOnArc(viewBounds: CGRect) -> CGFloat {
        let pointXOneLine = pointXOnArc(viewBounds: viewBounds)
        // y = mx + b
        let pointOne = interpolatedPointOnLineOneForStartPoint(viewBounds: viewBounds)
        let pointTwo = interpolatedPointOnLineTwoForStartPoint(viewBounds: viewBounds)
        
        let slope = (pointTwo.y - pointOne.y) / (pointTwo.x - pointOne.x)
        // Every Point on line satisfies y = mx + b.. even (0, 30)
        // y = mx + b (interpolatedPointOnLineOneForStartPoint)
        // y = slope * x + b
        
        // interpolatedPointOnLineTwoForStartPoint.y = slope * interpolatedPointOnLineTwoForStartPoint.x + b
        
        let constantValue: CGFloat = pointOne.y - slope * pointOne.x
        return slope * pointXOneLine + constantValue
    }
    
    func pointXOnArc(viewBounds: CGRect) -> CGFloat {
        return (viewBounds.width / 2.0) - offsetFactor * (viewBounds.width / 2.0)
    }
    
}
