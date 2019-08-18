//
//  UICollectionViewAction.swift
//  RxIndexPathDataSource
//
//  Created by 조세상 on 2019/08/18.
//  Copyright © 2019 조세상. All rights reserved.
//

import RxDataSources

public enum UICollectionViewAction {
  /// Inserts new items at the specified index paths.
  case insertItems(at: [IndexPath])
  /// Moves an item from one location to another in the collection view.
  case moveItem(at: IndexPath, to: IndexPath)
  /// Deletes the items at the specified index paths.
  case deleteItems(at: [IndexPath])
  /// Inserts new sections at the specified indexes.
  case insertSections(sections: IndexSet)
  /// Moves a section from one location to another in the collection view.
  case moveSection(at: Int, to: Int)
  /// Deletes the sections at the specified indexes.
  case deleteSections(sections: IndexSet)
  /// Reloads all of the data for the collection view.
  case reloadData
  /// Reloads the data in the specified sections of the collection view.
  case reloadSections(sections: IndexSet)
  /// Reloads just the items at the specified index paths.
  case reloadItems(at: [IndexPath])
}


public struct CollectionViewSectionIndexPathModel<Section: SectionModelType> {

  public let sections: [Section]

  public let action: UICollectionViewAction

  public init(sections: [Section], action: UICollectionViewAction) {
    self.sections = sections
    self.action = action
  }
}
