import XCTest
@testable import Foodipedia

class ProductViewModelTests: XCTestCase {

    func testFetchProduct_successfull() {
        let serviceMock = ProductServiceMock(shouldReturnError: false)
        let viewModel = ProductViewModelImpl(productService: serviceMock)
        let expectation = XCTestExpectation(description: "Product is fetched")

        viewModel.fetchRandomProduct(completion: { _, error in
            XCTAssertNotNil(viewModel.product)
            XCTAssertNil(error)
            XCTAssertEqual(viewModel.product?.title, "Cheese")
            XCTAssertEqual(viewModel.product?.calories, 200)
            XCTAssertEqual(viewModel.product?.fat, 15.54)
            XCTAssertEqual(viewModel.product?.fiber, 1)
            XCTAssertEqual(viewModel.product?.protein, 15.02)
            XCTAssertEqual(viewModel.product?.sugar, 0.35)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1)
    }

    func testFetchProduct_recievedError() {
        let serviceMock = ProductServiceMock(shouldReturnError: true)
        let viewModel = ProductViewModelImpl(productService: serviceMock)
        let expectation = XCTestExpectation(description: "Received an error")

        viewModel.fetchRandomProduct(completion: { _, error in
            XCTAssertNil(viewModel.product)
            XCTAssertNotNil(error)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1)
    }
}

private struct ProductServiceMock: ProductService {

    var shouldReturnError: Bool
    let error = NSError(domain: "Service", code: 456, userInfo: nil)
    let productResponse = ProductResponse(
        meta: Meta(code: 200),
        product: Product(
            title: "Cheese",
            calories: 200,
            fat: 15.54,
            fiber: 1,
            protein: 15.02,
            sugar: 0.35
        )
    )

    func fetchProduct(by productID: Int, completion: @escaping (Result<ProductResponse, Error>) -> ()) {
        if shouldReturnError {
            completion(.failure(error))
        } else {
            completion(.success(productResponse))
        }
    }
}
