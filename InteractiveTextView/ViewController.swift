//
//  ViewController.swift
//  InteractiveTextView
//
//  Created by Grigoriy Sukhorukov on 28.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let textView = InteractiveTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView)
        
        let text = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce pellentesque sit amet nisl sit amet dictum. Ut rutrum augue nulla, id tempor leo dictum non. Vestibulum faucibus dui nec urna convallis sagittis. Donec a eros tincidunt, tincidunt lectus et, pulvinar velit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Morbi non mi ac eros porta auctor. Sed sit amet risus enim. Nam ut gravida tellus. Maecenas convallis vitae tellus ut vestibulum. Maecenas ut metus venenatis est scelerisque pharetra quis vel metus. Morbi libero velit, lacinia id ligula quis, eleifend lobortis urna. Quisque magna mauris, mattis et ex pulvinar, posuere condimentum nulla. Duis eget pulvinar nulla. Quisque iaculis dui purus, sollicitudin pretium magna dictum eu. Morbi urna arcu, feugiat eget aliquet nec, efficitur eu diam.
        
        Proin ut vestibulum purus. Aliquam lacinia efficitur gravida. Praesent mi ante, lacinia id pharetra eleifend, pretium at odio. Phasellus vestibulum laoreet quam et vulputate. Ut eget efficitur erat. Donec et nisi id velit condimentum venenatis ornare sed tellus. Sed bibendum, nunc vel molestie maximus, lectus eros aliquet est, non pharetra augue augue vel diam. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Integer ut tellus sollicitudin, euismod ipsum nec, feugiat lacus. Vestibulum id orci augue. Ut ut quam ac eros ultricies auctor nec sed massa. Morbi blandit purus at velit eleifend, at cursus lectus luctus. Mauris luctus ligula ex, id lobortis sapien gravida ac. Morbi molestie sit amet turpis vitae fermentum. Sed turpis urna, sagittis sed consectetur eget, faucibus et risus.
        """
        let attributedString = NSMutableAttributedString(string: text)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)]
        attributedString.addAttributes(attributes, range: attributedString.range)
        
        
        let exampleURL = URL(string: "google.com")!
        textView.attributedText = attributedString
            .linkAttributes("ipsum dolor sit amet", url: exampleURL)
            .linkAttributes("Aliquam lacinia efficitur gravida. Praesent mi ante, lacinia id pharetra eleifend, pretium at odio. Phasellus vestibulum laoreet quam", url: exampleURL)
        
        textView.linkAttributes = [.foregroundColor: UIColor.green]
        textView.highlightedLinkAttributes = [.foregroundColor: UIColor.green.withAlphaComponent(0.6)]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.frame = view.bounds.inset(by: view.safeAreaInsets)
        textView.setNeedsDisplay()
    }

}

