//
//  SampleHandler.swift
//  BroadcastUpload
//
//  Created by Roman on 28.02.2021.
//

import BroadcastWriter
import ReplayKit
import UserNotifications

class SampleHandler: RPBroadcastSampleHandler {

    private var writer: BroadcastWriter?
    private let fileManager: FileManager = .default
    private let notificationCenter = UNUserNotificationCenter.current()
    private let nodeURL: URL

    override init() {
        nodeURL = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(for: .mpeg4Movie)

        fileManager.removeFileIfExists(url: nodeURL)

        super.init()
    }

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        let screen: UIScreen = .main
        do {
            writer = try .init(
                outputURL: nodeURL,
                screenSize: screen.bounds.size,
                screenScale: screen.scale
            )
        } catch {
            assertionFailure(error.localizedDescription)
            finishBroadcastWithError(error)
            return
        }
        do {
            try writer?.start()
        } catch {
            finishBroadcastWithError(error)
        }
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        guard let writer = writer else {
            debugPrint("processSampleBuffer: Writer is nil")
            return
        }

        do {
            let captured = try writer.processSampleBuffer(sampleBuffer, with: sampleBufferType)
            debugPrint("processSampleBuffer captured", captured)
        } catch {
            debugPrint("processSampleBuffer error:", error.localizedDescription)
        }
    }

    override func broadcastPaused() {
        debugPrint("=== paused")
        writer?.pause()
    }

    override func broadcastResumed() {
        debugPrint("=== resumed")
        writer?.resume()
    }

    override func broadcastFinished() {
        guard let writer = writer else {
            return
        }

        let outputURL: URL
        do {
            outputURL = try writer.finish()
        } catch {
            debugPrint("writer failure", error)
            return
        }

        guard let containerURL = fileManager.containerURL(
                    forSecurityApplicationGroupIdentifier: "group.com.andrykevych.Example"
        )?.appendingPathComponent("Library/Documents/") else {
            fatalError("no container directory")
        }
        do {
            try fileManager.createDirectory(
                at: containerURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            debugPrint("error creating", containerURL, error)
        }

        let destination = containerURL.appendingPathComponent(outputURL.lastPathComponent)
        do {
            debugPrint("Moving", outputURL, "to:", destination)
            try self.fileManager.moveItem(
                at: outputURL,
                to: destination
            )
        } catch {
            debugPrint("ERROR", error)
        }

        debugPrint("FINISHED")
    }

    private func scheduleNotification() {
        print("scheduleNotification")
        let content: UNMutableNotificationContent = .init()
        content.title = "broadcastStarted"
        content.subtitle = Date().description

        let trigger: UNNotificationTrigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
        let notificationRequest: UNNotificationRequest = .init(
            identifier: "com.andrykevych.Some.broadcastStarted.notification",
            content: content,
            trigger: trigger
        )
        notificationCenter.add(notificationRequest) { (error) in
            print("add", notificationRequest, "with ", error?.localizedDescription ?? "no error")
        }
    }
}

extension FileManager {

    func removeFileIfExists(url: URL) {
        guard fileExists(atPath: url.path) else { return }
        do {
            try removeItem(at: url)
        } catch {
            print("error removing item \(url)", error)
        }
    }
}
