import Foundation

extension BookmarkModel {
    
    @discardableResult
    public func setTrackId(_ trackId: String) -> Self {
        self.trackId = trackId
        return self
    }

    @discardableResult
    public func setType(_ type: MediaType) -> Self {
        self.type = type.rawValue
        return self
    }

    @discardableResult
    public func setArtistName(_ artistName: String) -> Self {
        self.artistName = artistName
        return self
    }

    @discardableResult
    public func setCollectionName(_ collectionName: String) -> Self {
        self.collectionName = collectionName
        return self
    }

    @discardableResult
    public func setTrackName(_ trackName: String) -> Self {
        self.trackName = trackName
        return self
    }

    @discardableResult
    public func setTrackViewURL(_ trackViewURL: String) -> Self {
        self.trackViewURL = trackViewURL
        return self
    }

    @discardableResult
    public func setThumbnailURL(_ thumbnailURL: String) -> Self {
        self.thumbnailURL = thumbnailURL
        return self
    }

    @discardableResult
    public func setReleaseDate(_ releaseDate: String) -> Self {
        self.releaseDate = releaseDate
        return self
    }

    @discardableResult
    public func setTrackTimeMillis(_ trackTimeMillis: Int) -> Self {
        self.trackTimeMillis = trackTimeMillis
        return self
    }

    @discardableResult
    public func setLongDescription(_ longDescription: String) -> Self {
        self.longDescription = longDescription
        return self
    }

    @discardableResult
    public func setLikeState(_ isLiked: Bool) -> Self {
        self.isLiked = isLiked
        return self
    }
}
