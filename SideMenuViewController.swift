import UIKit
class SideMenuViewController: MenuViewController, SideMenuItemContent{
    @IBOutlet var btn_Theme : UIButton!
    @IBOutlet var btn_ShareApp : UIButton!
    @IBOutlet var btn_RateUs : UIButton!
    @IBOutlet var btn_PasswordChange : UIButton!
    let AppLink = "https://itunes.apple.com/us/app/hotsapp-lyrical-video/id1380731910?mt=8"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func onClickMenuButtons(_ sender: UIButton) {
        let tag = sender.tag as Int
        switch tag {
        case 101:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotiCallTheme"), object: nil)
            break
        case 102:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotiSharePopup"), object: nil)
            break
        case 103:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotiCloseSideMenu"), object: nil)
            UIApplication.shared.openURL(NSURL(string: AppLink)! as URL)
            break
        case 104:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotiChangePassword"), object: nil)
            break
        default:
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
