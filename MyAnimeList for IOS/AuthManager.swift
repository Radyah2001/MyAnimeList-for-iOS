//
//  AuthManager.swift
//  MyAnimeList for IOS
//
//  Created by Haydar Bahr on 17/04/2023.
//

import Foundation
import SwiftUI
import AuthenticationServices
import CryptoKit

class AuthManager: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    
    private let clientId = "34093f65c502c0fd011391170d76458e"
    private let clientSecret = ""
    private let redirectUri = "myanimeapp://callback"
    private let callbackURLScheme = "myanimeapp"
    private struct TokenResponse: Decodable {
        let token_type: String
        let expires_in: TimeInterval
        let access_token: String
        let refresh_token: String
    }
    private var codeVerifier: String?

    
    func authorize() {
        let state = UUID().uuidString
        codeVerifier = generateCodeVerifier()
        
        let authURL = URL(string: "https://myanimelist.net/v1/oauth2/authorize?response_type=code&client_id=\(clientId)&state=\(state)&redirect_uri=\(redirectUri)&code_challenge=\(codeVerifier!)&code_challenge_method=plain")!
        
        let authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: callbackURLScheme) { callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else {
                print("Error in authentication")
                return
            }
            
            self.handleCallbackURL(url: callbackURL)
        }
        
        authSession.presentationContextProvider = self
        authSession.start()
    }
    
    private func exchangeCodeForToken(authorizationCode: String){
        let url = URL(string: "https://myanimelist.net/v1/oauth2/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let bodyParameters = [
                "client_id": clientId,
                "client_secret": clientSecret,
                "grant_type": "authorization_code",
                "code": authorizationCode,
                "redirect_uri": redirectUri,
                "code_verifier": codeVerifier!
            ]

            let bodyString = bodyParameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            request.httpBody = bodyString.data(using: .utf8)

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("No data received")
                    return
                }
                // Print the raw data received from the server
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON data: \(jsonString)")
                }

                do {
                    let decoder = JSONDecoder()
                    let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
                    
                    // Save the access token and refresh token to your preferred storage method
                    // (e.g., UserDefaults, Keychain, etc.)
                    print("Access Token: \(tokenResponse.access_token)")
                    print("Refresh Token: \(tokenResponse.refresh_token)")

                } catch let decodingError {
                    print("Error decoding response: \(decodingError.localizedDescription)")
                }
            }
            task.resume()

    }
    
    private func generateCodeVerifier() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<128).map { _ in characters.randomElement()! })
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                fatalError("Unable to find a UIWindow to use as the presentation anchor")
            }
            return window
    }
    
    func handleCallbackURL(url: URL) {guard url.scheme == callbackURLScheme else { return }
        
        
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            guard let queryItems = components.queryItems else {
                print("Invalid callback URL")
                return
            }
            
            if let error = queryItems.first(where: { $0.name == "error" })?.value {
                print("Authorization error: \(error)")
                return
            }
            
            guard let code = queryItems.first(where: { $0.name == "code" })?.value else {
                print("Failed to get authorization code")
                return
            }
            print(code)
            
            exchangeCodeForToken(authorizationCode: code)
        } else {
            print("Invalid callback URL")
        }
        
    }
}

