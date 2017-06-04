//
//  Dict.swift
//  ZPI2017
//
//  Created by Krzysztof Grys on 6/4/17.
//  Copyright © 2017 ZPI. All rights reserved.
//

import Foundation

class Dict: NSObject{
    class func sqlCommon() -> Array<String>{
        return [
            "INSERT",
            "ALTER TABLE",
            "AND",
            "AS",
            "AVG",
            "BETWEEN",
            "COUNT",
            "CREATE TABLE",
            "DELETE",
            "GROUP BY",
            "INNER JOIN",
            "LIKE",
            "LIMIT",
            "MAX",
            "MIN",
            "OR",
            "ORDER BY",
            "OUTER JOIN",
            "ROUND",
            "SELECT",
            "SELECT DISTINCT",
            "SUM",
            "UPDATE",
            "WHERE",
            "FROM"
            
        ]
    }
}
