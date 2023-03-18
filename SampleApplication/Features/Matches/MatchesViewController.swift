//
//  MatchesViewController.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import AVKit
import AVFoundation
import Domain
import Combine
import UIKit

protocol MatchesViewControllerDelegate: AnyObject {
    func matchesViewControllerDidViewTeamDetail(teamName: String)
}

final class MatchesViewController: BaseViewController, ViewControllable {

    // MARK: - Definitions

    typealias RootView = MatchesRootView
    typealias ViewModel = MatchesViewModel
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, CellKind>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionKind, CellKind>

    enum SectionKind {
        case previous
        case upcoming
    }
    enum CellKind: Hashable { case match(MatchCell.CellModel) }
    
    // MARK: - Properties
    
    weak var delegate: MatchesViewControllerDelegate?
    private lazy var dataSource: DataSource = makeDataSource()

    // MARK: - Initializers

    init(viewModel: ViewModel) {
        super.init(viewModel)
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = RootView(frame: .zero)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardDismissGesture()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getMatches()
    }

    // MARK: - Setups

    override func setupViewModelInputs() {
        super.setupViewModelInputs()
        
        rootView.searchInputView.textField.textPublisher
            .debounce(for: .milliseconds(300), scheduler: mainQueue)
            .assign(to: \.searchKeyword, on: viewModel, ownership: .weak)
            .store(in: &cancellables)
    }

    override func setupViewModelOutputs() {
        super.setupViewModelOutputs()
        
        viewModel.$searchedMatches
            .compactMap { [weak self] in self?.generateSnapshot($0) }
            .receive(on: mainQueue)
            .sink { [weak self] in self?.dataSource.apply($0) }
            .store(in: &cancellables)
    }
    
    override func setupActions() {
        super.setupActions()
    }

    // MARK: -

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionView diffable data source handling

extension MatchesViewController {
    
    private func setupCollectionView() {
        rootView.collectionView.dataSource = dataSource
        rootView.collectionView.setCollectionViewLayout(createLayout(), animated: false)
        rootView.collectionView.register(cellWithClass: MatchCell.self)
        rootView.collectionView.register(
            supplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withClass: SimpleCollectionViewHeader.self)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemHeight: CGFloat = 112

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))

        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerElement]
        section.interGroupSpacing = 20
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: rootView.collectionView) { [unowned self] collectionView, indexPath, cellKind in
            switch cellKind {
            case .match(let cellModel):
                let cell = collectionView.dequeueReusableCell(withClass: MatchCell.self, for: indexPath)
                cell.configureCell(cellModel)
                cell.viewHighlightsButton.tapPublisher
                    .sink { [unowned self] _ in viewHighlights(cellModel.highlights) }
                    .store(in: &cell.cancellables)
                
                Publishers.Merge(
                    cell.homeTeamButton.tapPublisher.mapToValue(cellModel.home),
                    cell.awayTeamButton.tapPublisher.mapToValue(cellModel.away)
                )
                    .compactMap { $0 }
                    .sink { [unowned self] in delegate?.matchesViewControllerDidViewTeamDetail(teamName: $0) }
                    .store(in: &cell.cancellables)
                    
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withClass: SimpleCollectionViewHeader.self, for: indexPath)
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            header.configureCell(section.title)
            return header
        }

        return dataSource
    }
    
    private func generateSnapshot(_ matches: [Match]) -> Snapshot {
        var snapshot = Snapshot()
        let cellModels = matches.map(MatchCell.CellModel.init)
        let previousCellModels = cellModels.filter { $0.type == .previous }
        if !previousCellModels.isEmpty {
            snapshot.appendSections([.previous])
            snapshot.appendItems(previousCellModels.map { .match($0) })
        }
        let upcomingCellModels = cellModels.filter { $0.type == .upcoming }
        if !upcomingCellModels.isEmpty {
            snapshot.appendSections([.upcoming])
            snapshot.appendItems(upcomingCellModels.map { .match($0) })
        }
        
        return snapshot
    }
    
    private func viewHighlights(_ url: String?) {
        guard let url = url,
              let videoURL = URL(string: url)
        else {
            return
        }
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
}

extension MatchesViewController.SectionKind {
    var title: String {
        switch self {
        case .previous:
            return "Previous"
        case .upcoming:
            return "Upcoming"
        }
    }
}
