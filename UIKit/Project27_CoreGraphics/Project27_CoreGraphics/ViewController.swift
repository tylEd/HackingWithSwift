//
//  ViewController.swift
//  Project27_CoreGraphics
//
//  Created by Tyler Edwards on 9/20/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
            
        case 1:
            drawCircle()
            
        case 2:
            drawCheckerboard()
            
        case 3:
            drawRotatedSquares()
            
        case 4:
            drawLines()
            
        case 5:
            drawImagesAndText()
            
        case 6:
            drawEmoji()
            
        case 7:
            drawTWIN()
            
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rect = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rect)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rect = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rect)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    //if (row + col) % 2 == 0 {
                    if (row + col).isMultiple(of: 2) {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key:Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle,
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = image
    }
    
    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            // Head
            let head = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 16, dy: 16)
            ctx.cgContext.addEllipse(in: head)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            // Eyes
            let eyeSize = 50
            let eyeX = 65
            let eyeY = -100
            let leftEye = CGRect(x: -eyeX - (eyeSize / 2), y: eyeY, width: eyeSize, height: eyeSize)
            let rightEye = CGRect(x: eyeX - (eyeSize / 2), y: eyeY, width: eyeSize, height: eyeSize)
            ctx.cgContext.translateBy(x: 256, y: 256)
            ctx.cgContext.addEllipse(in: leftEye)
            ctx.cgContext.addEllipse(in: rightEye)
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.fillPath()
            
            // Mouth
            ctx.cgContext.addArc(center: .zero, radius: 150, startAngle: .pi - 0.25, endAngle: (.pi * 2) + 0.25, clockwise: true)
            ctx.cgContext.setLineCap(.round)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawTWIN() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let ctx = ctx.cgContext
            
            let charSize: CGFloat = 512 / 4 // 4 -> TWIN Length
            let charSpace: CGFloat = 16
            let charWidth: CGFloat = charSize - charSpace
            let charHeight: CGFloat = 128
            
            // T
            ctx.translateBy(x: 0, y: 192) // The top left of the current character
            
            ctx.move(to: CGPoint(x: 0, y: 0))
            ctx.addLine(to: CGPoint(x: charWidth, y: 0))
            
            ctx.move(to: CGPoint(x: charWidth / 2, y: 0))
            ctx.addLine(to: CGPoint(x: charWidth / 2, y: charHeight))
            
            // W
            ctx.translateBy(x: charSize, y: 0) // The top left of the current character
            
            let segmentSize: CGFloat = charWidth / 4
            ctx.move(to: CGPoint(x: 0, y: 0))
            ctx.addLine(to: CGPoint(x: 1 * segmentSize, y: charHeight))
            ctx.addLine(to: CGPoint(x: 2 * segmentSize, y: 0))
            ctx.addLine(to: CGPoint(x: 3 * segmentSize, y: charHeight))
            ctx.addLine(to: CGPoint(x: charWidth, y: 0))
            
            // I
            ctx.translateBy(x: charSize, y: 0) // The top left of the current character
            
            ctx.move(to: CGPoint(x: 0, y: 0))
            ctx.addLine(to: CGPoint(x: charWidth, y: 0))
            
            ctx.move(to: CGPoint(x: charWidth / 2, y: 0))
            ctx.addLine(to: CGPoint(x: charWidth / 2, y: charHeight))
            
            ctx.move(to: CGPoint(x: 0, y: charHeight))
            ctx.addLine(to: CGPoint(x: charWidth, y: charHeight))
            
            // N
            ctx.translateBy(x: charSize, y: 0) // The top left of the current character
            
            ctx.move(to: CGPoint(x: 0, y: 0))
            ctx.addLine(to: CGPoint(x: 0, y: charHeight))
            
            ctx.move(to: CGPoint(x: 0, y: 0))
            ctx.addLine(to: CGPoint(x: charWidth, y: charHeight))

            ctx.move(to: CGPoint(x: charWidth, y: 0))
            ctx.addLine(to: CGPoint(x: charWidth, y: charHeight))

            // Draw
            ctx.strokePath()
        }
        
        imageView.image = image
    }
    
}
