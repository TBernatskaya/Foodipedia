import UIKit

class NutrientCell: UICollectionViewCell {
    lazy var nutrientName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var nutrientAmount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 5
        self.contentView.addSubview(nutrientName)
        self.contentView.addSubview(nutrientAmount)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nutrientName.text = nil
        nutrientAmount.text = nil
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nutrientName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nutrientName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            nutrientName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nutrientAmount.topAnchor.constraint(equalTo: nutrientName.bottomAnchor, constant: 5),
            nutrientAmount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            nutrientAmount.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5)
        ])
    }
}
