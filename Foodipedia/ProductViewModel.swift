import Foundation

protocol ProductViewModel {}

class ProductViewModelImpl: ProductViewModel {
    let productService: ProductService

    init(productService: ProductService = ProductServiceImpl()) {
        self.productService = productService
    }
}
