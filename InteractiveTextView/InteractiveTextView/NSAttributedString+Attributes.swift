//
//  NSAttributedString+Attributes.swift
//  InteractiveTextView
//
//  Created by Grigoriy Sukhorukov on 16.08.2021.
//

import Foundation

extension NSAttributedString {
    internal var range: NSRange {
        return NSRange(location: 0, length: length)
    }
    
    func rangesOfAttribute(_ key: Key) -> [NSRange] {
        var ranges: [NSRange] = []
        enumerateAttributes(in: range, options: []) { attributes, range, _ in
            if attributes[key] != nil {
                ranges.append(range)
            }
        }
        return ranges
    }
    
    func linkAttributes(_ substring: String, url: URL) -> NSAttributedString {
        let linkRange = (string as NSString).range(of: substring, options: .caseInsensitive)
        guard linkRange.length > 0 else {
            return self
        }
        
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttributes([InteractiveTextView.linkAttributeName: url], range: linkRange)
        
        return attributedString
    }
}
