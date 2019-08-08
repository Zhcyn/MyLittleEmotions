import Foundation
public struct SpringParams {
    let dampingRatio: CGFloat
    let velocity: CGFloat
    public init(dampingRatio: CGFloat, velocity: CGFloat) {
        self.dampingRatio = dampingRatio
        self.velocity = velocity
    }
}
public struct SpringSettings {
    let presentSpringParams: SpringParams
    let dismissSpringParams: SpringParams
    public init(presentSpringParams: SpringParams, dismissSpringParams: SpringParams) {
        self.presentSpringParams = presentSpringParams
        self.dismissSpringParams = dismissSpringParams
    }
}
public struct TransitionOptions {
    public var duration: TimeInterval {
        willSet {
            if newValue < 0 {
                fatalError("Invalid `duration` value (\(newValue)). It must be non negative")
            }
        }
    }
    public var contentScale: CGFloat {
        willSet {
            if newValue < 0 {
                fatalError("Invalid `contentScale` value (\(newValue)). It must be non negative")
            }
        }
    }
    public var visibleContentWidth: CGFloat
    public var useFinishingSpringSettings = true
    public var useCancellingSpringSettings = true
    public var finishingSpringSettings = SpringSettings(presentSpringParams: SpringParams(dampingRatio: 0.7, velocity: 0.3),
                                                        dismissSpringParams: SpringParams(dampingRatio: 0.8, velocity: 0.3))
    public var cancellingSpringSettings = SpringSettings(presentSpringParams: SpringParams(dampingRatio: 0.7, velocity: 0.0),
                                                         dismissSpringParams: SpringParams(dampingRatio: 0.7, velocity: 0.0))
    public var animationOptions: UIViewAnimationOptions = .curveEaseInOut
    public init(duration: TimeInterval = 0.5, contentScale: CGFloat = 0.86, visibleContentWidth: CGFloat = 56.0) {
        self.duration = duration
        self.contentScale = contentScale
        self.visibleContentWidth = visibleContentWidth
    }
}
