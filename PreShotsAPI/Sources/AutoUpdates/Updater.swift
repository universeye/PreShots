//
//  Updater.swift
//
//
//  Created by Terry Kuo on 2024/8/13.
//

import AppKit

public class Updater {
    public static let shared = Updater()
    let owner = "universeye"
    let repo = "PreShots"
    
    public func checkForUpdates(withAlert: Bool = false) {
        print("Checking for updates...")
        let urlString = "https://api.github.com/repos/\(owner)/\(repo)/releases/latest"
        guard let url = URL(string: urlString) else {
            print("Failed getting url")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Error fetching updates: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let release = try decoder.decode(GitHubRelease.self, from: data)
                let latestVersion = release.tagName.replacingOccurrences(of: "v", with: "")
                print("latestVersion: \(latestVersion)")
                if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                   let asset = release.assets.first(where: { $0.name.hasSuffix(".dmg") }) {
                    DispatchQueue.main.async {
                        self.promptForUpdate(latestVersion: latestVersion, currentVersion: currentVersion, downloadURL: asset.browserDownloadURL, withAlert: withAlert)
                    }
                }
            } catch {
                print("Error parsing release data: \(error)")
            }
        }.resume()
    }
    
    func promptForUpdate(latestVersion: String, currentVersion: String, downloadURL: String, withAlert: Bool) {
        if latestVersion > currentVersion {
            let alert = NSAlert()
            alert.messageText = "Update Available"
            alert.informativeText = "Version \(latestVersion) is available. Would you like to update?"
            alert.addButton(withTitle: "Update")
            alert.addButton(withTitle: "Later")
            
            if alert.runModal() == .alertFirstButtonReturn {
                downloadAndInstallUpdate(from: downloadURL)
            }
        } else {
            if withAlert {
                let alert = NSAlert()
                alert.messageText = "You're up-to-date!"
                alert.informativeText = "Version \(currentVersion) is currently the newest version available."
                alert.addButton(withTitle: "OK")
                
                if alert.runModal() == .alertFirstButtonReturn {
                }
            }
        }
        
    }
    
    func downloadAndInstallUpdate(from urlString: String) {
        guard let downloadURL = URL(string: urlString) else { return }
        
        let downloadTask = URLSession.shared.downloadTask(with: downloadURL) { localURL, urlResponse, error in
            guard let localURL = localURL else {
                print("Download failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                // Get file attributes
                let attributes = try FileManager.default.attributesOfItem(atPath: localURL.path)
                print("File size: \(attributes[.size] ?? "Unknown")")
                print("File permissions: \(attributes[.posixPermissions] ?? "Unknown")")
                
                // Check file type
                let fileTypeProcess = Process()
                fileTypeProcess.launchPath = "/usr/bin/file"
                fileTypeProcess.arguments = ["-b", localURL.path]
                let fileTypePipe = Pipe()
                fileTypeProcess.standardOutput = fileTypePipe
                try fileTypeProcess.run()
                fileTypeProcess.waitUntilExit()
                let fileType = String(data: fileTypePipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
                print("File type: \(fileType ?? "Unknown")")
                
                // Try to get DMG info
                let infoProcess = Process()
                infoProcess.launchPath = "/usr/bin/hdiutil"
                infoProcess.arguments = ["imageinfo", localURL.path]
                let infoPipe = Pipe()
                infoProcess.standardOutput = infoPipe
                infoProcess.standardError = infoPipe
                try infoProcess.run()
                infoProcess.waitUntilExit()
                let infoOutput = String(data: infoPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)
                print("DMG info output: \(infoOutput ?? "No output")")
                
                // Try to list DMG contents without mounting
                let listProcess = Process()
                listProcess.launchPath = "/usr/bin/hdiutil"
                listProcess.arguments = ["ls", "-R", localURL.path]
                let listPipe = Pipe()
                listProcess.standardOutput = listPipe
                listProcess.standardError = listPipe
                try listProcess.run()
                listProcess.waitUntilExit()
                let listOutput = String(data: listPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)
                print("DMG contents: \(listOutput ?? "Unable to list contents")")
                
                // If we've made it this far, outline next steps
                print("Next steps would be:")
                print("1. Verify the DMG file integrity")
                print("2. Attempt to extract contents without mounting")
                print("3. If extraction is successful, locate the .app file")
                print("4. Copy the .app file to the Applications folder")
                print("5. Set proper permissions on the new app")
                print("6. Launch the new app version")
                
            } catch {
                print("Error during diagnosis: \(error)")
            }
        }
        
        downloadTask.resume()
    }

    
}
