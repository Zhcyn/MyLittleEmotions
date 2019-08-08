import UIKit
class HostViewController: MenuContainerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        self.transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: screenSize.width / 6)
        self.menuViewController = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController") as! MenuViewController
        self.contentViewControllers = contentControllers()
        self.selectContentViewController(contentViewControllers.first!)
        self.contentControllersBWuxSecret("123")
    }
    private func contentControllers() -> [UIViewController] {
        let controllersIdentifiers = ["MainViewController"]
        var contentList = [UIViewController]()
        for identifier in controllersIdentifiers {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) {
                contentList.append(viewController)
            }
        }
        return contentList
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        var options = TransitionOptions()
        options.duration = size.width < size.height ? 0.4 : 0.6
        options.visibleContentWidth = size.width / 6
        self.transitionOptions = options
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
