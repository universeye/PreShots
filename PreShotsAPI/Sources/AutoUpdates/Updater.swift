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
                // Get the app's name
                guard let bundleID = Bundle.main.bundleIdentifier,
                      let runningApplication = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID).first,
                      let appURL = runningApplication.bundleURL else {
                    print("Could not get the current app's information")
                    return
                }
                
                let appName = appURL.lastPathComponent
                
                // Create a temporary directory
                let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
                try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
                
                // Unzip the downloaded file
                let unzipProcess = Process()
                unzipProcess.launchPath = "/usr/bin/unzip"
                unzipProcess.arguments = ["-q", localURL.path, "-d", tempDir.path]
                try unzipProcess.run()
                unzipProcess.waitUntilExit()
                
                // Find the .app file in the unzipped contents
                guard let newAppURL = try FileManager.default.contentsOfDirectory(at: tempDir, includingPropertiesForKeys: nil)
                    .first(where: { $0.pathExtension == "app" }) else {
                    print("Could not find .app file in the downloaded contents")
                    return
                }
                
                // Move the old app to the trash
                try FileManager.default.trashItem(at: appURL, resultingItemURL: nil)
                
                // Move the new app to the Applications folder
                let newAppFinalURL = URL(fileURLWithPath: "/Applications").appendingPathComponent(appName)
                try FileManager.default.moveItem(at: newAppURL, to: newAppFinalURL)
                
                // Relaunch the app
                DispatchQueue.main.async {
                    let alert = NSAlert()
                    alert.messageText = "Update Complete"
                    alert.informativeText = "The application has been updated. It will now restart."
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                    
                    let configuration = NSWorkspace.OpenConfiguration()
                    configuration.activates = true
                    NSWorkspace.shared.openApplication(at: newAppFinalURL, configuration: configuration) { _, error in
                        if let error = error {
                            print("Failed to relaunch app: \(error)")
                        } else {
                            exit(0)
                        }
                    }
                }
            } catch {
                print("Error during installation: \(error)")
            }
        }
        
        downloadTask.resume()
    }
}
