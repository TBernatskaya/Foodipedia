import UIKit

class ProductViewController: UIViewController {

    var viewModel: ProductViewModel

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

        viewModel.fetchRandomProduct(completion: { product, error in
            print(product)
            print(error)
        })
    }
}
