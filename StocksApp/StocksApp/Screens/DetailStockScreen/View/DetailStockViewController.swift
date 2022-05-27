//
//  DetailStockViewController.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 27.05.2022.
//

import UIKit

class DetailStockViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semiBold(size: 12)
        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints  = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var backBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(backButtonTapped))
        return button
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(rightButttonTapped))
        return button
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    private lazy var priceChangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semiBold(size: 12)
        label.textColor = UIColor.StockCell.percentTextColor
        return label
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupViews()
        setupConstraints()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, priceChangeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints  = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Methods
    func configure(with stock: Stock) {
        titleLabel.text = stock.nameDescription
        subTitleLabel.text = stock.symbolDescription
        priceChangeLabel.text = stock.priceChangesDescription
        priceLabel.text = "$" + stock.currentPriceDescription
    }
    
    private func setupNavigationBar() {
        navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationItem.titleView = vStackView
        navigationItem.setLeftBarButton(backBarButtonItem, animated: false)
        navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
    }
    private func setupViews() {
        view.addSubview(priceStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            priceStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priceStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 63)
        ])
    }
    
    // MARK: - Selectors
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightButttonTapped() {
        // change rightBarButtonItem Color
    }
}
