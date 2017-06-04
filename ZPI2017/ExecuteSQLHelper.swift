//
//  ExecuteSQLHelper.swift
//  ZPI2017
//
//  Created by Krzysztof Grys on 6/4/17.
//  Copyright © 2017 ZPI. All rights reserved.
//

import Foundation
class ExecuteSQLHelper{

    var database: String = ""
    var table: String = ""
   
    
    class var database: ExecuteSQLHelper {
        struct Static {
            static let instance = ExecuteSQLHelper()
        }
        return Static.instance
    }
    
    class var table: ExecuteSQLHelper{
        struct Static{
            static let instance = ExecuteSQLHelper()
        }
        return Static.instance
    }
}
