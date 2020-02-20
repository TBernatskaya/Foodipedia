import Foundation

protocol ProductViewModel {
    func fetchRandomProduct(completion: @escaping(Product?, String?) -> ())
}

class ProductViewModelImpl: ProductViewModel {

    let productService: ProductService
    var product: Product?

    lazy var randomProductID = { Int.random(in: 1...200) }()

    init(productService: ProductService = ProductServiceImpl()) {
        self.productService = productService
    }

    func fetchRandomProduct(completion: @escaping (Product?, String?) -> ()) {
        productService.fetchProduct(by: randomProductID, completion: { result in
            switch result {
            case .failure(let error): completion(nil, error.localizedDescription)
            case .success(let response):
                self.product = response.product
                completion(response.product, nil)
            }
        })
    }
}
