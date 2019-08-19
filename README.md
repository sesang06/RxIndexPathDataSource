# RxIndexPathDataSource

[![CI Status](https://img.shields.io/travis/sesang06/RxIndexPathDataSource.svg?style=flat)](https://travis-ci.org/sesang06/RxIndexPathDataSource)
[![Version](https://img.shields.io/cocoapods/v/RxIndexPathDataSource.svg?style=flat)](https://cocoapods.org/pods/RxIndexPathDataSource)
[![License](https://img.shields.io/cocoapods/l/RxIndexPathDataSource.svg?style=flat)](https://cocoapods.org/pods/RxIndexPathDataSource)
[![Platform](https://img.shields.io/cocoapods/p/RxIndexPathDataSource.svg?style=flat)](https://cocoapods.org/pods/RxIndexPathDataSource)


## Rx Extensions of simple Animated TableView and CollectionView DataSource, based by traditional IndexPath Style

<img src="https://github.com/sesang06/RxIndexPathDataSource/blob/master/preview/preview.gif?raw=true" width="187" height="333"/>

### Explaination
If you use RxDataSources and animate cell, Your data model should conform to IdentifiableType and Equatable.

However, I just want to call below functions, to control animatation.

```swift
func insertRows(at: [IndexPath], with: UITableView.RowAnimation)
Inserts rows in the table view at the locations identified by an array of index paths, with an option to animate the insertion.

func deleteRows(at: [IndexPath], with: UITableView.RowAnimation)
Deletes the rows specified by an array of index paths, with an option to animate the deletion.
```

So I made some code and example code, and copy from Some code from RxDataSource.

## Requirements
you should install RxSwift, RxCocoa, RxDataSources.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

RxIndexPathDataSource is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RxIndexPathDataSource'
```


## Usage

### Define Model

Given the following custom data structure:
```swift
struct CustomData {
  var anInt: Int
  var aString: String
  var aCGPoint: CGPoint
}
```

1) Start by defining your sections with a struct that conforms to the `SectionModelType` protocol:
  - define the `Item` typealias: equal to the type of items that the section will contain
  - declare an `items` property: of type array of `Item`

```swift
struct SectionOfCustomData {
  var header: String    
  var items: [Item]
}
extension SectionOfCustomData: SectionModelType {
  typealias Item = CustomData

   init(original: SectionOfCustomData, items: [Item]) {
    self = original
    self.items = items
  }
}
```

### When You Bind TableView

2) Choose what action to do, by `UITableViewAction`:

```swift
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


```

3) With your data conforming `SectionModelType` and  `UITableViewAction`, map `TableViewSectionIndexPathModel` generics:
```swift
let data = SectionOfCustomData(items: [])
let action = UITableViewAction.reloadData
let indexPathModel = TableViewSectionIndexPathModel<SectionOfCustomData>(sections: [data], action: action)
```

4) create `RxTableViewSectionedReloadDataSource`:

```swift
let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(
  configureCell: { dataSource, tableView, indexPath, item in
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = "Item \(item.anInt): \(item.aString) - \(item.aCGPoint.x):\(item.aCGPoint.y)"
    return cell
})
```
you have to bind `TableViewSectionIndexPathModel` struct to your tableView.

```swift
let data = SectionOfCustomData(items: [])
let action = UITableViewAction.reloadData
let indexPathModel = TableViewSectionIndexPathModel<SectionOfCustomData>(sections: [data], action: action)

Observable.just(indexPathModel)
  .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
  .disposed(by: self.disposeBag)
```

### When You Bind CollectionView

2) Choose what action to do, by `UITableViewAction`:

```swift
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
```

3) With your data conforming `SectionModelType` and  `UICollectionViewAction`, map `CollectionViewSectionIndexPathModel` generics:
```swift
let data = SectionOfCustomData(items: [])
let action = UICollectionViewAction.reloadData
let indexPathModel = CollectionViewSectionIndexPathModel<SectionOfCustomData>(sections: [data], action: action)
```

4) create `RxCollectionViewSectionedIndexPathDataSource`:

```swift
let dataSource = RxCollectionViewSectionedIndexPathDataSource<SectionOfCustomData>(
configureCell: { dataSource, collectionView, indexPath, item in
    let cell = collectionView.dequeueReusableCell(
    withReuseIdentifier: "Cell",
    for: indexPath
    ) as! TextLabelCell
    cell.textLabel.text = "Item \(item.int)"
    return cell
})
```
you have to bind `CollectionViewSectionIndexPathModel` struct to your tableView.

```swift
let data = SectionOfCustomData(items: [])
let action = UICollectionViewAction.reloadData
let indexPathModel = CollectionViewSectionIndexPathModel<SectionOfCustomData>(sections: [data], action: action)
Observable.just(indexPathModel)
  .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
  .disposed(by: self.disposeBag)
```



## Full Example Code

### Model
```swift
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
```
### ViewModel
```swift
import RxSwift
import RxCocoa
import RxIndexPathDataSource


fileprivate enum Action {
  case reload(sections: [SectionOfCustomData])
  case insert(item: Int)
  case delete
  case reloadRow(item: Int)
}

class ExampleTableViewModel {

  struct Input {
    let reload: Observable<Void>
    let appendAtFirst: Observable<Void>
    let deleteAtLast: Observable<Void>
    let reloadFirst: Observable<Void>
  }

  struct Output {
    let items: Driver<TableViewSectionIndexPathModel<SectionOfCustomData>>
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
      .scan(self.defaultIndexPathModel()) { (indexModel, action) -> TableViewSectionIndexPathModel<SectionOfCustomData> in
        switch action {
        case .reload(sections: let sections):
          return TableViewSectionIndexPathModel<SectionOfCustomData>(
            sections: sections,
            action: .reloadData
          )
        case .insert(item: let item):
          var sections = indexModel.sections
          sections[0].insert(item: item, at: 0)
          return .init(
            sections: sections,
            action: .insertRows(at:
              [IndexPath(item: 0, section: 0)]
            )
          )
        case .delete:
          var sections = indexModel.sections
          let count = sections[0].items.count
          guard count > 0 else
          { return self.defaultIndexPathModel() }
          sections[0].dropLast()
          return .init(
            sections: sections,
            action: .deleteRows(at:
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
            action: .reloadRows(at:
              [IndexPath(item: 0, section: 0)]
            )
          )
        }
      }
      .asDriver(onErrorJustReturn: self.defaultIndexPathModel())

    return Output(items: items)
  }

  func defaultIndexPathModel() -> TableViewSectionIndexPathModel<SectionOfCustomData> {
    let section = SectionOfCustomData(items: [])
    return .init(sections: [section], action: .reloadData)
  }
}


```

### ViewController
```swift
import UIKit
import RxSwift
import RxCocoa
import RxIndexPathDataSource



class ExampleTableViewController: UIViewController {


  // MARK: UI

  @IBOutlet var tableView: UITableView!

  @IBOutlet var reloadButton: UIButton!

  @IBOutlet var insertButton: UIButton!

  @IBOutlet var deleteButton: UIButton!

  @IBOutlet var modifyButton: UIButton!

  // MARK: dataSource

  let dataSource = RxTableViewSectionedIndexPathDataSource<SectionOfCustomData>(
    configureCell: { dataSource, tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      cell.textLabel?.text = "Item \(item.int)"
      return cell
  })

  // MARK: disposeBag

  var disposeBag = DisposeBag()

  private let reloadSubject = PublishSubject<Void>()

  private let appendAtFirstSubject = PublishSubject<Void>()

  private let deleteAtLastSubject = PublishSubject<Void>()

  private let modifyAtFirstSubject = PublishSubject<Void>()


  override func viewDidLoad() {
    super.viewDidLoad()
    self.bind()
  }

  // MARK: Bind

  private func bind() {

    let viewModel = ExampleTableViewModel()
    let input = ExampleTableViewModel.Input(
      reload: self.reloadSubject,
      appendAtFirst: self.appendAtFirstSubject,
      deleteAtLast: self.deleteAtLastSubject,
      reloadFirst: modifyAtFirstSubject
    )

    let output = viewModel.transform(input: input)

    self.reloadButton.rx.tap
      .bind(to: self.reloadSubject)
      .disposed(by: self.disposeBag)
    self.insertButton.rx.tap
      .bind(to: self.appendAtFirstSubject)
      .disposed(by: self.disposeBag)
    self.deleteButton.rx.tap
      .bind(to: self.deleteAtLastSubject)
      .disposed(by: self.disposeBag)
    self.modifyButton.rx.tap
      .bind(to: self.modifyAtFirstSubject)
      .disposed(by: self.disposeBag)

    output.items
      .asObservable()
      .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
  }
}


```


## Author

sesang06, sesang06@naver.com

## License

RxIndexPathDataSource is available under the MIT license. See the LICENSE file for more info.
