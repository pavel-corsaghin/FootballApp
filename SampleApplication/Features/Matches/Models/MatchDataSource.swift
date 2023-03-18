//
//  MatchDataSource.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/18.
//

import UIKit

typealias MatchDataSource = UICollectionViewDiffableDataSource<MatchSectionKind, MatchCellKind>
typealias MatchSnapshot = NSDiffableDataSourceSnapshot<MatchSectionKind, MatchCellKind>

enum MatchSectionKind { case main }
enum MatchCellKind: Hashable { case match(MatchCell.CellModel) }
