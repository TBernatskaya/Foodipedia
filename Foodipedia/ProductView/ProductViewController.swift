import UIKit

class ProductViewController: UIViewController {

    var viewModel: ProductViewModel

    lazy var productHighlights: ProductHighlightsView = { ProductHighlightsView() }()

    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.setTitle("Refresh", for: .normal)
        button.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        return button
    }()

    lazy var productNutrients: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(NutrientCell.self, forCellWithReuseIdentifier: NutrientCell.reuseIdentifier)
        return collectionView
    }()

    init(viewModel: ProductViewModel = ProductViewModelImpl()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(refreshButton)
        view.addSubview(productHighlights)
        view.addSubview(productNutrients)

        productNutrients.dataSource = self
        productNutrients.delegate = self

        setupConstraints()
        refresh()
    }
}

private extension ProductViewController {

    @objc func refresh() {
        viewModel.fetchRandomProduct(completion: { product, error in
            DispatchQueue.main.async {
                if let product = product {
                    self.updateViews(with: product)
                }
                else {
                    self.presentAlert(with: error)
                }
            }
        })
    }

    func updateViews(with product: Product) {
        productHighlights.productName.text = product.title
        productHighlights.calories.text = String(product.calories)
        productHighlights.caloriesSubtitle.text = "Calories per serving"
        productNutrients.reloadData()
    }

    func presentAlert(with title: String?) {
        let title = title ?? "Unknown error"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            refreshButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            refreshButton.heightAnchor.constraint(equalToConstant: 32),
            refreshButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            refreshButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            productHighlights.topAnchor.constraint(equalTo: refreshButton.bottomAnchor, constant: 32),
            productHighlights.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            productHighlights.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            productHighlights.heightAnchor.constraint(equalToConstant: view.frame.height/3),
            productNutrients.topAnchor.constraint(equalTo: productHighlights.bottomAnchor, constant: 32),
            productNutrients.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            productNutrients.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            productNutrients.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
        ])
    }
}

extension ProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.nutrientsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NutrientCell.reuseIdentifier,
            for: indexPath
        ) as? NutrientCell
        else { return UICollectionViewCell() }

        (cell.nutrientName.text, cell.nutrientAmount.text) = viewModel.nutrientInfo(by: indexPath.row)
        return cell
    }
}

extension ProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
