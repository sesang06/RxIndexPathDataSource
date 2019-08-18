//
//  RxTableViewSectionedIndexPathDataSource.swift
//  RxIndexPathDataSource
//
//  Created by 조세상 on 2019/08/11.
//  Copyright © 2019 조세상. All rights reserved.
//

#if os(iOS) || os(tvOS)
import Foundation
import UIKit
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
import RxDataSources
#endif

//public protocol

open class RxTableViewSectionedIndexPathDataSource<Section: SectionModelType>
: TableViewSectionedDataSource<Section>, RxTableViewDataSourceType {
  /// Type of elements that can be bound to table view.

  public typealias Element = TableViewSectionIndexPathModel<Section>
  var dataSet = false
  open func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
    Binder(self) { dataSource, sectionIndexPath in

      if !dataSource.dataSet {
        dataSource.dataSet = true
        dataSource.setSections(sectionIndexPath.sections)
        tableView.reloadData()
      }
      else {
        if tableView.window == nil {
          dataSource.setSections(sectionIndexPath.sections)
          tableView.reloadData()
          return
        }

        switch sectionIndexPath.action {
        case .insertRows(let indexPaths):
          tableView.beginUpdates()
          dataSource.setSections(sectionIndexPath.sections)
          tableView.insertRows(at: indexPaths, with: .automatic)
          tableView.endUpdates()
        case .deleteRows(let indexPaths):
          tableView.beginUpdates()
          dataSource.setSections(sectionIndexPath.sections)
          tableView.deleteRows(at: indexPaths, with: .automatic)
          tableView.endUpdates()
        case .reloadData:
          dataSource.setSections(sectionIndexPath.sections)
          tableView.reloadData()
        case .insertSections(let sections):
          tableView.beginUpdates()
          dataSource.setSections(sectionIndexPath.sections)
          tableView.insertSections(sections, with: .automatic)
          tableView.endUpdates()
        case .deleteSections(let sections):
          tableView.beginUpdates()
          dataSource.setSections(sectionIndexPath.sections)
          tableView.deleteSections(sections, with: .automatic)
          tableView.endUpdates()
        case .moveRow(let at, let to):
          tableView.beginUpdates()
          dataSource.setSections(sectionIndexPath.sections)
          tableView.moveRow(at: at, to: to)
          tableView.endUpdates()
        case .moveSection(let from, let to):
          tableView.beginUpdates()
          dataSource.setSections(sectionIndexPath.sections)
          tableView.moveSection(from, to: to)
          tableView.endUpdates()
        case .reloadRows(let at):
          tableView.beginUpdates()
          dataSource.setSections(sectionIndexPath.sections)
          tableView.reloadRows(at: at, with: .automatic)
          tableView.endUpdates()
        case .reloadSections(let sections):
          tableView.beginUpdates()
          dataSource.setSections(sectionIndexPath.sections)
          tableView.reloadSections(sections, with: .automatic)
          tableView.endUpdates()
        case .reloadSectionIndexTitles:
          tableView.beginUpdates()
          dataSource.setSections(sectionIndexPath.sections)
          tableView.reloadSectionIndexTitles()
          tableView.endUpdates()
        }
      }

      }.on(observedEvent)
  }
}
#endif
