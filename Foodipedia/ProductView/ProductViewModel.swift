import Foundation

protocol ProductViewModel {
    func fetchRandomProduct(completion: @escaping(Product?, String?) -> ())
    func nutrientInfo(by index: Int) -> (String, String)
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

    func nutrientInfo(by index: Int) -> (String, String) {
        if let product = product {
            let name = NutrientName.allCases[index]
            let amount = product.nutrientAmount(for: name)
            return (name.rawValue, String(amount))
        }
        return ("", "")
    }
}

enum NutrientName: String, CaseIterable {
    case fat = "Fat"
    case fiber = "Fiber"
    case protein = "Protein"
    case sugar = "Sugar"
}

extension Product {
    func nutrientAmount(for name: NutrientName) -> Float {
        switch name {
        case .fat: return self.fat
        case .fiber: return self.fiber
        case .protein: return self.protein
        case .sugar: return self.sugar
        }
    }
}
