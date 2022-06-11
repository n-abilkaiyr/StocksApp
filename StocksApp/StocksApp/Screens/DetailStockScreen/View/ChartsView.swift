//
//  ChartsView.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 06.06.2022.
//

import UIKit
import Charts

final class ChartsContainerView: UIView {
    private var model: ChartsModel?
    
    private lazy var chartsView: LineChartView = {
        let view = LineChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.xAxis.drawGridLinesEnabled = false
        view.xAxis.enabled = false
        view.xAxis.drawLabelsEnabled = false
        view.leftAxis.enabled = false
        view.leftAxis.drawGridLinesEnabled = false
        view.rightAxis.enabled = false
        view.rightAxis.drawGridLinesEnabled = false
        view.doubleTapToZoomEnabled = false
        view.legend.setCustom(entries: [])
        view.backgroundColor = .systemBackground
        return view
    }()

    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        setupMarker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with isLoading: Bool) {
        isLoading ? loader.startAnimating() : loader.stopAnimating()
        loader.isHidden = !isLoading
        buttonsStackView.isHidden = isLoading
        chartsView.isHidden = isLoading
    }
    
    func configure(with model: ChartsModel) {
        self.model = model
        addButtons(for: model.periods.map {$0.name})
        setCharts(with: model.periods.first?.prices)
        periodButtonTapped(sender: buttonsStackView.subviews.first as? UIButton ?? UIButton()) // очень плохой подход, мне кажется
    }
    
    private func setupSubviews() {
        addSubview(chartsView)
        addSubview(buttonsStackView)
        addSubview(loader)
    }
    
    private func setupMarker() {
        let marker = ChartMarker()
        chartsView.marker = marker
        marker.chartView = chartsView
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chartsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartsView.topAnchor.constraint(equalTo: topAnchor),
            chartsView.heightAnchor.constraint(equalTo: chartsView.widthAnchor, multiplier: 26/36),
            
            
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonsStackView.topAnchor.constraint(equalTo: chartsView.bottomAnchor, constant: 40),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 44),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loader.centerYAnchor.constraint(equalTo: chartsView.centerYAnchor),
            loader.centerXAnchor.constraint(equalTo: chartsView.centerXAnchor)
        ])
    }
    
    private func addButtons(for titles: [String]) {
        titles.enumerated().forEach { (index, title) in
            let button = UIButton()
            button.tag = index
            button.backgroundColor = UIColor.periodButtonBackgroundColor
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.semiBold(size: 12)
            button.layer.cornerRadius = 12
            button.addTarget(self, action: #selector(periodButtonTapped), for: .touchUpInside)
            button.layer.cornerCurve = .continuous
            buttonsStackView.addArrangedSubview(button)
        }
    }
    
    private func setCharts(with prices: [Double]?) {
        guard let prices = prices else {
            return
        }
        
        var yValues = [ChartDataEntry]()
        for (index, value) in prices.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(index + 1), y: value)
            yValues.append(dataEntry)
        }
    
        let lineDataSet = lineCharDataSet(with: yValues)
        let data = LineChartData(dataSets: [lineDataSet])
        data.setDrawValues(false)
        
        chartsView.data = data
        chartsView.animate(xAxisDuration: 1)
    }
    
    private func lineCharDataSet(with entries: [ChartDataEntry]) -> LineChartDataSet {
        let lineDataSet = LineChartDataSet(entries: entries, label: nil)
        let gradientColors = [UIColor.chartBottomColor.cgColor,
                              UIColor.chartTopColor.cgColor] as CFArray
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB() ,
                                       colors: gradientColors,
                                       locations: colorLocations)
        
        lineDataSet.drawCirclesEnabled = false
        lineDataSet.valueFont = .boldSystemFont(ofSize: 10)
        lineDataSet.valueTextColor = .white
        lineDataSet.drawFilledEnabled = true
        lineDataSet.circleRadius = 3.0
        lineDataSet.circleHoleRadius = 2.0
        lineDataSet.mode = .cubicBezier
        lineDataSet.lineWidth = 2
        lineDataSet.setColor(.black)
        lineDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineDataSet.drawVerticalHighlightIndicatorEnabled = false
        lineDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        lineDataSet.drawFilledEnabled = true
        return lineDataSet
    }
    
    @objc private func periodButtonTapped(sender: UIButton) {
        buttonsStackView.subviews.compactMap { $0 as? UIButton }.forEach { 
            $0.backgroundColor = sender.tag == $0.tag ? .black : UIColor.periodButtonBackgroundColor
            $0.setTitleColor(sender.tag == $0.tag ? .white : .black, for: .normal)
        }
        
        guard let model = model else { return }
        let period = model.periods[sender.tag]
        setCharts(with: period.prices)
    }
}


final class ChartMarker: MarkerView {
    private var text = String()
    private var radius: CGFloat = 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let drawAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.semiBold(size: 16),
        .foregroundColor: UIColor.black,
        .backgroundColor: UIColor.systemBackground
    ]

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        text = "$\(entry.y)"
    }

    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)
        
        let circleRect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
        context.setFillColor(UIColor.black.cgColor)
        context.fillEllipse(in: circleRect)
        
        let sizeForDrawing = text.size(withAttributes: drawAttributes)
        bounds.size = sizeForDrawing
        offset = CGPoint(x: -sizeForDrawing.width / 2, y: -sizeForDrawing.height - 4)

        let offset = offsetForDrawing(atPoint: point)
        let originPoint = CGPoint(x: point.x + offset.x, y: point.y + offset.y)
        let rectForText = CGRect(origin: originPoint, size: sizeForDrawing)
        drawText(text: text, rect: rectForText, withAttributes: drawAttributes)
    }

    private func drawText(text: String, rect: CGRect, withAttributes attributes: [NSAttributedString.Key: Any]? = nil) {
        let size = bounds.size
        let centeredRect = CGRect(
            x: rect.origin.x + (rect.size.width - size.width) / 2,
            y: rect.origin.y + (rect.size.height - size.height) / 2 - 10,
            width: size.width,
            height: size.height
        )
        text.draw(in: centeredRect, withAttributes: attributes)
    }
}
