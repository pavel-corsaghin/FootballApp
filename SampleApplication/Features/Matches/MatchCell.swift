//
//  MatchCell.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/14.
//

import UIKit
import Domain

final class MatchCell: BaseCollectionViewCell {
    
    // MARK: - Subviews
    
    private var dateLabel: UILabel!
    private(set) var homeTeamButton: UIButton!
    private(set) var awayTeamButton: UIButton!
    private(set) var viewHighlightsButton: UIButton!
    private var winCheckImageView: UIImageView!
    
    // MARK: - Setup
    
    override func setupCell() {
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    override func setupSubviews() {
        dateLabel = UILabel().also {
            $0.textColor = .label
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
        }
        
        homeTeamButton = UIButton(type: .system).also{
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        }
        
        awayTeamButton = UIButton(type: .system).also{
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        }
        
        viewHighlightsButton = UIButton(type: .system).also{
            $0.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: [.normal])
        }
        
        winCheckImageView = UIImageView().also {
            $0.image = UIImage(named: "iconCheck")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .blue
        }
    }
    
    override func setupConstraints() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        addSubview(homeTeamButton)
        homeTeamButton.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }
        
        addSubview(awayTeamButton)
        awayTeamButton.snp.makeConstraints {
            $0.top.equalTo(homeTeamButton.snp.bottom)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }

        addSubview(viewHighlightsButton)
        viewHighlightsButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        addSubview(winCheckImageView)
    }
    
    func configureCell(_ cellModel: CellModel) {
        dateLabel.text = cellModel.date
        homeTeamButton.setTitle(cellModel.home, for: [.normal])
        awayTeamButton.setTitle(cellModel.away, for: [.normal])
        switch cellModel.type {
        case .previous:
            viewHighlightsButton.isHidden = false
        case .upcoming:
            viewHighlightsButton.isHidden = true
        }
        
        if let winner = cellModel.winner {
            winCheckImageView.isHidden = false
            winCheckImageView.snp.remakeConstraints {
                $0.size.equalTo(18)
                let isHomeWin = winner == cellModel.home
                if isHomeWin {
                    $0.centerY.equalTo(homeTeamButton)
                    $0.leading.equalTo(homeTeamButton.snp.trailing).offset(4)
                } else {
                    $0.centerY.equalTo(awayTeamButton)
                    $0.leading.equalTo(awayTeamButton.snp.trailing).offset(4)
                }
            }
        } else {
            winCheckImageView.isHidden = true
        }
    }
}

extension MatchCell {
    enum MatchType {
        case previous
        case upcoming
    }
    
    struct CellModel: Hashable {
        let date: String?
        let description: String?
        let home: String?
        let away: String?
        let winner: String?
        let highlights: String?
        let type: MatchType
        
        init(_ entity: Match) {
            date = entity.date?.toDate()?.formatted()
            description = entity.description
            home = entity.home
            away = entity.away
            winner = entity.winner
            highlights = entity.highlights
            type = entity.winner != nil ? .previous : .upcoming
        }
    }
}
