//
//  APICaller.swift
//  NewsApp
//
//  Created by Sree Sai Raghava Dandu on 13/05/21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    // Struct: Constants
    struct Constants {
        static let topHeadlinesURL = URL(
             string: "https://newsapi.org/v2/top-headlines?country=in&apiKey=\(Secret.secretKey)"
        )
        static let searchURLString =  "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=\(Secret.secretKey)&q="
    }
    private init() {}
    
    // Func: getTopStories
    public func getTopStories(completion: @escaping (Result<[Article],Error>) -> Void){
        //Get URL (guarded)
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                    
                }
                catch{
                    completion(.failure(error))
//                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    // Function: searchWithText
    public func search(with query: String, completion: @escaping (Result<[Article],Error>) -> Void){
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let urlString = Constants.searchURLString + query
        guard  let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data{
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                } catch {
//                    print("Error in Response")
                    print(error)
                }
            }
        }
        task.resume()
    }
}

// Models
struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
