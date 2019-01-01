//
//  Date+extension.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/19.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import Foundation

enum DateFormatterType {
    case Y_M_D
    case Y_M_D_h_m_s
    case h_m_s
    case h_m
}

extension Date {
    /// 时间戳
    static var currentTimeStamp : Double {
        return Date.timeIntervalSinceReferenceDate
    }
    
    /// 日期转固定格式字符串
    ///
    /// - Parameter dateType: 字符串格式
    /// - Returns: 日期字符串
    func convertToFormatterString(_ dateType : DateFormatterType) -> String {
        let dateFormmatter = Date.initDateFormatter(dateType)

        return  dateFormmatter.string(from: self)
    }
    
    
    /// 日期格式化
    ///
    /// - Parameter dateType: 格式化类型
    static func initDateFormatter(_ dateType : DateFormatterType) -> DateFormatter {
        let dateFormmatter = DateFormatter()
        var formatterString = "yyy-MM-dd HH:mm:ss"
        
        switch dateType {
        case .Y_M_D:
            formatterString = "yyyy-MM-dd"
            break
        case .Y_M_D_h_m_s:
            formatterString = "yyy-MM-dd HH:mm:ss"
            break
        case .h_m_s:
            formatterString = "HH:mm:ss"
            break
        case .h_m:
            formatterString = "HH:mm"
            break
        }
        
        dateFormmatter.dateFormat = formatterString
        
        return dateFormmatter
    }
    
}

extension String {
    
    /// 字符串转日期
    ///
    /// - Parameter dateType: 格式化类型
    /// - Returns: 日期，可为空
    func stringConvertToDate(_ dateType : DateFormatterType) -> Date? {
        let dateFormmatter = Date.initDateFormatter(dateType)
        
        return dateFormmatter.date(from: self)
    }
}
