//
//  UITableViewAction.swift
//  RxIndexPathDataSource
//
//  Created by 조세상 on 2019/08/11.
//  Copyright © 2019 조세상. All rights reserved.
//

import RxDataSources

public enum UITableViewAction {
  /// Inserts rows in the table view at the locations identified by an array of index paths, with an option to animate the insertion.
  case insertRows(at: [IndexPath])
  /// Deletes the rows specified by an array of index paths, with an option to animate the deletion.
  case deleteRows(at: [IndexPath])
  /// Inserts one or more sections in the table view, with an option to animate the insertion.
  case insertSections(sections: IndexSet)
  /// Deletes one or more sections in the table view, with an option to animate the deletion.
  case deleteSections(sections: IndexSet)
  /// Moves the row at a specified location to a destination location.
  case moveRow(at: IndexPath, to: IndexPath)
  /// Moves a section to a new location in the table view.
  case moveSection(from: Int, to: Int)
  /// Reloads the rows and sections of the table view.
  case reloadData
  /// Reloads the specified rows using a given animation effect.
  case reloadRows(at: [IndexPath])
  /// Reloads the specified sections using a given animation effect.
  case reloadSections(sections: IndexSet)
  /// Reloads the items in the index bar along the right side of the table view.
  case reloadSectionIndexTitles
}


public struct TableViewSectionIndexPathModel<Section: SectionModelType> {

  public let sections: [Section]

  public let action: UITableViewAction

  public init(sections: [Section], action: UITableViewAction) {
    self.sections = sections
    self.action = action
  }
}
