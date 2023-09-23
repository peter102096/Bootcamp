import UIKit
import AFNetworking

class APIModel: NSObject {
    public static let shared = APIModel()
    public typealias APICallback = (Int?, Codable?) -> Void
    let manager = AFHTTPSessionManager(sessionConfiguration: .default)
    var statusCode: Int? = 404
    private var tasks: [URLSessionDataTask?] = []
    private override init() {
        super.init()
    }

    public func getMovie(url: String?, completion: @escaping APICallback) {
        if let url = url {
            getFromServer(url: url, dataStruct: MovieModel.self) { (statusCode, data) in
                completion(statusCode, data)
            }
        } else {
            completion(404, ErrorModel(statusCode: 404, reason: "ExpectionError".localized()))
        }
    }

    public func getMusic(url: String?, completion: @escaping (Int?, Codable?) -> Void) {

        if let url = url {
            getFromServer(url: url, dataStruct: MusicModel.self) { (statusCode, data) in
                completion(statusCode, data)
            }
        } else {
            completion(404, ErrorModel(statusCode: 404, reason: "ExpectionError".localized()))
        }
    }

    public func cancelAllRequest() {
        for task in tasks {
            task?.cancel()
        }
        tasks.removeAll()
    }

    private func getFromServer<T: Codable>(url: String, dataStruct struct: T.Type, param: Any? = nil, headers: Dictionary<String, String>? = nil, completion: @escaping APICallback) {
        statusCode = 404
        tasks.append(manager.get(url, parameters: nil, headers: nil, progress: nil) { [weak self] (task, responseObject) in
            if let response = task.response as? HTTPURLResponse, let jsonDict = responseObject as? [String: Any] {
                self?.statusCode = response.statusCode
                var errorModel: ErrorModel? = nil
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
                    let model = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(self?.statusCode, model)
                    return
                } catch {
                    debugPrint("API", "error decode \(T.self): \(error.localizedDescription)")
                    errorModel = ErrorModel(statusCode: response.statusCode, reason: error.localizedDescription)
                }
                completion(self?.statusCode, errorModel)
            }
        } failure: { [weak self] (task, error) in
            debugPrint("API", "getFromServer \(T.self) failure: \(error.localizedDescription)")
            if let response = task?.response as? HTTPURLResponse {
                self?.statusCode = response.statusCode
            }
            completion(self?.statusCode, ErrorModel(statusCode: self?.statusCode ?? 404, reason: error.localizedDescription))
        })
    }
}
