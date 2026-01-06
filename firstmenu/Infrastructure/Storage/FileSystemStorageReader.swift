//
//  FileSystemStorageReader.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// Reads storage statistics using FileManager.
public actor FileSystemStorageReader: StorageProviding {

    private let fileManager: FileManager
    private let path: String

    public init(fileManager: FileManager = .default, path: String = "/") {
        self.fileManager = fileManager
        self.path = path
    }

    public func storageUsage() async throws -> (used: Int64, total: Int64) {
        let attributes = try fileManager.attributesOfFileSystem(forPath: path)

        guard let totalSize = attributes[.systemSize] as? UInt64,
              let freeSize = attributes[.systemFreeSize] as? UInt64 else {
            throw StorageError.readFailed
        }

        let used = Int64(totalSize) - Int64(freeSize)

        return (used: used, total: Int64(totalSize))
    }
}

public enum StorageError: Error {
    case readFailed
}
