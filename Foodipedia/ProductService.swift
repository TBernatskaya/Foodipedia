import Foundation

protocol ProductService {
    func fetchProduct(by productID: Int, completion: @escaping (Result<Product, Error>) -> ())
}

class ProductServiceImpl: ProductService {
    func fetchProduct(by productID: Int, completion: @escaping (Result<Product, Error>) -> ()) {}
}
