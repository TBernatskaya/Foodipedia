import Foundation

protocol ProductService {
    func fetchProduct(by productID: Int, completion: @escaping (Result<ProductResponse, Error>) -> ())
}

class ProductServiceImpl: ProductService {
    let router = Router()

    func fetchProduct(by productID: Int, completion: @escaping (Result<ProductResponse, Error>) -> ()) {
        var request = router.fetchProductRequest(with: productID)
        request.addAuthorizationHeader()

        print(request.url?.absoluteString)

        fetchAndDecode(request: request, completion: completion)
    }

    private func fetchAndDecode<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> ()) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data
            else {
                return completion(.failure(error!))
            }
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(T.self, from: data)
                completion(.success(model))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

struct Router {
    private enum Routes: String {
        case product = "https://api.lifesum.com/v2/foodipedia/codetest?foodid={id}"
    }

    func fetchProductRequest(with productID: Int) -> URLRequest {
        let url = URL(
            string: Routes.product.rawValue
                .replacingOccurrences(of: "{id}", with: String(describing: productID))
        )!
        return URLRequest(url: url)
    }
}

extension URLRequest {
    mutating func addAuthorizationHeader() {
        self.setValue("23863708:465c0554fd00da006338c72e282e939fe6576a25fd00c776c0fbe898c47c9876",
                      forHTTPHeaderField: "Authorization")
    }
}
