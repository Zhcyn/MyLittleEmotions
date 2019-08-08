import UIKit
open class MenuViewController: UIViewController {
    public weak var menuContainerViewController: MenuContainerViewController?
    var navigationMenuTransitionDelegate: MenuTransitioningDelegate?
    @objc func handleTap(recognizer: UIGestureRecognizer){
        menuContainerViewController?.hideSideMenu()
    }
}
