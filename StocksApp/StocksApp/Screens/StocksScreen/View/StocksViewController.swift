//
//  ViewController.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 24.05.2022.
//

import UIKit

final class StocksViewController: UIViewController {
    private var stocks: [Stock] = []
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.register(StockCell.self, forCellReuseIdentifier: StockCell.typeName)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
       return tableView
    }()
    
 // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        fetchStocks()
    }
    
// MARK: - Methods
    private func setupSubview() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchStocks() {
        let client: NetworkService = Network()
        let stockService = StockService(client: client)
        stockService.fetchStocks {[weak self] result in
            switch result {
            case .success(let stocks):
                self?.stocks = stocks
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showError(error.localizedDescription)
            }
        }
    }
    
    private func showError(_ message: String) {
        // show error
    }
}


// MARK: - UITableViewDataSource
extension StocksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stocks.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.typeName, for: indexPath) as? StockCell else { return UITableViewCell() }
        cell.setBackgroundColor(for: indexPath.row)
        cell.configure(with: stocks[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension StocksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? StockCell else{ return }
        cell.viewTapped()
        let detailStockVC = DetailStockViewController()
        detailStockVC.configure(with: stocks[indexPath.row])
        navigationController?.pushViewController(detailStockVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        76
    }
}



// MARK: - Temporary
struct Stock: Decodable {
    private let id: String
    private let name: String
    private let symbol: String
    private let image: String
    private let currentPrice: Double
    private let priceChange: Double
    private let percentageChange: Double
    

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, image
        case currentPrice = "current_price"
        case priceChange = "price_change_24h"
        case percentageChange = "price_change_percentage_24h"
    }
}


extension Stock {
    var nameDescription: String {
        self.name
    }
    var symbolDescription: String {
        self.symbol
    }
    var currentPriceDescription: String {
        "\(Double( round(currentPrice * 100) / 100))"
    }
    
    var priceChangesDescription: String {
        var priceChange = priceChange
        var resultText = ""
        
        if priceChange > 0 {
            resultText.append("+")
        } else if priceChange < 0 {
            resultText.append("-")
            priceChange *= -1
        }
        
        resultText.append("$")
        resultText.append("\(Double( round(priceChange * 100) / 100)) ")
        resultText.append(" (\(Double(round(percentageChange * 100) / 100))%)")
        
        return resultText
    }
}
