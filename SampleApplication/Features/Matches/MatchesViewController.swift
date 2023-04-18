//
//  MatchesViewController.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import AVKit
import AVFoundation
import Combine
import UIKit

protocol MatchesViewControllerDelegate: AnyObject {
    func matchesViewControllerDidViewTeamDetail(teamName: String)
}

final class MatchesViewController: BaseViewController, ViewControllable {

    // MARK: - Definitions

    typealias RootView = MatchesRootView
    typealias ViewModel = MatchesViewModel
    
    // MARK: - Properties
    
    weak var delegate: MatchesViewControllerDelegate?
    private lazy var dataSource: MatchDataSource = makeDataSource()

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
        
        rootView.segmentControl.selectedSegmentIndexPublisher
            .compactMap(MatchType.init)
            .assign(to: \.selectedTab, on: viewModel, ownership: .weak)
            .store(in: &cancellables)
    }

    override func setupViewModelOutputs() {
        super.setupViewModelOutputs()
        
        viewModel.$snapshot
            .receive(on: mainQueue)
            .compactMap { $0 }
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
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemHeight: CGFloat = 112

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    private func makeDataSource() -> MatchDataSource {
        let dataSource = MatchDataSource(collectionView: rootView.collectionView) { [unowned self] collectionView, indexPath, cellKind in
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
        
        return dataSource
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

