import UIKit

class ModalScrollViewController: UIViewController {
    
    open var ignoreBottomSafeArea: Bool = false
    open var modalView: ModalView!

    open var contentHeight: CGFloat = 100 {
        didSet {
            if oldValue != contentHeight {
                updateContentSize(forceUpdateInset: true)
            }
        }
    }

    open var contentWidth: CGFloat {
        get {
            return scrollView.frame.width
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    var skipInsetUpdate = false
    var locked = false
    var shown = false

    
    let hideHelper: UIView = .init()

    let blackoutView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.6)
        
        return view
    }()

    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.autoresizingMask = .flexibleHeight
        view.alwaysBounceVertical = true
        view.contentInsetAdjustmentBehavior = .never
        view.contentInset.bottom = 0
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()

    let hideIndicatorContainer: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 12
        view.backgroundColor = R.color.bgPrimary()
        
        return view
    }()
    
    let hideIndicatorView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 32.0, height: 5.0)))
        view.layer.cornerRadius = 5/2
        view.backgroundColor = R.color.bgThird()
        
        return view
    }()
    
    private let hideIndicatorContainerHeight = 21.0

    init() {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        isModalInPresentation = false
        transitioningDelegate = self
        modalPresentationCapturesStatusBarAppearance = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blackoutView)
        view.addSubview(scrollView)
        
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        scrollView.addSubview(hideIndicatorContainer)
        scrollView.addSubview(hideHelper)
        scrollView.addSubview(modalView)
            
        hideIndicatorContainer.addSubview(hideIndicatorView)
        
        setupViews()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        updateContentSize()
        
        hideHelper.frame = CGRect(
                origin: .init(x: 0, y: -scrollView.contentInset.top),
                size: .init(width: contentWidth, height: scrollView.contentInset.top)
        )
        
        hideIndicatorContainer.frame = CGRect(
            origin: .init(x: 0, y: -hideIndicatorContainerHeight),
            size: .init(width: scrollView.frame.width, height: hideIndicatorContainerHeight)
        )
        
        hideIndicatorView.frame.origin = CGPoint(
                x: (contentWidth - hideIndicatorView.frame.width) / 2,
                y: 16
        )
        
        modalView.snp.remakeConstraints { make in
            make.top.equalTo(hideIndicatorContainer.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(contentWidth)
        }
        
        modalView.layoutIfNeeded()
        
        let bottomInset = ignoreBottomSafeArea ? 0 : view.safeAreaInsets.bottom
        contentHeight = modalView.contentHeight + bottomInset
    }
    
    override func loadView() {
        super.loadView()
        loadModalView()
    }
    
    func loadModalView() {
        modalView = ModalView()
    }

    func updateContentSize(forceUpdateInset: Bool = false) {
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        if !skipInsetUpdate || forceUpdateInset {
            updateInset(animate: forceUpdateInset)
        }
    }

    func updateInset(animate: Bool) {
        let inset = max(50, view.bounds.height - contentHeight)
        
        if animate {
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentInset.top = inset
            }
        } else {
            scrollView.contentInset.top = inset
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        skipInsetUpdate = true
    }

    func hide(completion: (() -> Swift.Void)? = nil) {
        locked = true
        view.isUserInteractionEnabled = false
        dismiss(animated: true, completion: completion)
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        scrollView.frame = view.frame
        blackoutView.frame = view.frame
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(hideHelperDidPress))
        hideHelper.addGestureRecognizer(tapGesture)
    }
}

fileprivate extension ModalScrollViewController {
    @objc func hideHelperDidPress() {
        hide()
    }
}


extension ModalScrollViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if locked {
            return
        }
        
        let topSafeArea = UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0.0

        if scrollView.contentOffset.y < -topSafeArea {
            let offset = min(0, scrollView.contentOffset.y + topSafeArea + scrollView.contentInset.top)
            let alpha = 1 - max(0, -(offset / (scrollView.contentSize.height)))
            blackoutView.alpha = alpha
        } else {
            blackoutView.alpha = 1
        }
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if locked {
            return
        }
        if scrollView.contentOffset.y + scrollView.contentInset.top <= -70 {
            hide()
        }
    }
}

// - MARK: UIViewControllerTransitioningDelegate

extension ModalScrollViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalScrollAnimation(presenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalScrollAnimation(presenting: false)
    }
}
