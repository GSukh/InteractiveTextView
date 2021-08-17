import UIKit

public struct TextAttribute {
    let name: NSAttributedString.Key
    let value: Any
    let range: NSRange
    let lineFrames: [CGRect]
}

internal class InteractiveTextRenderer {
    let textStorage: NSTextStorage
    private let layoutManager: NSLayoutManager
    private let textContainer: NSTextContainer
    
    private var allCharactersRange: NSRange {
        return NSRange(location: 0, length: textStorage.length)
    }
    
    private var allGlyphsRange: NSRange {
        return NSRange(location: 0, length: layoutManager.numberOfGlyphs)
    }
    
    init() {
        textStorage = NSTextStorage()
        
        layoutManager = NSLayoutManager()
        textContainer = NSTextContainer(size: .zero)
        textContainer.lineFragmentPadding = 0.0
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
    }
    
     func draw(_ rect: CGRect) {
        textContainer.size = rect.size
        layoutManager.drawGlyphs(forGlyphRange: allGlyphsRange, at: rect.origin)
    }
    
    func attributePosition(_ attrName: NSAttributedString.Key, atLocation location: CGPoint) -> TextAttribute? {
        let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        guard allCharactersRange.contains(index) else { return nil }
        
        var attributeCharacterRange = NSRange()
        let attribute = textStorage.attribute(attrName, at: index, longestEffectiveRange: &attributeCharacterRange, in: allCharactersRange)
                
        if attribute != nil {
            var lineFrames: [CGRect] = []
            
            let attributeGlyphRange = layoutManager.glyphRange(forCharacterRange: attributeCharacterRange, actualCharacterRange: nil)
            layoutManager.enumerateLineFragments(forGlyphRange: attributeGlyphRange) { (_, lineRect, textContainer, lineGlyphRange, _) in
                if attributeGlyphRange.contains(lineGlyphRange) {
                    lineFrames.append(lineRect)
                } else if let intersectionRange = attributeGlyphRange.intersection(lineGlyphRange), intersectionRange.length > 0 {
                    let intersectionFrame = self.layoutManager.boundingRect(forGlyphRange: intersectionRange, in: textContainer)
                    lineFrames.append(intersectionFrame)
                }
            }
            
            let framesContainLocation = lineFrames.contains { (lineFrame) -> Bool in
                return lineFrame.contains(location)
            }
            
            if !framesContainLocation {
                return nil
            }
            
            return TextAttribute(name: attrName, value: attribute!, range: attributeCharacterRange, lineFrames: lineFrames)
        }
        
        return nil
    }
    
    func sizeThatFits(_ size: CGSize) -> CGSize {
        textContainer.size = size

        let lastGlyph = layoutManager.numberOfGlyphs - 1
        let lastLine = layoutManager.lineFragmentRect(forGlyphAt: lastGlyph, effectiveRange: nil)

        return CGSize(width: lastLine.maxX, height: lastLine.maxY)
    }
    
}

internal extension NSRange {
    var end: Int {
        return location + length
    }
    
    func contains(_ range: NSRange) -> Bool {
        return location <= range.location && end >= range.end
    }
}
