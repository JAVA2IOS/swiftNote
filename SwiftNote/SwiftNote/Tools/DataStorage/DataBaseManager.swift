//
//  DataBaseManager.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/17.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import Foundation
import SQLite3

class DataBaseManager: NSObject {
    
    /// 数据库版本
    private(set) var schemaVersion : Int = 0
    
    /// 数据库
    private(set) var db : OpaquePointer? = nil
    
    /// 数据库名称
    private(set) var dataBaseName : String?
    
    static let sharedInstance = DataBaseManager()
    
    private override init() {
        super.init()
    }
    
    @discardableResult
    /// 创建并打开数据库
    ///
    /// - Returns: 打开是否成功
    func openDataBase() -> Bool {
        dataBaseName = CZTools.systemBundleIdentifier + ".sqlite"
        let dataBasePath = CZTools.fileDocumentFilePath(dataBaseName!)
        if db == nil {
            if sqlite3_open(dataBasePath!.cString(using: .utf8), &db) == SQLITE_OK {
                return true
            }else {
                closeDataBase()
                return false
            }
        }
        
        return true
    }
    
    /// 配置数据库版本迁移
    ///
    /// - Parameter schemaHandler: 数据库版本迁移配置方法
    func configureDataBaseVersion(schemaHandler : (OpaquePointer?, inout Int) -> Void) -> Void {
        let schemaVersions = querySql("PRAGMA user_version")
        let startVersion = schemaVersion
        
        if schemaVersions?.count != 0 {
            let schemaVersionDic = schemaVersions?.first!
            
            schemaVersion = schemaVersionDic!["user_version"] as! Int
        }
        
        schemaHandler(db!, &schemaVersion)
        
        if startVersion != schemaVersion {
            excuteSql("PRAGMA user_version = \(schemaVersion)")
        }
    }
    
    /// 关闭数据
    func closeDataBase() -> Void {
        sqlite3_close(db)
    }
    
    @discardableResult
    /// 更新sql语句
    ///
    /// - Parameter sqlString: 待更新的sql语句
    /// - Returns: 更新是否成功
    func excuteSql(_ sqlString : String) -> Bool {
        objc_sync_enter(self)
        if !openDataBase() {
            objc_sync_exit(self)
            return false
        }
        
        var err: UnsafeMutablePointer<Int8>? = nil
        
        if sqlite3_exec(db, "BEGIN", nil, nil, &err) == SQLITE_OK {
            sqlite3_free(err)
            
            if sqlite3_exec(db,sqlString.cString(using: .utf8), nil, nil, &err) == SQLITE_OK {
                sqlite3_free(err)
                
                if sqlite3_exec(db, "COMMIT", nil, nil, &err) == SQLITE_OK {
                    sqlite3_free(err)
                    objc_sync_exit(self)
                    return true
                }
                
                if sqlite3_exec(db, "ROLLBACK", nil, nil, &err) == SQLITE_OK {
                    print("回滚事务成功")
                }else {
                    if let error = String(validatingUTF8:sqlite3_errmsg(db)) {
                        print("execute failed to execute  Error: \(error)")
                    }
                }
                
                objc_sync_exit(self)
                return false
            }
            
            sqlite3_free(err)
            
            if sqlite3_exec(db, "ROLLBACK", nil, nil, &err) == SQLITE_OK {
                print("回滚事务成功")
            }else {
                if let error = String(validatingUTF8:sqlite3_errmsg(db)) {
                    print("execute failed to execute  Error: \(error)")
                }
            }
        }
        
        if let error = String(validatingUTF8:sqlite3_errmsg(db)) {
            print("execute failed to execute  Error: \(error)")
        }
        
        objc_sync_exit(self)
        
        return false
    }
    
