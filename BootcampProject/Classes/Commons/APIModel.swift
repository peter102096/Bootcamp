import UIKit
//import AFNetworking

class APIModel: NSObject {
    public static let shared = APIModel()
    public typealias APICallback = (Int?, Codable?) -> Void
    let manager = AFHTTPSessionManager(sessionConfiguration: .default)
    var statusCode: Int? = 404
    private let baseUrl = "https://itunes.apple.com/search"
    private let countryTW = "country=TW"
    private let group = DispatchGroup()
    private override init() {
        super.init()
    }

    public func getMusic(_ keyword: String, completion: @escaping (Int?, Codable?) -> Void) {
        let url = "\(baseUrl)?term=\(keyword)&media=music&\(countryTW)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        getFromServer(url: url!, dataStruct: MusicModel.self) { (statusCode, data) in
            completion(statusCode, data)
        }
    }

    public func getMovie(_ keyword: String, completion: @escaping APICallback) {
        let url = "\(baseUrl)?term=\(keyword)&media=movie&\(countryTW)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        getFromServer(url: url!, dataStruct: MovieModel.self) { (statusCode, data) in
            completion(statusCode, data)
        }
    }

    private func getFromServer<T: Codable>(url: String, dataStruct struct: T.Type, param: Any? = nil, headers: Dictionary<String, String>? = nil, completion: @escaping APICallback) {
        statusCode = 404
        manager.get(url, parameters: nil, headers: nil, progress: nil) { [weak self] (task, responseObject) in
            if let response = task.response as? HTTPURLResponse, let jsonDict = responseObject as? [String: Any] {
                self?.statusCode = response.statusCode
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
                    let model = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(self?.statusCode, model)
                    return
                } catch {
                    debugPrint("API", "error decode \(T.self): \(error.localizedDescription)")
                }
                completion(self?.statusCode, nil)
            }
        } failure: { [weak self] (task, error) in
            debugPrint(error.localizedDescription)
            if let response = task?.response as? HTTPURLResponse {
                self?.statusCode = response.statusCode
            }
            completion(self?.statusCode, nil)
        }
    }
}
