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
    var numberRows: Int? = nil
    var numberColumns: Int? = nil
    var cellWidth: CGFloat = 200
    var fontSize: CGFloat = 17
    var primaryButton = true

    
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
    
    class var numberOfRows: Connecion {
        struct Static {
            static let instance = Connecion()
        }
        return Static.instance
    }
    
    class var numberOfColumns: Connecion {
        struct Static {
            static let instance = Connecion()
        }
        return Static.instance
    }
    
}
