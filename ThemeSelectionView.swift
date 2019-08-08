import Foundation
import UIKit
class ThemeSelectionView: UIView {
    @IBOutlet var lbl_ColorName : UILabel!
    @IBOutlet var vw_Color : UIView!
    @IBOutlet var btn_SelectColor : UIButton!
    override func awakeFromNib() {
        vw_Color.backgroundColor = UIColor(rgb:0xFC6A78)
    }
}
