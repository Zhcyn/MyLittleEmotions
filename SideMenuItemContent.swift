import UIKit
public protocol SideMenuItemContent {
    func showSideMenu()
    func hideSideMenu()
}
extension SideMenuItemContent where Self: UIViewController {
    public func showSideMenu() {
        if let menuContainerViewController = parent as? MenuContainerViewController {
            menuContainerViewController.showSideMenu()
        } else if let navController = parent as? UINavigationController,
            let menuContainerViewController = navController.parent as? MenuContainerViewController {
            menuContainerViewController.showSideMenu()
        }
    }
    public func hideSideMenu() {
        if let menuContainerViewController = parent as? MenuContainerViewController {
            menuContainerViewController.hideSideMenu()
        } else if let navController = parent as? UINavigationController,
            let menuContainerViewController = navController.parent as? MenuContainerViewController {
            menuContainerViewController.hideSideMenu()
        } 
    }
}
