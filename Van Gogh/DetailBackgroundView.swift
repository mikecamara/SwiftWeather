//
//  DetailBackgroundView.swift
//  Van Gogh
//
//  Created by Mike Camara on 22/10/2015.
//  Copyright © 2015 Mike Camara. All rights reserved.
//

import UIKit

class DetailBackgroundView: UIView {

        override func drawRect(rect: CGRect) {
        // Drawing code
            
            //// Color Declarations
            var lightPurple: UIColor = UIColor(red: 0.377, green: 0.075, blue: 0.778, alpha: 1.000)
            var darkPurple: UIColor = UIColor(red: 0.060, green: 0.036, blue: 0.202, alpha: 1.000)
            
            let context = UIGraphicsGetCurrentContext()
            
            //// Gradient Declarations
            let purpleGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [lightPurple.CGColor, darkPurple.CGColor], [0, 1])
            
            //// Background Drawing
            let backgroundPath = UIBezierPath(rect: CGRectMake(0, 0, self.frame.width, self.frame.height))
            CGContextSaveGState(context)
            backgroundPath.addClip()
            CGContextDrawLinearGradient(context, purpleGradient,
                CGPointMake(160, 0),
                CGPointMake(160, 568),
                CGGradientDrawingOptions.DrawsAfterEndLocation)
            CGContextRestoreGState(context)
            
            //// Sun Path
            
            let circleOrigin = CGPointMake(0, 0.80 * self.frame.height)
            let circleSize = CGSizeMake(self.frame.width, 0.65 * self.frame.height)
            
            let pathStrokeColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.390)
            let pathFillColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.100)
            
            
            //// Sun Drawing
            var sunPath = UIBezierPath(ovalInRect: CGRectMake(circleOrigin.x, circleOrigin.y, circleSize.width, circleSize.height))
            pathFillColor.setFill()
            sunPath.fill()
            pathStrokeColor.setStroke()
            sunPath.lineWidth = 1
            CGContextSaveGState(context)
            CGContextSetLineDash(context, 0, [2, 2], 2)
            sunPath.stroke()
            CGContextRestoreGState(context)
    }
    

}
