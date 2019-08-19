//
//  ExampleCollectionViewModel.swift
//  RxIndexPathDataSource
//
//  Created by 조세상 on 2019/08/18.
//  Copyright © 2019 조세상. All rights reserved.
//

import RxCocoa
import RxSwift
import RxIndexPathDataSource

fileprivate enum Action {
  case reload(sections: [SectionOfCustomData])
  case insert(item: Int)
  case delete
  case reloadRow(item: Int)
}

class ExampleCollectionViewModel {

  struct Input {
    let reload: Observable<Void>
    let appendAtFirst: Observable<Void>
    let deleteAtLast: Observable<Void>
    let reloadFirst: Observable<Void>
  }

  struct Output {
    let items: Driver<CollectionViewSectionIndexPathModel<SectionOfCustomData>>
  }

  func transform(input: Input) -> Output {

    let reloadMap = input.reload
      .map { _ -> [SectionOfCustomData] in
        let dataOne = CustomData(int: 0)
        let sectionOne = SectionOfCustomData(items: [dataOne])
        return [sectionOne]
      }
      .map { Action.reload(sections: $0) }

    let insertMap = input.appendAtFirst
      .map { _ -> Action in
        return Action.insert(item: Int.random(in: 0...100))
    }

    let dropMap = input.deleteAtLast
      .map { _ -> Action in
        return Action.delete
    }

    let reloadFirstMap = input.reloadFirst
      .map { _ -> Action in
        return Action.reloadRow(item: Int.random(in: 0...100))
    }


    let items = Observable.merge(
      reloadMap,
      insertMap,
      dropMap,
      reloadFirstMap
      )
      .scan(self.defaultIndexPathModel()) { (indexModel, action) -> CollectionViewSectionIndexPathModel<SectionOfCustomData> in

        switch action {
        case .reload(sections: let sections):
          return .init(
            sections: sections,
            action: .reloadData
          )
        case .insert(item: let item):
          var sections = indexModel.sections
          sections[0].insert(item: item, at: 0)
          return .init(
            sections: sections,
            action: .insertItems(at:
              [IndexPath(item: 0, section: 0)]
            )
          )
        case .delete:
          var sections = indexModel.sections
          let count = sections[0].items.count
          guard count > 0 else { return self.defaultIndexPathModel() }
          sections[0].dropLast()
          return .init(
            sections: sections,
            action: .deleteItems(at:
              [IndexPath(item: count-1, section: 0)]
            )
          )
        case .reloadRow(let item):
          var sections = indexModel.sections
          let count = sections[0].items.count
          guard count > 0 else { return self.defaultIndexPathModel() }
          sections[0].modify(item: item, at: 0)
          return .init(
            sections: sections,
            action: .reloadItems(at:
              [IndexPath(item: 0, section: 0)]
            )
          )
        }
      }
      .asDriver(onErrorJustReturn: self.defaultIndexPathModel())

    return Output(items: items)
  }

  func defaultIndexPathModel() -> CollectionViewSectionIndexPathModel<SectionOfCustomData> {
    let section = SectionOfCustomData(items: [])
    return .init(sections: [section], action: .reloadData)
  }
}
