import Foundation
import PerfectCURL

func testFunc() -> String {
    return "HueHue"
}

class SpellCheker {
    
    internal func sendRequest(text: String, completion: @escaping (String?) -> Void)
    {
        do {
            let body = self.textInBodyFormat(text: text)
            let url  = "https://montanaflynn-spellcheck.p.mashape.com/check?text=" + body
            let key  = "OA5qHL58kvmshkz5xa4FQowNtD3tp1cD0n2jsnPY9TFf28l8Ka"
            let json = try CURLRequest(url, .failOnError,
                                       .httpMethod(CURLRequest.HTTPMethod.get),
                                       .addHeader(.fromStandard(name: "X-Mashape-Key"), key),
                                       .addHeader(.fromStandard(name: "Accept"), "application/json")
                ).perform().bodyJSON
            
            let suggestion = self.suggestionFromJSON(json: json)
            completion(suggestion)
        } catch let error {
            fatalError("\(error)")
        }        
    }
    
    private func textInBodyFormat(text: String) -> String
    {
        let result = text.replacingOccurrences(of: " ", with: "+")
        return result
    }
    
    private func suggestionFromJSON(json: [String:Any]) -> String?
    {
        guard let result = json["suggestion"] as? String else {
            return nil
        }
        return result
    }
}
