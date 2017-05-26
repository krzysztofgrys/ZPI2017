//
//  CredentialsTmp.swift
//  ZPI2017
//
//  Created by Krzysztof Grys on 5/26/17.
//  Copyright © 2017 ZPI. All rights reserved.
//

import Foundation

class CredentialsTmp {
    var ip:String = ""
    var user = ""
    var password = ""
    var port = ""
    var type = ""
    var isFavourite = false
    
    
    class var CredentialIp: CredentialsTmp{
        struct Static {
            static let ip = CredentialsTmp()
        }
        
        return Static.ip
    }
    
    
    class var CredentialUser: CredentialsTmp{
        struct Static {
            static let user = CredentialsTmp()
        }
        
        return Static.user
    }
    
    
    
    class var CredentialPassword: CredentialsTmp{
        struct Static {
            static let password = CredentialsTmp()
        }
        
        return Static.password
    }
    
    
    class var CredentialPort: CredentialsTmp{
        struct Static {
            static let port = CredentialsTmp()
        }
        
        return Static.port
    }
    
    
    class var CredentialisFav: CredentialsTmp{
        struct Static {
            static let fav = CredentialsTmp()
        }
        return Static.fav
    }
}

