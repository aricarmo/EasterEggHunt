import Testing
import Foundation

@testable import MoviesNetwork

final class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        
        let data = mockData ?? Data()
        let response = mockResponse ?? HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        return (data, response)
    }
}

struct MockAPIEndpoint: APIEndpoint {
    let baseURL: String
    let path: String
    var queryItems: [URLQueryItem]?
    
    var url: URL? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
    
    init(baseURL: String = "https://api.themoviedb.org/3", path: String, queryItems: [URLQueryItem]? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.queryItems = queryItems
    }
}

struct TestModel: Codable, Equatable {
    let id: Int
    let name: String
}

@Suite("NetworkService Tests")
struct NetworkServiceTests {
    
    // MARK: - Success Cases
    
    @Test("Verifica se deu sucesso para todos os codigos de status OK",
          arguments: [200, 201, 204, 299])
    func testSuccessfulStatusCodes(statusCode: Int) async throws {
        // Given
        let mockSession = MockURLSession()
        let networkService = NetworkService(session: mockSession)
        let endpoint = MockAPIEndpoint(path: "/test")
        
        let expectedModel = TestModel(id: 1, name: "Test")
        let jsonData = try JSONEncoder().encode(expectedModel)
        
        mockSession.mockData = jsonData
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.themoviedb.org/3/test")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
        
        let result: TestModel = try await networkService.request(endpoint)
        #expect(result == expectedModel)
    }
    
    @Test("Verifica se vai retornar que a URL é inválida")
    func testInvalidURLError() async throws {
        let mockSession = MockURLSession()
        let networkService = NetworkService(session: mockSession)
        
        struct InvalidEndpoint: APIEndpoint {
            var url: URL? { return nil }
            let baseURL: String = ""
            let path: String = ""
            let queryItems: [URLQueryItem]? = nil
        }
        
        let endpoint = InvalidEndpoint()
        
        await #expect(throws: NetworkError.self) {
            let _: TestModel = try await networkService.request(endpoint)
        }
    }
    
    @Test("Verifica se throw um erro de invalidResponse quando a response não é um HTTPURLResponse")
    func testInvalidResponseError() async throws {
        let mockSession = MockURLSession()
        let networkService = NetworkService(session: mockSession)
        let endpoint = MockAPIEndpoint(path: "/test")
        
        mockSession.mockData = Data()
        mockSession.mockResponse = URLResponse(
            url: URL(string: "https://api.themoviedb.org/3/test")!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        
        await #expect(throws: NetworkError.self) {
            let _: TestModel = try await networkService.request(endpoint)
        }
    }
    
    @Test("Verifica os erros para cada status code de erro do servidor",
              arguments: [400, 401, 404, 500, 503])
    func testServerErrorStatusCodes(statusCode: Int) async throws {
        let mockSession = MockURLSession()
        let networkService = NetworkService(session: mockSession)
        let endpoint = MockAPIEndpoint(path: "/test")
        
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.themoviedb.org/3/test")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )

        do {
            let _: TestModel = try await networkService.request(endpoint)
            #expect(Bool(false), "Should have thrown an error")
        } catch let error as NetworkError {
            if case .serverError(let code) = error {
                #expect(code == statusCode)
            } else {
                #expect(Bool(false), "Expected serverError but got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected NetworkError but got \(error)")
        }
    }
}

@Suite("NetworkServiceProtocol Conformance Tests")
struct NetworkServiceProtocolTests {
    
    @Test("Deve conformar com NetworkServiceProtocol")
    func testProtocolConformance() {
        let networkService: NetworkServiceProtocol = NetworkService()
        
        #expect(networkService is NetworkService)
    }
}