    @discardableResult
    /// sql查询语句执行
    ///
    /// - Parameter sqlString: 待执行的sql语句
    /// - Returns: 返回查询结果
    func querySql(_ sqlString : String) -> [[String:Any]]? {
        objc_sync_enter(self)
        if !openDataBase() {
            objc_sync_exit(self)
            return nil
        }
        
        var statements : OpaquePointer? = nil
        var rows = Array<Any>()
        
        if sqlite3_prepare_v2(db, sqlString.cString(using: .utf8), -1, &statements, nil) == SQLITE_OK {
            while sqlite3_step(statements) == SQLITE_ROW {
                let column = sqlite3_column_count(statements)
                var row : [String : Any] = Dictionary()
                
                for i in 0..<column {
                    let variableType = sqlite3_column_type(statements, i)
                    let columnChars = UnsafePointer<CChar>(sqlite3_column_name(statements, i))
                    let columnName = String(cString: columnChars!, encoding: .utf8)
                    
                    var value : Any
                    
                    switch variableType {
                    case SQLITE_INTEGER:
                        value = Int(sqlite3_column_int(statements, i))
                        break
                    case SQLITE_FLOAT:
                        value = Float(sqlite3_column_double(statements, i))
                        break
                    case SQLITE_TEXT:
                        let chars = UnsafePointer<CUnsignedChar>(sqlite3_column_text(statements, i))
                        value = String(cString: chars!)
                        break
                    default:
                        value = ""
                    }
                    
                    row.updateValue(value, forKey: columnName!)
                }
                
                rows.append(row)
            }
        }
        
        sqlite3_finalize(statements)
        
        objc_sync_exit(self)
        
        if rows.count != 0 {
            return (rows as! [[String : Any]])
        }
        
        return nil
    }
}


// MARK: - 数据库扩展

enum DataBaseVersion : Int {
    case initVersion = 0
}

extension DataBaseManager {
    /// 默认配置，包括数据库初始化以及数据库迁移
    func defaultConfiguration() -> Void {
        configureDataBaseVersion { (dataBase, schemaVersion) in
            var updateStatus = false
            
            if schemaVersion == 0 {
                updateStatus = configreDataBaseVersion(.initVersion)
            }
            
            if updateStatus {
                schemaVersion += 1
            }
        }
    }
    
    /// 根据数据库版本号更新操作
    ///
    /// - Parameters:
    ///   - version: 数据库版本号
    /// - Returns: 操作是否成功
    func configreDataBaseVersion(_ version : DataBaseVersion) -> Bool {
        switch version {
        case .initVersion:
            return configureInitVersion()
        }
    }
    
    /// 数据库起始版本
    ///
    /// - Returns:  操作是否成功
    func configureInitVersion() -> Bool {
        // 书籍
        if !excuteSql("CREATE TABLE IF NOT EXISTS Books (" +
            "bookId integer PRIMARY KEY AUTOINCREMENT NOT NULL," +
            "bookName varchar(255)," +
            "local integer NOT NULL DEFAULT(1)," +
            "url varchar(255)," +
            "ctime varchar(255)," +
            "deleted integer NOT NULL DEFAULT(0));") {
            return false
        }
        
        // 章节
        if !excuteSql("CREATE TABLE IF NOT EXISTS BookChapters (" +
            "chapterId integer PRIMARY KEY AUTOINCREMENT NOT NULL," +
            "bookId integer NOT NULL," +
            "chapterTitle varchar(255)," +
            "sort integer NOT NULL DEFAULT(0)," +
            "fisrtCharacter double(255) NOT NULL DEFAULT(0)," +
            "lastCharacter double(255) NOT NULL DEFAULT(0)," +
            "deleted integer NOT NULL DEFAULT(0)" +
            ");") {
            return false
        }
        
        // 书页样式
        if !excuteSql("CREATE TABLE IF NOT EXISTS BookStyle (" +
            "styleId integer PRIMARY KEY AUTOINCREMENT NOT NULL," +
            "font integer NOT NULL DEFAULT(16)," +
            "fontName varchar(255) NOT NULL DEFAULT('ArialMT')," +
            "lineSpacing integer NOT NULL DEFAULT(16)," +
            "color varchar(255) NOT NULL DEFAULT('878D94')" +
            ");") {
            return false
        }
        
        // 历史记录
        if !excuteSql("CREATE TABLE IF NOT EXISTS BookHistory (" +
            "historyId integer PRIMARY KEY AUTOINCREMENT NOT NULL," +
            "chapterId integer NOT NULL," +
            "bookId integer NOT NULL," +
            "startCharacter integer NOT NULL," +
            "deleted integer NOT NULL DEFAULT(0)" +
            ");") {
            return false
        }
        
        // 书签
        if !excuteSql("CREATE TABLE IF NOT EXISTS BookRemarks (" +
            "remarkId integer PRIMARY KEY AUTOINCREMENT NOT NULL," +
            "historyId integer NOT NULL," +
            "deleted integer NOT NULL DEFAULT(0)," +
            "ctime varchar(255) NOT NULL" +
            ");") {
            return false
        }
        
        // 插入样式数据
        if !excuteSql("INSERT INTO BookStyle (font, fontName, lineSpacing, color) VALUES (16, 'ArialMT', 16, '878D94');") {
            return false
        }
        
        return true
    }
}
