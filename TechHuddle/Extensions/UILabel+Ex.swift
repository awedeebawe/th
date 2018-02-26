//
//  UILabel+Ex.swift
//  TechHuddle
//
//  Created by Lyubomir Marinov on 24.02.18.
//  Copyright © 2018 http://linkedin.com/in/lmarinov/. All rights reserved.
//

import UIKit

extension UILabel {
    /// Create the label that will show the distance as the UITableViewCell's accessory view
    static func createDistanceLabel() -> UILabel {
        
        let labelFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let label = UILabel(frame: labelFrame)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray.withAlphaComponent(0.75)
        
        return label
    }
    
    /// Create the notification labels for the view controllers
    static func createNotificationLabel(withText text: String, andSubtitle subtitle: String = "", andEmoji emoji: String) -> UILabel {
        
        let emojiAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 100)]
        let attributedEmojiString = NSAttributedString(string: emoji, attributes: emojiAttributes)
        
        let textAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 24)]
        let attributedTextString = NSAttributedString(string: text, attributes: textAttributes)
        
        let subtitleAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 12)]
        let attributedSubtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        
        let fullAttributedString = NSMutableAttributedString(attributedString: attributedEmojiString)
        fullAttributedString.append(attributedTextString)
        fullAttributedString.append(attributedSubtitleString)

        let label = UILabel(frame: .zero)
        label.attributedText = fullAttributedString
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        
        return label
    }
}
