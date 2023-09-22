import UIKit
import RealmSwift
import ShareModels

class DBModel: NSObject {
    private let TAG = String(describing: DBModel.self)
    
    static let shared = DBModel()
    
    private var realm: Realm!

    private let curSchemaVer: UInt64 = 1002
    
    private let queue = DispatchQueue(label: "BootCampRealmDB")
    
    private override init() {
        super.init()
    }

    func didApplicationLunch() {
        let config = Realm.Configuration(schemaVersion: curSchemaVer)
        Realm.Configuration.defaultConfiguration = config
//        debugPrint(self.classForCoder, "url: \(Realm.Configuration.defaultConfiguration.fileURL!.absoluteString)")
    }

    //MARK: - Bookmark
    func setBookmark(_ model: BookmarkModel) {
        dump(model)
        queue.sync { [unowned self] in
            realm = try! Realm()
            try! realm.write {
                realm.add(model)
            }
        }
    }

    func removeBookmark(_ trackId: String) {
        queue.sync { [unowned self] in
            realm = try! Realm()
            let result = realm.objects(BookmarkModel.self).filter("trackId = '\(trackId)'")
            if let result = result.first {
                try! realm.write({
                    realm.delete(result)
                })
            }
        }
    }

    func getBookmarks(completion: @escaping ([BookmarkModel]) -> Void) {
        queue.sync { [unowned self] in
            realm = try! Realm()
            let result = realm.objects(BookmarkModel.self)
            var bookmarks: [BookmarkModel] = []
            for i in 0..<result.count {
                bookmarks.append(result[i])
            }
            completion(bookmarks)
        }
    }

    //MARK: -
    func resetDB() {
        queue.sync { [unowned self] in
            realm = try! Realm()
            try! realm.write({
                realm.deleteAll()
            })
        }
    }
}
