import UIKit

class TextView: UITextView {
    
    var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    var placeholderColor: UIColor? {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    var minimumHeight: CGFloat = 0 {
        didSet {
            if minHeightConstraint == nil {
                minHeightConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: minimumHeight)
                minHeightConstraint?.isActive = true
            } else {
                minHeightConstraint?.constant = minimumHeight
            }
            
            setNeedsLayout()
        }
    }
    
    var maxHeight: CGFloat = 300
    
    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
            invalidateIntrinsicContentSize()
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    private let placeholderLabel = UILabel()
    private var minHeightConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(placeholderLabel)
        
        placeholderLabel.isHidden = !text.isEmpty
        isScrollEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
        
        setupConstraints()
    }
    
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let fixedWidth = frame.size.width - contentInset.left - contentInset.right
        let newSize = sizeThatFits(CGSize(width: fixedWidth,
                                          height: CGFloat.greatestFiniteMagnitude))
        var newHeight = max(newSize.height, minimumHeight)
        if newHeight > maxHeight {
            newHeight = maxHeight
            isScrollEnabled = true
        } else {
            isScrollEnabled = false
        }
        
        heightConstraint?.constant = newHeight
        
        return CGSize(width: superContentSize.width, height: newHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let fixedWidth = frame.size.width - contentInset.left - contentInset.right
        let newSize = sizeThatFits(CGSize(width: fixedWidth,
                                          height: CGFloat.greatestFiniteMagnitude))
        var newHeight = max(newSize.height, minimumHeight)
        if newHeight > maxHeight {
            newHeight = maxHeight
            isScrollEnabled = true
        } else {
            isScrollEnabled = false
        }
        
        heightConstraint?.constant = newHeight
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        if let textView = notification.object as? TextView {
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
    }
    
    private func setupConstraints() {
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        ])
        
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
