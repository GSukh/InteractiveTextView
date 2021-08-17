//
//  ViewController.swift
//  InteractiveTextViewExample
//
//  Created by Grigoriy Sukhorukov on 17.08.2021.
//

import UIKit
import InteractiveTextView

class ViewController: UIViewController {
    
    let topTextView = InteractiveTextView()
    let bottomTextView = InteractiveTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTopTextView(topTextView)
        view.addSubview(topTextView)
        
        configureBottomTextView(bottomTextView)
        view.addSubview(bottomTextView)
    }
    
    private func configureTopTextView(_ textView: InteractiveTextView) {
        let text = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce pellentesque sit amet nisl sit amet dictum. Ut rutrum augue nulla, id tempor leo dictum non. Vestibulum faucibus dui nec urna convallis sagittis. Donec a eros tincidunt, tincidunt lectus et, pulvinar velit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Morbi non mi ac eros porta auctor. Sed sit amet risus enim. Nam ut gravida tellus. Maecenas convallis vitae tellus ut vestibulum. Maecenas ut metus venenatis est scelerisque pharetra quis vel metus. Morbi libero velit, lacinia id ligula quis, eleifend lobortis urna. Quisque magna mauris, mattis et ex pulvinar, posuere condimentum nulla. Duis eget pulvinar nulla. Quisque iaculis dui purus, sollicitudin pretium magna dictum eu. Morbi urna arcu, feugiat eget aliquet nec, efficitur eu diam.
        """
        let attributedString = NSMutableAttributedString(string: text)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)]
        attributedString.addAttributes(attributes, range: attributedString.range)
        
        
        let exampleURL = URL(string: "google.com")!
        textView.attributedText = attributedString
            .linkAttributes("ipsum dolor sit amet", url: exampleURL)
            .linkAttributes("posuere condimentum nulla. Duis eget pulvinar nulla.", url: exampleURL)
        
        textView.linkAttributes = [.foregroundColor: UIColor.systemBlue]
        textView.highlightedLinkAttributes = [.foregroundColor: UIColor.systemBlue.withAlphaComponent(0.6)]
    }
    
    private func configureBottomTextView(_ textView: InteractiveTextView) {
        let text = """
        Proin ut vestibulum purus. Aliquam lacinia efficitur gravida. Praesent mi ante, lacinia id pharetra eleifend, pretium at odio. Phasellus vestibulum laoreet quam et vulputate. Ut eget efficitur erat. Donec et nisi id velit condimentum venenatis ornare sed tellus. Sed bibendum, nunc vel molestie maximus, lectus eros aliquet est, non pharetra augue augue vel diam. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Integer ut tellus sollicitudin, euismod ipsum nec, feugiat lacus. Vestibulum id orci augue. Ut ut quam ac eros ultricies auctor nec sed massa. Morbi blandit purus at velit eleifend, at cursus lectus luctus. Mauris luctus ligula ex, id lobortis sapien gravida ac. Morbi molestie sit amet turpis vitae fermentum. Sed turpis urna, sagittis sed consectetur eget, faucibus et risus.
        """
        let attributedString = NSMutableAttributedString(string: text)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)]
        attributedString.addAttributes(attributes, range: attributedString.range)
        
        
        let exampleURL = URL(string: "google.com")!
        textView.attributedText = attributedString
            .linkAttributes("Donec et nisi id velit condimentum venenatis", url: exampleURL)
            .linkAttributes("Morbi blandit purus at velit eleifend", url: exampleURL)
        
        textView.linkAttributes = [
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
            .foregroundColor: UIColor.black
        ]
        textView.highlightedLinkAttributes = [
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
            .foregroundColor: UIColor.blue
        ]
        textView.highlightBubbleColor = UIColor.blue.withAlphaComponent(0.4)
        textView.highlightBubbleInsets = UIEdgeInsets(top: 0.0, left: -2.0, bottom: -2.0, right: -2.0)
        textView.highlightBubbleRadius = 4.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let containerRect = view.bounds.inset(by: view.safeAreaInsets)
        let topTextSize = topTextView.sizeThatFits(containerRect.size)
        let topTextOrigin = CGPoint(x: containerRect.minX, y: containerRect.minY)
        topTextView.frame = CGRect(origin: topTextOrigin, size: topTextSize)
        
        let bottomTextSize = bottomTextView.sizeThatFits(containerRect.size)
        let bottomTextOrigin = CGPoint(x: containerRect.minX, y: containerRect.minY + topTextSize.height + 12)
        bottomTextView.frame = CGRect(origin: bottomTextOrigin, size: bottomTextSize)
    }

}

