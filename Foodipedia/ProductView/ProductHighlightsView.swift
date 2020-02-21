import UIKit

class ProductHighlightsView: UIView {

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.productName, self.calories, self.caloriesSubtitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.contentMode = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.backgroundColor = .blue
        return stackView
    }()

    lazy var productName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .light)
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    lazy var calories: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 62, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    lazy var caloriesSubtitle: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 28)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.orange.withAlphaComponent(0.75)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.layer.cornerRadius = 50
        self.addSubview(stackView)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
