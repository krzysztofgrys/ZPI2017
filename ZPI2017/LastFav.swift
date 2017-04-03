
import Foundation

class LastFav: NSObject, NSCoding {
    
    var ip = ""
    var user = ""
    var password = ""
    var port = ""
    
    init(ip: String, user: String, password: String, port: String) {
        self.ip = ip
        self.user = user
        self.password = password
        self.port = port
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let ip = decoder.decodeObject(forKey: "ip") as? String,
            let user = decoder.decodeObject(forKey: "user") as? String,
            let password = decoder.decodeObject(forKey: "password") as? String,
            let port = decoder.decodeObject(forKey: "port") as? String
            else { return nil }
        
        self.init(ip: ip, user: user, password: password, port:port )
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.ip, forKey: "ip")
        coder.encode(self.user, forKey: "user")
        coder.encode(self.password, forKey: "password")
        coder.encode(self.port, forKey: "port")
  }
}
