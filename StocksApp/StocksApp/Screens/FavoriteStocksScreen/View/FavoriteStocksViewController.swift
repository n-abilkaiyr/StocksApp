//
//  FavoriteStocksViewController.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 01.06.2022.
//

import UIKit

final class FavoriteStocksViewController: UIViewController {
    private let presenter: FavoriteStocksPresenterProtocol
    
    init(presenter: FavoriteStocksPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.register(StockCell.self, forCellReuseIdentifier: StockCell.typeName)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
       return tableView
    }()
    
 // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVeiw()
        setupSubview()
        presenter.loadView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
// MARK: - Methods
    private func setupVeiw() {
        view.backgroundColor = .systemBackground
    }
    private func setupSubview() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    
    private func showError(_ message: String) {
        // show error
    }
}


// MARK: - UITableViewDataSource
extension FavoriteStocksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.itemsCount
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.typeName, for: indexPath) as? StockCell else { return UITableViewCell() }
        cell.setBackgroundColor(for: indexPath.row)
        cell.configure(with: presenter.model(for: indexPath))
        cell.favoriteButtonCompletion = { [weak self] tableViewCell in
            if let indexPath = self?.tableView.indexPath(for: tableViewCell) {
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteStocksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? StockCell else{ return }
        cell.viewTapped()
        
        let currentModel = presenter.model(for: indexPath)
        let detailStockVC = ModuleBuilder.shared.detailStockModule(with: currentModel.id)
        detailStockVC.configure(with: presenter.model(for: indexPath))
        navigationController?.pushViewController(detailStockVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        76
    }
}

extension FavoriteStocksViewController: FavoriteStocksViewControllerProtocol {
    func updateView() {
        tableView.reloadData()
    }
    
    func updateView(withLoader isLoading: Bool) {
        // show or hide loader
    }
    
    func updateView(withError message: String) {
        // show error message
    }
    
}
