import UIKit
import CoreData
var themeColor : UIColor = UIColor(rgb:0xFC6A78)
let appDelegate = UIApplication.shared.delegate as! AppDelegate
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,SideMenuItemContent {
    @IBOutlet var vw_HeaderView : UIView!
    @IBOutlet var btn_Menu : UIButton!
    @IBOutlet var btn_LeftMenu : UIButton!
    @IBOutlet var btn_NewNote : UIButton!
    @IBOutlet var lbl_HeaderTitle : UILabel!
    @IBOutlet var tableView : UITableView!
    var manageObjectContext: NSManagedObjectContext!
    var noteArray = [NoteDataObject]()
    let AppLink = "https://itunes.apple.com/us/app/hotsapp-lyrical-video/id1380731910?mt=8"
    let dropDown = DropDown()
    var themePopup = PetrickAlertView()
    var container: NSPersistentContainer!
    var colorArray = ["Default","Teal","Blue","Purple","Dark Purple","Red","Orange","Sky Blue"]
    var colorCodeArray = [
        UIColor(rgb: 0xFC6A78),
        UIColor(rgb: 0x00A0B1),
        UIColor(rgb: 0x2E8DEF),
        UIColor(rgb: 0xA700AE),
        UIColor(rgb: 0x643EBF),
        UIColor(rgb: 0xBF1E4B),
        UIColor(rgb: 0xDC572E),
        UIColor(rgb: 0x0A5BC4),
        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUIs()
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        NotificationCenter.default.addObserver(self, selector: #selector(self.onClickThemeNoti), name: NSNotification.Name(rawValue: "NotiCallTheme"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onClickSharePopup), name: NSNotification.Name(rawValue: "NotiSharePopup"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onClickCloseSideNoti), name: NSNotification.Name(rawValue: "NotiCloseSideMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTableData), name: NSNotification.Name(rawValue: "NotiRefreshTable"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changePassword), name: NSNotification.Name(rawValue: "NotiChangePassword"), object: nil)
        self.loadCoreDatabase()
        self.createThemePopupjLRuSecret("stringBase")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    func setupUIs() {
        self.vw_HeaderView.backgroundColor = themeColor
        self.btn_NewNote.backgroundColor = themeColor
        dropDown.anchorView = self.btn_LeftMenu
        dropDown.dataSource = ["Theme"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            if index == 0 {
                print("Theme Click")
                self.createThemePopup()
            }
        }
        dropDown.width = 150
    }
    func createThemePopup() {
        let helpView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.8))
        helpView.backgroundColor = UIColor.red
        var heightY = 10
        for var i in 0...7 {
            let vw_ThemeSelection = Bundle.main.loadNibNamed("ThemeSelectionView",owner: nil,options: nil)?.first as! ThemeSelectionView
            vw_ThemeSelection.btn_SelectColor.tag = i
            vw_ThemeSelection.btn_SelectColor.addTarget(self, action: #selector(self.onClickColor(_:)), for: .touchUpInside)
            vw_ThemeSelection.frame.origin.y = CGFloat(heightY)
            vw_ThemeSelection.lbl_ColorName.text = self.colorArray[i]
            vw_ThemeSelection.vw_Color.backgroundColor = self.colorCodeArray[i]
            helpView.addSubview(vw_ThemeSelection)
            heightY = heightY + 50
        }
        let button:UIButton = UIButton(frame: CGRect(x: helpView.frame.size.width -  100, y: helpView.frame.size.height -  50, width: 100, height: 50))
        button.backgroundColor = UIColor.white
        button.setTitle("Close", for: UIControlState.normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(self.onClickClose(_:)), for: .touchUpInside)
        helpView.addSubview(button)
        helpView.layer.cornerRadius = 5
        helpView.layer.masksToBounds = true
        self.themePopup = PetrickAlertView(cv: helpView)
        self.themePopup.show()
    }
    @IBAction func onClickSideMenu(_ sender: UIButton) {
        print(sender.tag)
        self.showSideMenu()
    }
    @IBAction func onClickNewNote(_ sender: UIButton) {
        print(sender.tag)
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotebookViewController") as! NotebookViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func onClickColor(_ sender: UIButton) {
        print(sender.tag)
        themeColor = colorCodeArray[sender.tag]
        self.vw_HeaderView.backgroundColor = themeColor
        self.btn_NewNote.backgroundColor = themeColor
        self.tableView.reloadData()
        self.themePopup.hide()
    }
    @objc func onClickThemeNoti() {
        self.hideSideMenu()
        self.createThemePopup()
    }
    @objc func onClickSharePopup() {
        let videoImageUrl = "A Notepad app makes your life more simple by save your important thing and improve your productivity.For Save notes quickly download Notepad App at here.. \n \(AppLink)"
        let sender = self.btn_LeftMenu as UIButton
        let objectsToShare = [videoImageUrl] 
        guard let button = sender as? UIView else {
            return
        }
        let activityVCC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVCC.modalPresentationStyle = .popover
        if let presenter = activityVCC.popoverPresentationController {
            presenter.sourceView = button
            presenter.sourceRect = button.bounds
        }
        self.present(activityVCC, animated: true, completion: nil)
        self.hideSideMenu()
    }
    @objc func onClickCloseSideNoti() {
        self.hideSideMenu()
    }
    @objc func refreshTableData() {
        self.loadCoreDatabase()
    }
    @objc func changePassword() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChangePasscodeViewController") as! ChangePasscodeViewController
        self.navigationController?.pushViewController(vc, animated: true)
        self.hideSideMenu()
    }
    @objc func onClickClose(_ sender: UIButton) {
        self.themePopup.hide()
    }
    private func createRecordForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObject? {
        var result: NSManagedObject?
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: managedObjectContext)
        if let entityDescription = entityDescription {
            result = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
        }
        return result
    }
    func loadCoreDatabase() {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Emotion")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            self.noteArray.removeAll()
            for data in result as! [NSManagedObject] {
                let myObj = NoteDataObject()
                print("NoteID::>",data.value(forKey: "noteID") as! String)
                myObj.NoteID = data.value(forKey: "noteID") as! String
                myObj.NoteTitle = data.value(forKey: "noteTitle") as! String
                myObj.NoteDescription = data.value(forKey: "noteDesc") as! String
                myObj.NoteCreatedDate = data.value(forKey: "notePubDate") as! String
                myObj.NoteModiDate = data.value(forKey: "noteModiDate") as! String
                myObj.NoteDay = data.value(forKey: "noteDay") as! String
                myObj.NoteMonth = data.value(forKey: "noteMonth") as! String
                myObj.NoteYear = data.value(forKey: "noteYear") as! String
                self.noteArray.append(myObj)
            }
            self.tableView.reloadData()
        } catch {
            print("Failed")
        }
    }
    func deleteRecord(str: String, indexPath: IndexPath, objNote: NoteDataObject)  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emotion")
        fetchRequest.predicate = NSPredicate(format: "noteTitle = %@", objNote.NoteTitle!)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            if test.count != 0 {
                let objectToDelete = test[0] as! NSManagedObject
                managedContext.delete(objectToDelete)
                self.noteArray.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.loadCoreDatabase()
                })
                do{
                    try managedContext.save()
                }
                catch
                {
                    print(error)
                }
            }
        }
        catch
        {
            print(error)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellNoteList") as! CellNoteList
        cell.lbl_Day.textColor = themeColor
        cell.lbl_Month.backgroundColor = themeColor
        cell.lbl_Year.backgroundColor = themeColor
        let obj = self.noteArray[indexPath.row] as NoteDataObject
        cell.lbl_Description.text = obj.NoteTitle
        cell.lbl_Day.text = obj.NoteDay
        cell.lbl_Month.text = obj.NoteMonth
        cell.lbl_Year.text = obj.NoteYear
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.noteArray[indexPath.row] as NoteDataObject
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotebookViewController") as! NotebookViewController
        vc.isEditing = true
        vc.noteObject = obj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let obj = self.noteArray[indexPath.row] as NoteDataObject
        switch editingStyle {
        case .delete:
            self.deleteRecord(str: obj.NoteTitle,indexPath: indexPath, objNote: obj)
            break
        default:
            break
        }
    }
    @IBAction func onClickOption(_ sender: UIButton) {
        dropDown.show()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent 
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
class CellNoteList : UITableViewCell {
    @IBOutlet var vw_DateView : UIView!
    @IBOutlet var lbl_Day : UILabel!
    @IBOutlet var lbl_Month : UILabel!
    @IBOutlet var lbl_Year : UILabel!
    @IBOutlet var lbl_Description : UILabel!
}
class NoteDataObject : NSObject {
    var NoteID : String!
    var NoteTitle : String!
    var NoteDescription : String!
    var NoteCreatedDate : String!
    var NoteModiDate : String!
    var NoteDay : String!
    var NoteMonth : String!
    var NoteYear : String!
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
class Helper: NSObject
{
    class func addBlurView(_ inView : UIView) -> UIVisualEffectView
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = inView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.88
        return blurEffectView
    }
}
