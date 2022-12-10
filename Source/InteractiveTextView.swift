import UIKit

public protocol InteractiveTextViewDelegate: NSObjectProtocol {
    func textView(_ textView: InteractiveTextView, didPressOnAttribute attribute: TextAttribute)
    func textView(_ textView: InteractiveTextView, didLongpressOnAttribute attribute: TextAttribute)
}

open class InteractiveTextView: UIView {
    public static let linkAttributeName: NSAttributedString.Key = NSAttributedString.Key.init("InteractiveTextLinkAttribute")

    public weak var delegate: InteractiveTextViewDelegate?
    public var highlightBubbleColor: UIColor?
    public var highlightBubbleInsets: UIEdgeInsets = .zero
    public var highlightBubbleRadius: CGFloat = 4.0
    
    public var isLongpressEnabled = false {
        didSet {
            longPressGestureRecognizer.isEnabled = isLongpressEnabled
        }
    }
    
    private var heightConstraint: NSLayoutConstraint!
    private var lastWidth: CGFloat = 0.0
    public var isHeightConstraintEnabled = false {
        didSet {
            heightConstraint.isActive = isHeightConstraintEnabled
        }
    }
    
    public var attributedText: NSAttributedString? {
        didSet {
            if let attributedString = attributedText {
                textRenderer.textStorage.setAttributedString(attributedString)
            } else {
                textRenderer.textStorage.setAttributedString(NSAttributedString())
            }
            accessibilityLabel = attributedText?.string
            prepareAttributedString()
            setNeedsDisplay()
        }
    }
    
    public var linkAttributes: [NSAttributedString.Key : Any] = [:] {
        didSet {
            prepareAttributedString()
            setNeedsDisplay()
        }
    }
    
    public var highlightedLinkAttributes: [NSAttributedString.Key : Any] = [:] {
        didSet {
            prepareAttributedString()
            setNeedsDisplay()
        }
    }
        
    private var pressAttribute: TextAttribute? {
        didSet {
            prepareAttributedString()
            setNeedsDisplay()
        }
    }
    
    private let textRenderer = InteractiveTextRenderer()
    private let longPressGestureRecognizer = UILongPressGestureRecognizer()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialConfiguration()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialConfiguration()
    }
    
    private func initialConfiguration() {
        backgroundColor = .clear
        clipsToBounds = false
        isExclusiveTouch = true
        isAccessibilityElement = true
        accessibilityTraits = .staticText
        layer.contentsGravity = .bottomLeft
        longPressGestureRecognizer.addTarget(self, action: #selector(didLongPress))
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.isEnabled = isLongpressEnabled
        addGestureRecognizer(longPressGestureRecognizer)
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
    }
    
    private func prepareAttributedString() {
        textRenderer.textStorage.rangesOfAttribute(Self.linkAttributeName).forEach { range in
            textRenderer.textStorage.addAttributes(linkAttributes, range: range)
        }
        if let pressAttribute = pressAttribute {
            textRenderer.textStorage.addAttributes(highlightedLinkAttributes, range: pressAttribute.range)
        }
    }
    
    public override var bounds: CGRect {
        didSet {
            if isHeightConstraintEnabled && lastWidth != bounds.width {
                lastWidth = bounds.width
                let size = sizeThatFits(CGSize(width: bounds.width, height: .greatestFiniteMagnitude))
                heightConstraint.constant = size.height
            }
        }
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return textRenderer.sizeThatFits(size)
    }

    // MARK: - Draw
    public override func draw(_ rect: CGRect) {
        if let linkAttributeContainer = pressAttribute,
           linkAttributeContainer.range.length > 0,
           let highlightColor = highlightBubbleColor {
            drawHighlight(forContainer: linkAttributeContainer, color: highlightColor)
        }
        textRenderer.draw(rect)
    }
    
    private func drawHighlight(forContainer container: TextAttribute, color: UIColor) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        
        var path: UIBezierPath?
        for lineFrame in container.lineFrames {
            let bezierRect = lineFrame.inset(by: highlightBubbleInsets)
            let bezierPath = UIBezierPath(roundedRect: bezierRect, cornerRadius: highlightBubbleRadius)
            if let path = path {
                path.append(bezierPath)
            } else {
                path = bezierPath
            }
        }
        
        if let path = path {
            color.setFill()
            path.fill()
        }

        context.restoreGState()
    }
    
    // MARK: - Touches
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if !super.point(inside: point, with: event) {
            return false
        }
        
        return textRenderer.attributePosition(Self.linkAttributeName, atLocation: point) != nil
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateHighlight(forTouches: touches, with: event)
        super.touchesBegan(touches, with: event)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateHighlight(forTouches: touches, with: event)
        super.touchesMoved(touches, with: event)
    }
    
    private func updateHighlight(forTouches touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            pressAttribute = textRenderer.attributePosition(Self.linkAttributeName, atLocation: point)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let attribute = pressAttribute {
            delegate?.textView(self, didPressOnAttribute: attribute)
            pressAttribute = nil
        }
        super.touchesEnded(touches, with: event)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        pressAttribute = nil
        super.touchesCancelled(touches, with: event)
    }
    
    // MARK: - Longpress
    @objc private func didLongPress(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            let point = recognizer.location(in: self)
            let longPressAttribute = textRenderer.attributePosition(Self.linkAttributeName, atLocation: point)

            if let longPressAttribute = longPressAttribute {
                delegate?.textView(self, didLongpressOnAttribute: longPressAttribute)
            }
        }
    }
    
}

extension InteractiveTextView: UIGestureRecognizerDelegate {
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == longPressGestureRecognizer else { return false }
        let point = gestureRecognizer.location(in: self)
        let longPressAttribute = textRenderer.attributePosition(Self.linkAttributeName, atLocation: point)
        return longPressAttribute != nil
    }
}
