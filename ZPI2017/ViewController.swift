
import UIKit
import MySqlSwiftNative


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
    var favorites: [LastFav] = []
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LastTableViewCell
        if(FavLastSwitcher.selectedSegmentIndex==0){
            cell.LastCell.text = favorites[indexPath.row].ip+("/")+favorites[indexPath.row].user
        }else{
            //TODO
            cell.LastCell.text = "ulubione - TODO"
        }
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(FavLastSwitcher.selectedSegmentIndex==0){
            if favorites.count == 0{
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "Brak :("
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
            
            // TODO pozniej - gdy beda ulubione - to mi sie nie podoba, pozniej bedzie refactoring
            let favData = 0
            if favData == 0{
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "Brak :("
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
            }else{
                TableView.backgroundView = nil
                tableView.separatorStyle  = .singleLine
            }
            return favData
        }
    }
    
    
    public func switcherChange(){
        if FavLastSwitcher.selectedSegmentIndex==0 {
         TableView.reloadData()
//            DispatchQueue.main.async{
//                self.TableView.reloadData()
//            
//            }
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
        if validateFields(){
            do{
                try con.open(ipField.text!, user: userField.text!, passwd: passwordField.text, port: Int(portField.text!))
                let destination = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "databaseSelection") as! DatabaseSelectionTableViewController
                destination.con = self.con
                navigationController?.pushViewController(destination, animated: true)
            }catch(let e){
                print(e)
                showAlert(message: "Nie mozna polaczyc sie z baza danych")
            }
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
            saveCredentials()
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
    
    func saveCredentials(){
        
        let credentials = favorites+[(LastFav(ip: ipField.text!, user: userField.text!, password: passwordField.text!, port: port.text!))]
        let filename = NSHomeDirectory().appending("/Documents/profile.bin")
        NSKeyedArchiver.archiveRootObject(credentials, toFile: filename)
        print("zapisano")
    }

    func getCredentials(){
        if let data = NSData(contentsOfFile: NSHomeDirectory().appending("/Documents/profile.bin")){
            let unarchiveProfile = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [LastFav]
            print("odczytano")
            favorites = []
            for fav in 0..<(unarchiveProfile.count){
                favorites.append(unarchiveProfile[fav])
            }
        }
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
            //TODO usuwanie
        }
        cell.backgroundColor = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1)
        
        return [cell]
    }
    
    func fillCredentials(id: Int){
        let fav = favorites[id]
        ipField.text = fav.ip
        userField.text = fav.user
        passwordField.text = fav.password
        portField.text = fav.port
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
    
        FavLastSwitcher.addTarget(self, action: #selector(switcherChange), for: .valueChanged)
        
        login.addTarget(self, action: #selector(connect), for: .touchDown)
        getCredentials()
        super.viewDidLoad()
        port.addTarget(self, action: #selector(textFieldDidBeginEditing), for: UIControlEvents.touchDown)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        port.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

