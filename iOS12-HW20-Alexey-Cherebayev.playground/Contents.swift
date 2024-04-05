import UIKit

struct Cards: Decodable {
    let cards: [Card]?
    
    enum CodingKeys: String, CodingKey {
        case cards = "cards"
    }
}

struct Card: Decodable {
    let name: String?
    let type: String?
    let manaCost: String?
    let setName: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name",
             type = "type",
             manaCost = "manaCost",
             setName = "setName"
    }
}

extension URLSession {
    func fetchData<T: Decodable>(for url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        self.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch let decoderError {
                    completion(.failure(decoderError))
                }
            }
        }.resume()
    }
}

let requestUrl = URL(string: "https://api.magicthegathering.io/v1/cards?name=Opt|BlackLotus")
DispatchQueue.main.async {
    guard let url = requestUrl else { return }
    URLSession.shared.fetchData(for: url) { (result: Result<Cards, Error>) in
        switch result {
        case .success(let cards):
            cards.cards?.forEach({
                if let name = $0.name, let type = $0.type, let manaCost = $0.manaCost, let setName = $0.setName {
                    print("Имя карты: \(name) \n Тип: \(type) \n Мановая стоимость: \(manaCost) \n Название сета: \(setName) \n")
                }
            })
        case .failure(let error):
            print("Error: \(error)")
        }
    }
}



