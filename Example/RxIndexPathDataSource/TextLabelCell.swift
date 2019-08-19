//
//  TextLabelCell.swift
//  RxIndexPathDataSource_Example
//
//  Created by 조세상 on 2019/08/20.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class TextLabelCell: UICollectionViewCell {


  @IBOutlet weak var textLabel: UILabel!

  override func prepareForReuse() {
    self.textLabel.text = nil
  }

}
