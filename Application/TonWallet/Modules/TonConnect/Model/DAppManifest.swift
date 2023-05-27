import Foundation

struct DAppManifest: Codable {
    let url: String
    let name: String
    let iconUrl: String
    let termsOfUseUrl: String?
    let privacyPolicyUrl: String?
}
