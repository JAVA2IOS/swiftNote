//
//  ViewController.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/9/13.
//  Copyright © 2018年 CodeZ Huang. All rights reserved.
//
import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 常量
        let greetingStr : String = "你好"
        let roleStr : String = "swift"
        print("合成的字符串 \(greetingStr) \(roleStr)")
        
        let number : Int = 12_01_00
        let floatValue : Float = 12.34
        print("常量类型 \(number) \(floatValue)")
        
        // 类型转换
        let int2float = Double(12)
        let string2float : Int? = Int("1")
        let checked : Bool? = Bool("true")
        
        
        print("类型转换 \(int2float) \(string2float!) \(checked!)")
        
        // 类型别名
        typealias IntType = Int
        let aliasValue : IntType = 12
        print("别名 \(aliasValue)")
        
        // 元组
        let httpCodeBlock = (404, "Not found")
        let netCodeStatus = (code: 200, description: "Ok")
        
        print("元组  \(httpCodeBlock)  第一个元素: \(httpCodeBlock.0) 第二个元素: \(httpCodeBlock.1)")
        print("元组  \(netCodeStatus)  第一个元素: \(netCodeStatus.code) 第二个元素: \(netCodeStatus.description)")
        
        // 循环运算
        for index in 1...5 {
            print("\(index)")
        }
        for index in 1..<5 {
            print("\(index)")
        }
    }


}

