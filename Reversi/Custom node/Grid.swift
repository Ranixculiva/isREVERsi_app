//
//  Grid.swift
//  Reversi
//
//  Created by john gospai on 2018/11/11.
//  Copyright © 2018 john gospai. All rights reserved.
//

import SpriteKit
class Grid:SKSpriteNode {
    var rows:Int!
    var cols:Int!
    var blockSize:CGFloat!
    var lineWidth: CGFloat = 6.0
    deinit {
        print("grid deinit")
    }
    convenience init?(color: SKColor,blockSize:CGFloat,rows:Int,cols:Int,lineWidth: CGFloat) {
        
        self.init(texture: SKTexture(), color:SKColor.clear, size: CGSize())
        self.lineWidth = lineWidth
        guard let texture = Grid.gridTexture(blockSize: blockSize,rows: rows, cols:cols,color: color,lineWidth: lineWidth) else {
            return nil
        }
        self.texture = texture
        self.size = texture.size()
        ////m
        self.color = color
        ////m
        self.blockSize = blockSize
        self.rows = rows
        self.cols = cols
        self.isUserInteractionEnabled = false
    }
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in:self)
            let node = atPoint(position)
            if node == self{
                let x = size.width / 2 + position.x
                let y = size.height / 2 - position.y
                touchedCol = Int(floor(x / blockSize))
                touchedRow = Int(floor(y / blockSize))
                print("\(touchedRow!) \(touchedCol!)")
                if let scene = self.parent as? GameScene{
                    if let row = touchedRow, let col = touchedCol{
                        scene.touchDownOnGrid(row: row, col: col)
                        self.touchedRow = nil
                        self.touchedCol = nil
                    }
                }
            }
        }
    }*/
    class func gridTexture(blockSize:CGFloat,rows:Int,cols:Int,color: SKColor,lineWidth: CGFloat) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(cols)*blockSize+lineWidth, height: CGFloat(rows)*blockSize+lineWidth)
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let bezierPath = UIBezierPath()
        let offset:CGFloat = lineWidth / 2.0
        // Draw vertical lines
        for i in 0...cols {
            let x = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: x, y: 0))
            bezierPath.addLine(to: CGPoint(x: x, y: size.height))
        }
        // Draw horizontal lines
        for i in 0...rows {
            let y = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: 0, y: y))
            bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        }
        color.setStroke()
        bezierPath.lineWidth = lineWidth
        bezierPath.stroke()
        context.addPath(bezierPath.cgPath)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image!)
    }
    
    func gridPositionToPosition(row:Int, col:Int) -> CGPoint {
        let offset = blockSize / 2.0 + 0.5
        let xDifference = (blockSize * CGFloat(cols)) / 2.0
        let xIni = CGFloat(col) * blockSize
        let x =  xIni - xDifference + offset
        let y = CGFloat(rows - row - 1) * blockSize - (blockSize * CGFloat(rows)) / 2.0 + offset
        return CGPoint(x:x, y:y)
    }
    func positionToGridPosition(position: CGPoint) -> chessBoardPos?{
        var gridPos: chessBoardPos?
        let node = atPoint(position)
        if node == self{
            
            let x = size.width / 2 + position.x
            let y = size.height / 2 - position.y
            if let cols = self.cols , let rows = self.rows{
                var col = Int(floor( CGFloat(cols) * x / size.width))
                var row = Int(floor( CGFloat(rows) * y / size.height))
                //if it's just on the boundary, it will cause some problem.
                col = (col == cols) ? cols - 1 : col
                row = (row == rows) ? rows - 1 : row
                gridPos = chessBoardPos(row: row, col: col)
               return gridPos
            }
        }
        return nil
    }
    func setGridColor(color: SKColor){
        if let texture = Grid.gridTexture(blockSize: blockSize,rows: rows, cols:cols,color: color,lineWidth: lineWidth) {
            self.texture = texture
            self.color = color
        }
    }
}

