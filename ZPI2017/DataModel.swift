//
//  DataModel.swift
//  ZPI2017
//
//  Created by Łukasz on 03.04.2017.
//  Copyright © 2017 ZPI. All rights reserved.
//

import Foundation
import MySqlSwiftNative
struct DataModel{
    var key:String
    var value:Any
    var row:Int
    init(k:String, v:Any, r:Int) {
        self.key=k
        self.value=v
        self.row=r
    }
}
