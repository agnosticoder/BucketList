//
//  File-Reader.swift
//  BucketList
//
//  Created by Satinder Singh on 28/12/24.
//

import Foundation

extension FileManager {
    func readFile(fileName: String) {
        let url = URL.documentsDirectory.appending(path: fileName)

        do {
            let input = try String(contentsOf: url, encoding: .utf8)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
    }
}
