//
//  Snake.swift
//  Snake
//
//  Created by keith on 2017/5/3.
//  Copyright © 2017年 keith. All rights reserved.
//

import UIKit
import Foundation

enum SnakeDirection {
    case up
    case left
    case down
    case right
}

typealias moveFinishBlock = () -> ()

class Snake: NSObject {
    var nodes : NSMutableArray!
    var direction : SnakeDirection!  
    var timer : Timer!
    var speed : NSInteger!
    var lastPoint : CGPoint!
    var moveFinishBlock : moveFinishBlock!
    
    func snake() -> Snake {
        let snake = Snake()
        snake.initBody()
        return snake;
    }
    
    func initBody() {
        nodes = NSMutableArray()
        speed = 0
        for i in 1...4 {
            let point:CGPoint! = CGPoint(x: 10*i+5, y: 5)
            nodes.add(Node.nodeWithCoordinate(coordinate: point))
        }
        direction = SnakeDirection.down
    }
    
    func levelUpWithSpeed(s:NSInteger) {
        speed = s
        pause()
        start()
    }
    
    func growUp() {
        let node : Node = Node.nodeWithCoordinate(coordinate: lastPoint)
        nodes.add(node)
    }
    
    func start() {
        let s = Double(speed)
        let time : TimeInterval! = 0.2 - 0.02 * s
        timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(move), userInfo: nil, repeats: true)
    }
    
    func pause() {
        timer.invalidate()
        timer = nil
    }
    
    func reset() {
        initBody()
        speed = 0
        start()
    }
    
    func move() {
        let node : Node! = nodes.lastObject as! Node
        lastPoint = node.coordinate
        let c : Node! = nodes.firstObject as! Node
        var center : CGPoint! = c.coordinate
        if direction == SnakeDirection.up  {
            center.y -= 10;
        }
        if direction == SnakeDirection.left {
            center.x -= 10;
        }
        if direction == SnakeDirection.down {
            center.y += 10;
        }
        if direction == SnakeDirection.right {
            center.x += 10;
        }
        node.coordinate = center
        nodes.remove(node)
        nodes.insert(node, at: 0)
        
        moveFinishBlock()
    }
    
    func setMoveDirection(dir:SnakeDirection!) {
        if dir == SnakeDirection.down || dir == SnakeDirection.up {
            if direction == SnakeDirection.down || direction == SnakeDirection.up {
                return
            }
        } else if direction == SnakeDirection.left || direction == SnakeDirection.right {
            return
        }
        direction = dir
    }
}
