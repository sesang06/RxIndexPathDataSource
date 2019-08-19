//
//  ExampleCollectionViewController.swift
//  RxIndexPathDataSource
//
//  Created by 조세상 on 2019/08/18.
//  Copyright © 2019 조세상. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxIndexPathDataSource


class ExampleCollectionViewController: UIViewController {


  // MARK: UI

  @IBOutlet var collectionView: UICollectionView!

  @IBOutlet var reloadButton: UIButton!

  @IBOutlet var insertButton: UIButton!

  @IBOutlet var deleteButton: UIButton!

  @IBOutlet var modifyButton: UIButton!


  // MARK: DataSource

  let dataSource = RxCollectionViewSectionedIndexPathDataSource<SectionOfCustomData>(
    configureCell: { dataSource, collectionView, indexPath, item in
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: "Cell",
        for: indexPath
        ) as! TextLabelCell
      cell.textLabel.text = "Item \(item.int)"
      return cell
  })

  // MARK: DisposeBag

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

    let viewModel = ExampleCollectionViewModel()

    let input = ExampleCollectionViewModel.Input(
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
      .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
  }
}

