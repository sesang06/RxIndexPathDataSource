//
//  CustomData.swift
//  RxIndexPathDataSource
//
//  Created by 조세상 on 2019/08/16.
//  Copyright © 2019 조세상. All rights reserved.
//

import RxDataSources

struct CustomData {
  var int: Int
}

struct SectionOfCustomData {
  var items: [Item]
}

extension SectionOfCustomData: SectionModelType {
  typealias Item = CustomData

  init(original: SectionOfCustomData, items: [Item]) {
    self = original
    self.items = items
  }
}

extension SectionOfCustomData {
  mutating func insert(item: Int, at: Int) {
    let customData = CustomData(int: item)
    var items = self.items
    items.insert(customData, at: at)
    self.items = items
  }

  mutating func dropLast() {
    let items = self.items
    self.items = items.dropLast()
  }

  mutating func modify(item: Int, at: Int) {
    let customData = CustomData(int: item)
    var items = self.items
    items[at] = customData
    self.items = items
  }
}
