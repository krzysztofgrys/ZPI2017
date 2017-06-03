
import UIKit
import MySqlSwiftNative
import LocalAuthentication

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let con = MySQL.Connection()
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var FavLastSwitcher: UISegmentedControl!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var port: UITextField!
    @IBOutlet weak var pickerControll: UISegmentedControl!
    @IBOutlet weak var ipField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var portField: UITextField!
    
    var isFavourite: Bool = false
    var favorites: [LastFav] = []
    var fav: [LastFav] = []
    var tmp: [LastFav] = []
    @IBOutlet weak var act: UIActivityIndicatorView!
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LastTableViewCell
        if(FavLastSwitcher.selectedSegmentIndex==0){
            cell.LastCell.text = favorites[indexPath.row].ip+("/")+favorites[indexPath.row].user
        }else{
            cell.LastCell.text = fav[indexPath.row].ip+("/")+fav[indexPath.row].user
        }
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(FavLastSwitcher.selectedSegmentIndex==0){
            //TUtaj sa ostatnie
            if favorites.count == 0{
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "Brak"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none

            }else{
                TableView.backgroundView = nil
                tableView.separatorStyle  = .singleLine
            }
            
            return favorites.count
        }else{
            //a tutaj sa serio ulubione
            if fav.count == 0{
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "Brak"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none

            }else{
                TableView.backgroundView = nil
                tableView.separatorStyle  = .singleLine
            }
            return fav.count
        }
    }
    
    
    public func switcherChange(){
        if FavLastSwitcher.selectedSegmentIndex==0 {
            TableView.reloadData()
        }else{
            TableView.reloadData()
        }
    }
    
    func showAlert(message: String){
        let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func connect(){
        startAct()
        DispatchQueue.main.async {
            if self.validateFields(){
                do{
                    try self.con.open(self.ipField.text!, user: self.userField.text!, passwd: self.passwordField.text, port: Int(self.portField.text!))
                    Connecion.instanceOfConnection.con = self.con

                    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                    
                    let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "tabBarController") as! TabBarController
                    initialViewController.con = self.con
                    
                    CredentialsTmp.CredentialIp.ip   = self.ipField.text!
                    CredentialsTmp.CredentialPort.port = self.port.text!
                    CredentialsTmp.CredentialPassword.password = self.passwordField.text!
                    CredentialsTmp.CredentialUser.user = self.userField.text!
                    CredentialsTmp.CredentialisFav.isFavourite = false
                    
                    appDelegate.window?.rootViewController = initialViewController
                    appDelegate.window?.makeKeyAndVisible()
                    
                }catch(let e){
                    print(e)
                    self.showAlert(message: "Nie mozna polaczyc sie z baza danych")
                }
            }
            self.stopAct()
        }
    }
    
    public func validateFields() -> Bool{
        if(ipField.text == "" || ipField.text == nil){
            showAlert(message: "Ip nie moze byc puste")
            return false
        }
        if(userField.text == "" || userField.text == nil){
            showAlert(message: "User nie moze byc puste")
            return false
        }
        if(passwordField.text == "" || passwordField.text == nil){
            showAlert(message: "Password nie moze byc puste")
            return false
        }
        if(port.text == "" || port.text == nil){
            showAlert(message: "Port nie moze byc pusty")
            return false
        }
        if(!checkIfCredentialsExists(ip: ipField.text!, user: userField.text!)){
            saveCredentials(type: "last")
        }
        getCredentials()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TableView.reloadData()
    }
    
    func checkIfCredentialsExists(ip: String, user: String) -> Bool{
        for cred in 0..<(favorites.count){
            if(favorites[cred].ip==ip && favorites[cred].user==user){
                return true
            }
        }
        return false
    }
    
    func saveCredentials(type: String){
        
        let credentials = tmp+[(LastFav(ip: ipField.text!, user: userField.text!, password: passwordField.text!, port: port.text!, type: type))]
        let filename = NSHomeDirectory().appending("/Documents/profile.bin")
        NSKeyedArchiver.archiveRootObject(credentials, toFile: filename)
        print("zapisano")
    }
    
    func getCredentials(){
        if let data = NSData(contentsOfFile: NSHomeDirectory().appending("/Documents/profile.bin")){
            let unarchiveProfile = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [LastFav]
            print("odczytano")
            tmp = []
            for favv in 0..<(unarchiveProfile.count){
                let read = unarchiveProfile[favv]
                tmp.append(read)
            }
        }
    }
    
    
    func saveCred(){
        let filename = NSHomeDirectory().appending("/Documents/profile.bin")
        NSKeyedArchiver.archiveRootObject(tmp, toFile: filename)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        fillCredentials(id: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let cell = UITableViewRowAction(style: .normal, title: " Delete ") { action, index in
            self.deleteFavOrLast(id: index.row)
            self.refresh()
            self.prepareLastAndFav()
            self.saveCred()
            tableView.reloadData()
        }
        cell.backgroundColor = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1)
        
        return [cell]
    }
    
    
    func prepareLastAndFav(){
        for favv in 0..<tmp.count{
            let read = tmp[favv]
            if(read.type=="last"){
                favorites.append(read)
            }else{
                fav.append(read)
            }
        }
    }
    
    func refresh(){
        tmp = []
        
        for i in 0..<fav.count{
            tmp.append(fav[i])
        }
        
        for i in 0..<favorites.count{
            tmp.append(favorites[i])
        }
        favorites = []
        fav = []
    }
    
    func deleteFavOrLast(id: Int){
        if(FavLastSwitcher.selectedSegmentIndex==0){
            favorites.remove(at: id)
            
        }else{
            fav.remove(at: id)
        }
    }
    
    
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        
        showAlertWithTitle(title: "Error", message: "This device does not have a TouchID sensor.")
        
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async() { () -> Void in
            self.present(alertVC, animated: true, completion: nil)
        }
        
    }
    
    func fillCredentials(id: Int){
        let authenticationContext = LAContext()

        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Przyłóż palec, aby wypełnić hasło",
            reply: { [unowned self] (success, error) -> Void in
                DispatchQueue.main.async {
                    var favo: LastFav? = nil
                    if(self.FavLastSwitcher.selectedSegmentIndex==0){
                        favo = self.favorites[id]
                        
                    }else{
                        favo = self.fav[id]
                        
                    }
                    
                    if( success ) {
                        self.ipField.text = favo?.ip
                        self.userField.text = favo?.user
                        self.passwordField.text = favo?.password
                        self.portField.text = favo?.port
                        
                    }else {
                        self.ipField.text = favo?.ip
                        self.userField.text = favo?.user
                        self.portField.text = favo?.port
                        
                    }
                }
                
                
        })
        
            }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        FavLastSwitcher.addTarget(self, action: #selector(switcherChange), for: .valueChanged)
        //UserDefaults.standard.set("200.000", forKey: "cellWidth")
        login.addTarget(self, action: #selector(connect), for: .touchDown)
        getCredentials()
        prepareLastAndFav()
        super.viewDidLoad()
        port.addTarget(self, action: #selector(textFieldDidBeginEditing), for: UIControlEvents.touchDown)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        port.text = ""
    }
    func startAct(){
        self.view.superview?.bringSubview(toFront: self.act)
        self.act.startAnimating()
        self.act.isHidden = false
    }
    func stopAct(){
        DispatchQueue.main.async {
            self.act.stopAnimating()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

