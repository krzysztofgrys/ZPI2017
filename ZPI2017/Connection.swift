//
//  Connection.swift
//  ZPI2017
//
//  Created by Krzysztof Grys on 5/22/17.
//  Copyright © 2017 ZPI. All rights reserved.
//

import Foundation
import MySqlSwiftNative

class Connecion{
    var con: MySQL.Connection? = nil
    var list: [DataModel]? = nil

    class var instanceOfConnection: Connecion {
        struct Static {
            static let instance = Connecion()
        }
        return Static.instance
    }
    
    class var instatnceOfList: Connecion{
        struct Static{
            static let instance = Connecion()
        }
        return Static.instance
    }
    
}
