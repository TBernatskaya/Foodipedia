import UIKit

class ProductViewController: UIViewController {

    var viewModel: ProductViewModel

    lazy var productHighlightsView: ProductHighlightsView = { ProductHighlightsView() }()

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
        view.addSubview(productHighlightsView)
        setupConstraints()

        viewModel.fetchRandomProduct(completion: { product, error in
            if let product = product {
                DispatchQueue.main.async {
                    self.productHighlightsView.updateView(with: product)
                }
            } else {
                self.presentAlert(with: error)
            }
        })
    }

    private func presentAlert(with title: String?) {
        let title = title ?? "Unknown error"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productHighlightsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            productHighlightsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            productHighlightsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            productHighlightsView.heightAnchor.constraint(equalToConstant: view.frame.height/3)
        ])
    }
}
