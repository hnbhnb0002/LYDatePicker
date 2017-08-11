//
//  SmartDatePickerCell.swift
//  LYDatePickerDemo
//
//  Created by 罗源 on 2017/6/9.
//  Copyright © 2017年 罗源. All rights reserved.
//

import UIKit

class SmartDatePickerCell: UICollectionViewCell {
    var dateLabel : UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        dateLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        dateLabel.textAlignment = .center
        dateLabel.textColor = lightGrayColor_9
        dateLabel.font = UIFont.systemFont(ofSize: 20)
        self.contentView.addSubview(dateLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
