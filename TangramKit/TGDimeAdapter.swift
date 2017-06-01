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
    

    /// 指定UI设计原型图所用的设备尺寸。请在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法的开始处调用这个方法，比如当UI设计人员用iPhone6作为界面的原型尺寸则将size设置为375,667。
    ///
    /// - Parameter size: 模板的尺寸
    public class func template(_ size:CGSize)
    {
        let screenSize = UIScreen.main.bounds.size;
        
        _wrate = screenSize.width / size.width;
        _hrate = screenSize.height / size.height;
        _rate = sqrt((screenSize.width * screenSize.width + screenSize.height * screenSize.height) / (size.width * size.width + size.height * size.height));

    }

    

    /// 返回屏幕尺寸缩放的比例
    ///
    /// - Parameter val: 要计算的值
    /// - Returns: 按比例缩放的值
    public class func size(_ val:CGFloat) ->CGFloat
    {
        return _tgRoundNumber(val * _rate)
    }
    
    
    /**
     返回屏幕宽度缩放的比例
     */
    public class func width(_ val:CGFloat) ->CGFloat
    {
        return _tgRoundNumber(val * _wrate)
    }
    
    /**
     返回屏幕高度缩放的比例
     */
    public class func height(_ val:CGFloat) ->CGFloat
    {
        return _tgRoundNumber(val * _hrate)
    }
    
    /**
     根据屏幕清晰度将带小数的入参返回能转化为有效物理像素的最接近的设备点值。
     比如当入参为1.3时，那么在1倍屏幕下的有效值就是1,而在2倍屏幕下的有效值就是1.5,而在3倍屏幕下的有效值就是1.3333333了
     */
    public class func round(_ val:CGFloat) ->CGFloat
    {
        return _tgRoundNumber(val)
    }
    
    /**
     根据屏幕清晰度将带小数的point入参返回能转化为有效物理像素的最接近的设备point点值。
     */
    public class func round(_ val:CGPoint) ->CGPoint
    {
        return _tgRoundPoint(val)
    }
    
    /**
     根据屏幕清晰度将带小数的size入参返回能转化为有效物理像素的最接近的设备size点值。
     */
    public class func round(_ val:CGSize) ->CGSize
    {
        return _tgRoundSize(val)
    }
    
    /**
     根据屏幕清晰度将带小数的rect入参返回能转化为有效物理像素的最接近的设备rect点值。
     */
    public class func round(_ val:CGRect) ->CGRect
    {
        return _tgRoundRect(val)
    }
}




