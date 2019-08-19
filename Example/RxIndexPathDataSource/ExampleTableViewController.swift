//
//  ExampleTableViewController.swift
//  RxIndexPathDataSource
//
//  Created by 조세상 on 2019/08/11.
//  Copyright © 2019 조세상. All rights reserved.
//

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
