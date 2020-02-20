import Foundation

struct ProductResponse: Codable {
    let meta: Meta
    let product: Product

    enum CodingKeys: String, CodingKey {
        case meta
        case product = "response"
    }
}

struct Meta: Codable {
    let code: Int
}

struct Product: Codable {
    let title: String
    let calories: Float
    let fat: Float
    let fiber: Float
    let protein: Float
    let sugar: Float
}
