//
//  CFTool.swift
//  TangramKit
//
//  Created by apple on 16/11/19.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

class CFTool: NSObject {
    
    
    class func color(_ idx:Int)->UIColor
    {
        let colors:[[Int]] = [
            [0xED,0xED,0xED],   //0
            [0xFE,0xCE,0xA8],   //1
            [0xFF,0x84,0x7C],   //2
            [0xE8,0x4a,0x5f],   //3
            [0x2a,0x36,0x3b],   //4
            [0x87,0xce,0xbe],   //5
            [0x87,0xce,0xfa],   //6
            [0x00,0xbf,0xff],   //7
            [0xb0,0xe0,0xe6],   //8
            [0x1e,0x90,0xff],   //9
            [0xa6,0xf6,0xc1],   //10
            [0x31,0xa2,0x9d],   //11
            [0x4c,0x64,0x88],   //12
            [0x60,0x34,0x6e],   //13
            [0xf8,0xe7,0x9c],   //14
            [0x65,0x97,0xbc]    //15
        ]
        
        
        return UIColor(red: CGFloat(colors[idx][0])/255.0, green: CGFloat(colors[idx][1])/255.0, blue: CGFloat(colors[idx][2])/255.0, alpha: 1)

    }
    
    class func font(_ size:CGFloat) ->UIFont
    {
        return UIFont(name: "STHeitiSC-Light", size: size)!
    }

}
