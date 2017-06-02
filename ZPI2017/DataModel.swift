//
//  DataModel.swift
//  ZPI2017
//
//  Created by Łukasz on 03.04.2017.
//  Copyright © 2017 ZPI. All rights reserved.
//

import Foundation
struct DataModel{
    var key:String
    var value:Any
    var row:Int
    var column:Int
    init(k:String, v:Any, r:Int, c:Int) {
        self.key=k
        self.value=v
        self.row=r
        self.column=c
    }
}
