//
//  TGDimeAdapter.swift
//  TangramKit
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import Foundation
import UIKit

public class TGDimeAdapter
{
    
    static private var _rate:CGFloat = 1
    static private var _wrate:CGFloat = 1
    static private var _hrate:CGFloat = 1
    
    //保持缩放值精确到0.5
    private class func roundNumber(_ num:CGFloat) ->CGFloat
    {
        var retNum = num
        retNum += 0.49999;
        retNum *= 2;
        return floor(retNum) / 2.0;
    }

    
    /**
     *指定UI设计原型图所用的设备尺寸。请在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法的开始处调用这个方法，比如当UI设计人员用iPhone6作为界面的原型尺寸则将size设置为375,667。
     */
    public class func template(_ size:CGSize)
    {
        let screenSize = UIScreen.main.bounds.size;
        
        _wrate = screenSize.width / size.width;
        _hrate = screenSize.height / size.height;
        _rate = sqrt((screenSize.width * screenSize.width + screenSize.height * screenSize.height) / (size.width * size.width + size.height * size.height));

    }

    
    /**
     *返回屏幕尺寸缩放的比例
     */
    public class func size(_ val:CGFloat) ->CGFloat
    {
        return self.roundNumber(val * _rate)
    }
    
    
    /**
     *返回屏幕宽度缩放的比例
     */
    public class func width(_ val:CGFloat) ->CGFloat
    {
        return self.roundNumber(val * _wrate)
    }
    
    /**
     *返回屏幕高度缩放的比例
     */
    public class func height(_ val:CGFloat) ->CGFloat
    {
        return self.roundNumber(val * _hrate)
    }
}




