//
//  StreamManager.swift
//  twitterstream
//
//  Created by Fernando Ferreira on 10/04/18.
//  Copyright © 2018 Fernando Ferreira. All rights reserved.
//

import Foundation

enum StreamError: Error {
    case noInternetConnection
}

final class StreamManager: NSObject {

    typealias StreamClosure = (StreamResult) -> Void

    enum StreamResult {
        case task(Data)
        case finished(Error?)
        case timeout
        case canceled
    }

    unowned(unsafe) let dispatchQueue: DispatchQueue

    private lazy var session: URLSession = {
        let operationQueue = OperationQueue()
        operationQueue.underlyingQueue = self.dispatchQueue
        return URLSession(configuration: .default,
                          delegate: self,
                          delegateQueue: operationQueue)
    }()

    private var currentTask: URLSessionDataTask?
    private var streamClosure: StreamClosure?

    init(dispatchQueue: DispatchQueue) {
        self.dispatchQueue = dispatchQueue
        super.init()
    }

    func connect(withRequest request: URLRequest, responseClosure: StreamClosure?) {
        self.streamClosure = responseClosure
        currentTask = session.dataTask(with: request)
        currentTask?.resume()
    }

    func disconnect() {
        currentTask?.cancel()
        currentTask = nil
    }
}

// MARK: - URLSessionDataDelegate

extension StreamManager: URLSessionDataDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        let sameHost = task.originalRequest?.url?.host == challenge.protectionSpace.host
        let isAuthMethod = challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust

        guard let serverTrust = challenge.protectionSpace.serverTrust,
            sameHost && isAuthMethod else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        completionHandler(.useCredential, URLCredential(trust: serverTrust))
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard dataTask.state == .running else { return }
        streamClosure?(.task(data))
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else {
            streamClosure?(.finished(nil))
            return
        }
        switch error.code {
        case -1001: // Timeout
            streamClosure?(.timeout)
        case -999: // Canceled
            streamClosure?(.canceled)
        case -1009, -1005: // Lost network connection
            streamClosure?(.finished(StreamError.noInternetConnection))
        default:
            streamClosure?(.finished(error))
        }
    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        session.finishTasksAndInvalidate()
    }
}
