import SwiftUI
import WebKit
import UserNotifications

struct Vuhergheurghudfg: UIViewRepresentable {
    let url: URL
    let onLoadComplete: ((URL) -> Void)?

    init(url: URL, onLoadComplete: ((URL) -> Void)? = nil) {
        self.url = url
        self.onLoadComplete = onLoadComplete
    }

    func makeUIView(context: Context) -> WKWebView {
        requestNotificationPermission()
        let gerhgudhg = WKWebViewConfiguration()
        
        gerhgudhg.preferences.javaScriptEnabled = true
        gerhgudhg.preferences.javaScriptCanOpenWindowsAutomatically = true
        gerhgudhg.websiteDataStore = WKWebsiteDataStore.default()
        gerhgudhg.allowsInlineMediaPlayback = true
        gerhgudhg.mediaTypesRequiringUserActionForPlayback = []
        
        if #available(iOS 14.0, *) {
            gerhgudhg.limitsNavigationsToAppBoundDomains = false
        }
        
        gerhgudhg.preferences.isFraudulentWebsiteWarningEnabled = false
        gerhgudhg.suppressesIncrementalRendering = false
        
        if #available(iOS 14.0, *) {
            gerhgudhg.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        
        gerhgudhg.allowsAirPlayForMediaPlayback = true
        

        
        let vneyfhuhf = WKWebView(frame: .zero, configuration: gerhgudhg)
        vneyfhuhf.overrideUserInterfaceStyle = .dark
        vneyfhuhf.allowsBackForwardNavigationGestures = true
        vneyfhuhf.navigationDelegate = context.coordinator
        vneyfhuhf.uiDelegate = context.coordinator
        vneyfhuhf.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
        
        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
        vneyfhuhf.load(request)
        
        return vneyfhuhf
    }
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Ошибка при запросе разрешения: \(error.localizedDescription)")
                return
            }

        }
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.overrideUserInterfaceStyle = .dark
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onLoadComplete: onLoadComplete)
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        let onLoadComplete: ((URL) -> Void)?
        private var hasCompletedInitialLoad = false

        init(onLoadComplete: ((URL) -> Void)? = nil) {
            self.onLoadComplete = onLoadComplete
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if !hasCompletedInitialLoad, let currentURL = webView.url {
                hasCompletedInitialLoad = true
                onLoadComplete?(currentURL)
            }
        }
        


        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            if let url = navigationAction.request.url {
                let scheme = url.scheme?.lowercased() ?? ""
                
                if scheme == "about" {
                    decisionHandler(.allow)
                    return
                }
                
                if url.host?.contains("challenges.cloudflare.com") == true {
                    decisionHandler(.allow)
                    return
                }
                
                if ["http", "https"].contains(scheme) {
                    decisionHandler(.allow)
                } else if ["tel", "mailto", "sms"].contains(scheme) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    decisionHandler(.cancel)
                } else {
                    decisionHandler(.cancel)
                }
            } else {
                decisionHandler(.allow)
            }
        }

        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {
            
            if let url = navigationAction.request.url {
                if url.host?.contains("challenges.cloudflare.com") == true {
                    let newWebView = WKWebView(frame: .zero, configuration: configuration)
                    newWebView.navigationDelegate = self
                    newWebView.uiDelegate = self
                    return newWebView
                }
            }
            
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
        
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                completionHandler()
            })
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(alert, animated: true)
            }
        }
        
        func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                completionHandler(false)
            })
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                completionHandler(true)
            })
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(alert, animated: true)
            }
        }
    }
}
