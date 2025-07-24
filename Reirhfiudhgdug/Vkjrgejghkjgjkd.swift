import Foundation
import AppsFlyerLib

class Vkjrgejghkjgjkd: NSObject, AppsFlyerLibDelegate {
    static let shared = Vkjrgejghkjgjkd()
    private var conversionDataReceived = false
    private var conversionCompletion: ((String?) -> Void)?

    func startTracking(completion: @escaping (String?) -> Void) {
        self.conversionCompletion = completion

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            if !self.conversionDataReceived {
                self.conversionCompletion?(nil)
            }
        }
    }

    func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
        print("succ")
        if let campaign = data["campaign"] as? String {
            let components = campaign.split(separator: "_")
            var gergehgjhjd = ""
            for (index, value) in components.enumerated() {
                gergehgjhjd += "sub\(index + 1)=\(value)"
                if index < components.count - 1 {
                    gergehgjhjd += "&"
                }
            }
            conversionDataReceived = true
            conversionCompletion?("&" + gergehgjhjd)
        }
    }

    func onConversionDataFail(_ error: Error) {
        print("Conversion data failed: \(error.localizedDescription)")
        conversionCompletion?(nil)
    }
    
    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
        print("onAppOpenAttribution: \(attributionData)")
        if let gernghgjdf = attributionData["campaign"] as? String {
            let components = gernghgjdf.split(separator: "_")
            var parameters = ""
            for (index, value) in components.enumerated() {
                parameters += "sub\(index + 1)=\(value)"
                if index < components.count - 1 {
                    parameters += "&"
                }
            }
            conversionDataReceived = true
            conversionCompletion?("&" + parameters)
        }
    }
    
    func onAppOpenAttributionFailure(_ error: Error) {
        print("onAppOpenAttributionFailure: \(error.localizedDescription)")
        conversionCompletion?(nil)
    }
} 
