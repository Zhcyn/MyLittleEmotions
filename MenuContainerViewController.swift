import UIKit
open class MenuContainerViewController: UIViewController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return currentContentViewController?.preferredStatusBarStyle ?? .lightContent
    }
    fileprivate weak var currentContentViewController: UIViewController?
    fileprivate var navigationMenuTransitionDelegate: MenuTransitioningDelegate!
    fileprivate var isShown = false
    public var currentItemOptions = SideMenuItemOptions() {
        didSet {
            navigationMenuTransitionDelegate?.currentItemOptions = currentItemOptions
        }
    }
    public var menuViewController: MenuViewController! {
        didSet {
            if menuViewController == nil {
                fatalError("Invalid `menuViewController` value. It should not be nil")
            }
            menuViewController.menuContainerViewController = self
            menuViewController.transitioningDelegate = navigationMenuTransitionDelegate
            menuViewController.navigationMenuTransitionDelegate = navigationMenuTransitionDelegate
        }
    }
    public var transitionOptions: TransitionOptions {
        get {
            return navigationMenuTransitionDelegate?.interactiveTransition.options ?? TransitionOptions()
        }
        set {
            navigationMenuTransitionDelegate?.interactiveTransition.options = newValue
        }
    }
    public var contentViewControllers = [UIViewController]()
    override open func viewDidLoad() {
        super.viewDidLoad()
        let interactiveTransition = MenuInteractiveTransition(
            currentItemOptions: currentItemOptions,
            presentAction: { [unowned self] in
                self.presentNavigationMenu()
            },
            dismissAction: { [unowned self] in
                self.dismissNavigationMenu()
            }
        )
        navigationMenuTransitionDelegate = MenuTransitioningDelegate(interactiveTransition: interactiveTransition)
        let screenEdgePanRecognizer = UIScreenEdgePanGestureRecognizer(
            target: navigationMenuTransitionDelegate.interactiveTransition,
            action: #selector(MenuInteractiveTransition.handlePanPresentation(recognizer:))
        )
        screenEdgePanRecognizer.edges = .left
        view.addGestureRecognizer(screenEdgePanRecognizer)
    }
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let viewBounds = CGRect(x:0, y:0, width:size.width, height:size.height)
        let viewCenter = CGPoint(x:size.width/2, y:size.height/2)
        coordinator.animate(alongsideTransition: { _ in
            if self.menuViewController == nil {
                fatalError("Invalid `menuViewController` value. It should not be nil")
            }
            self.menuViewController.view.bounds = viewBounds
            self.menuViewController.view.center = viewCenter
            self.view.bounds = viewBounds
            self.view.center = viewCenter
            if self.isShown {
                self.hideSideMenu()
            }
        }, completion: nil)
    }
}
extension MenuContainerViewController {
    public func showSideMenu() {
        presentNavigationMenu()
    }
    public func hideSideMenu() {
        dismissNavigationMenu()
    }
    public func selectContentViewController(_ selectedContentVC: UIViewController) {
        if let currentContentVC = currentContentViewController {
            if currentContentVC != selectedContentVC {
                currentContentVC.view.removeFromSuperview()
                currentContentVC.removeFromParentViewController()
                setCurrentView(selectedContentVC)
            }
        } else {
            setCurrentView(selectedContentVC)
        }
    }
}
fileprivate extension MenuContainerViewController {
    func setCurrentView(_ selectedContentVC: UIViewController) {
        addChildViewController(selectedContentVC)
        view.addSubviewWithFullSizeConstraints(view: selectedContentVC.view)
        currentContentViewController = selectedContentVC
    }
    func presentNavigationMenu() {
        if menuViewController == nil {
            fatalError("Invalid `menuViewController` value. It should not be nil")
        }
        present(menuViewController, animated: true, completion: nil)
        isShown = true
    }
    func dismissNavigationMenu() {
        self.dismiss(animated: true, completion: nil)
        isShown = false
    }
}
extension UIView {
    func addSubviewWithFullSizeConstraints(view : UIView) {
        insertSubviewWithFullSizeConstraints(view: view, atIndex: subviews.count)
    }
    func insertSubviewWithFullSizeConstraints(view : UIView, atIndex: Int) {
        view.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(view, at: atIndex)
        let top = view.topAnchor.constraint(equalTo: self.topAnchor)
        let leading = view.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
    }
}
