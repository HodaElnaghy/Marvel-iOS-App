//
//  UIView+Parallelogram.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/26/24.
//

import UIKit

import UIKit

class ParallelogramView: UIView {

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        // Set fill color
        UIColor.white.setFill()

        // Create a path for the parallelogram on the right side
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 11, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width - 11, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.close()

        // Add the path to the context and fill it
        context?.addPath(path.cgPath)
        context?.fillPath()
    }
}
