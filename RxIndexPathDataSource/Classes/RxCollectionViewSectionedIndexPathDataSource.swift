//
//  RxCollectionViewSectionedIndexPathDataSource.swift
//  RxIndexPathDataSource
//
//  Created by 조세상 on 2019/08/18.
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

open class RxCollectionViewSectionedIndexPathDataSource<Section: SectionModelType>
: CollectionViewSectionedDataSource<Section>, RxCollectionViewDataSourceType {


  /// Type of elements that can be bound to table view.

  public typealias Element = CollectionViewSectionIndexPathModel<Section>
  var dataSet = false
  public func collectionView(_ collectionView: UICollectionView, observedEvent: Event<CollectionViewSectionIndexPathModel<Section>>) {
    Binder(self) { dataSource, sectionIndexPath in

      if !dataSource.dataSet {
        dataSource.dataSet = true
        dataSource.setSections(sectionIndexPath.sections)
        collectionView.reloadData()
      }
      else {
        if collectionView.window == nil {
          dataSource.setSections(sectionIndexPath.sections)
          collectionView.reloadData()
          return
        }
        switch sectionIndexPath.action {
        case .insertItems(let at):
          dataSource.setSections(sectionIndexPath.sections)
          collectionView.insertItems(at: at)
        case .moveItem(let at, let to):
          dataSource.setSections(sectionIndexPath.sections)
          collectionView.moveItem(at: at, to: to)
        case .deleteItems(let at):
          dataSource.setSections(sectionIndexPath.sections)
          collectionView.deleteItems(at: at)
        case .insertSections(let sections):
          dataSource.setSections(sectionIndexPath.sections)
          collectionView.insertSections(sections)
        case .moveSection(let at, let to):
          dataSource.setSections(sectionIndexPath.sections)
          collectionView.moveSection(at, to: to)
        case .deleteSections(let sections):
          dataSource.setSections(sectionIndexPath.sections)
          collectionView.deleteSections(sections)
        case .reloadData:
          dataSource.setSections(sectionIndexPath.sections)
          collectionView.reloadData()
        case .reloadSections(let sections):
          dataSource.setSections(sectionIndexPath.sections)
          collectionView.reloadSections(sections)
        case .reloadItems(let at):
          dataSource.setSections(sectionIndexPath.sections)
          collectionView.reloadItems(at: at)

        }
      }

      }.on(observedEvent)
  }
}
#endif
