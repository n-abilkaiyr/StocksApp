//
//  DetailStockViewController.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 27.05.2022.
//

import UIKit

class DetailStockViewController: UIViewController {
    private var favoriteAction: (() -> Void)?
    private let presenter: StockDetailPreneterProtocol
    private let stockId:  String
    
    init(presenter: StockDetailPreneterProtocol, id: String) {
        self.presenter = presenter
        stockId = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)

        button.setImage(UIImage(systemName: "star", withConfiguration: config), for: .normal)
        button.setImage(UIImage(systemName: "star.fill", withConfiguration: config), for: .selected)
        button.addTarget(self, action: #selector(rightButttonTapped), for: .touchUpInside)
                            
        return button
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(customView: rightButton)
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
        return label
    }()
    
    private lazy var graphicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupSubviews()
        setupConstraints()
        presenter.loadView(with: stockId)
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
        navigationBarBorder(for: false)
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
    
    //Temporary method
    func configure(with model: StockModelProtocol) {
        titleLabel.text = model.name
        subTitleLabel.text = model.symbol
        priceChangeLabel.text = model.change
        priceLabel.text = "$" + model.price
        priceChangeLabel.textColor = model.changeColor
        rightButton.isSelected = model.isFavorite
        favoriteAction = {
            model.setFavorite()
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationItem.titleView = vStackView
        navigationItem.setLeftBarButton(backBarButtonItem, animated: false)
        navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        navigationBarBorder(for: true)
        
    }
    private func navigationBarBorder(for state: Bool) {
        let name = "bottomBorder"
        if state {
            let bottomLine = CALayer()
            bottomLine.name = name
            bottomLine.frame = CGRect(x: 0.0,
                                      y: (navigationController?.navigationBar.frame.height) ?? 0 - 2,
                                      width: navigationController?.navigationBar.frame.width ?? 0,
                                      height: 2.0)
            bottomLine.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
            navigationController?.navigationBar.layer.addSublayer(bottomLine)
        } else {
            if let index = navigationController?.navigationBar.layer.sublayers?.firstIndex(where: {$0.name == name}) {
                navigationController?.navigationBar.layer.sublayers?.remove(at: index)
            }
        }
    }
    private func setupSubviews() {
        
        view.addSubview(priceStackView)
        view.addSubview(graphicImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //priceStackView
            priceStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priceStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 63),
            
            //graphicImageView
            graphicImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graphicImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graphicImageView.topAnchor.constraint(equalTo: priceStackView.bottomAnchor, constant: 30),
            graphicImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
           
        ])
    }
    
   
    
    // MARK: - Selectors
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightButttonTapped() {
        rightButton.isSelected.toggle()
        favoriteAction?()
    }
}

// MARK: - StockDetailViewControllerProtocol
extension DetailStockViewController: StockDetailViewControllerProtocol {
    func updateView() {
        let detailStockModel = presenter.model()
        print(detailStockModel?.prices)
        graphicImageView.image = UIImage(named: "graph")
    }
    
    func updateView(withLoader isLoading: Bool) {
        print("isLoading: \(isLoading)")
    }
    
    func updateView(withError message: String) {
        //
    }
    
    
}
