//
// Created by Fernando Ferreira
// Copyright (c) 2018 Fernando Ferreira. All rights reserved.
//

import Foundation
import Unbox

typealias TaskClosure = (FilterAPIDataManager.TaskResult) -> Void

final class FilterAPIDataManager: FilterAPIDataManagerInputProtocol {

    // MARK: - Initialization

    enum TaskResult {
        case newData([Tweet])
        case failure(Error?)
        case needToReconnect
    }

    private let stream: StreamManager
    private let queue = DispatchQueue.global(qos: .userInitiated)

    init() {
        stream = StreamManager(dispatchQueue: queue)
    }

    func startStream(filterKeys: [String], andUserID userID: String, callBack: @escaping TaskClosure) {
        stream.disconnect()

        let request = TwitterRequest.filter(keys: filterKeys).toRequest(with: userID)
        stream.connect(withRequest: request) { result in
            switch result {
            case .task(let data):

                let stringData = String(data: data, encoding: .utf8) ?? ""
                let tweets = stringData
                    .components(separatedBy: "\r\n")
                    .compactMap { $0.data(using: .utf8) }
                    .compactMap { (try? JSONSerialization.jsonObject(with: $0, options: [])) as? [String: Any] }
                    .compactMap { try? Tweet(unboxer: Unboxer(dictionary: $0)) }

                guard !tweets.isEmpty else { return }
                callBack(.newData(tweets))
            case .finished(let error):
                callBack(.failure(error))
            case .timeout:
                callBack(.needToReconnect)
            case .canceled: break
            }
        }
    }
}
