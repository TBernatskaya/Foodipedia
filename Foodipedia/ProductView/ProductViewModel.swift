import Foundation

protocol ProductViewModel {
    var nutrientsCount: Int { get }
    func fetchRandomProduct(completion: @escaping(Product?, String?) -> ())
    func nutrientInfo(by index: Int) -> (String, String)
}

class ProductViewModelImpl: ProductViewModel {

    let productService: ProductService
    var product: Product?

    var nutrientsCount: Int { NutrientName.allCases.count }
    var randomProductID: Int { Int.random(in: 1...200) }

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
        guard
            let product = product,
            0 <= index,
            index < nutrientsCount
        else { return ("", "") }

        let name = NutrientName.allCases[index]
        let amount = product.nutrientAmount(for: name)
        return (name.rawValue, String(amount))
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
