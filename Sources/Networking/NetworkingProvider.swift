//
//  NetworkingProvider.swift
//  Hera
//
//  Created by Ali Ammar Hilal on 20.01.2021.
//

import Foundation
import Moya

enum Service: TargetType {
	case getConfig(userProbs: HeraUserProperties, appKey: String)

    var path: String {
		switch self {
		case .getConfig: return "6958eee6"//return "configs/fetch"
		}
	}

    var baseURL: URL {
		return URL(string: "https://mm.kairosapi.com/api/")!
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case let .getConfig(userProbs, _):
            return .requestParameters(parameters: userProbs.toJSON(), encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getConfig(_, let appKey):
            return [
                "AppKey": appKey,
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        }
    }
    
    var validationType: ValidationType {
        .successCodes
    }
}

protocol Networking {
	func getConfigs(userprops: HeraUserProperties, appKey: String, completion: @escaping ((Result<Config, Error>) -> Void))
}

struct NetworkManager: Networking {
	let provider = MoyaProvider<Service>(plugins: [])
    
    func getConfigs(userprops: HeraUserProperties, appKey: String, completion: @escaping ((Result<Config, Error>) -> Void)) {
        provider.request(.getConfig(userProbs: userprops, appKey: appKey)) { res in
            switch res {
            case .success(let response):
                do {
                    print(try response.mapJSON())
                    let config = try JSONDecoder().decode(Config.self, from: response.data)
                    Logger.log(.success, "Mediation Config:", config)
                    completion(.success(config))
                } catch {
                    Logger.log(.error, error.localizedDescription)
                    completion(.failure(error))
                }
            case .failure(let error):
                Logger.log(.error, error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
