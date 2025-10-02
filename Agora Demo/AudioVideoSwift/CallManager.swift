//
//  CallManager.swift
//  Agora Demo
//
//  Created by iOS Team on 16/07/25.
//


import Foundation
import CallKit
import AVFoundation
import UIKit

class CallManager: NSObject {
    static let shared = CallManager()
    
    private var provider: CXProvider!
    private var callController = CXCallController()
    var agoraManager = AgoraManager.shared
    //var currentChannelName: String?
    
    override init() {
        let config = CXProviderConfiguration(localizedName: "AgoraAudioCall"/*for video call "AgoraVideoCall"*/)
        config.supportsVideo = false//false for audio call and true for video call
        config.includesCallsInRecents = true
        config.supportedHandleTypes = [.generic]
        config.maximumCallsPerCallGroup = 1
        config.iconTemplateImageData = UIImage(systemName: "phone")?.pngData()
        provider = CXProvider(configuration: config)
        super.init()
        provider.setDelegate(self, queue: nil)
    }

    func startCall(channelName: String) {
        let handle = CXHandle(type: .generic, value: channelName)
        let uuid = UUID()
        let action = CXStartCallAction(call: uuid, handle: handle)
        let transaction = CXTransaction(action: action)
        requestTransaction(transaction)
    }

    func endCall() {
        guard let uuid = callController.callObserver.calls.first?.uuid else { return }
        let action = CXEndCallAction(call: uuid)
        let transaction = CXTransaction(action: action)
        requestTransaction(transaction)
    }
    
    func reportIncomingCall(from caller: String, channelName: String) {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, options: [.allowBluetooth, .defaultToSpeaker])
            try session.setMode(.videoChat)
            try session.setActive(true)
        } catch {
            print("Audio session configuration failed: \(error)")
        }
        //currentChannelName = channelName
        let update = CXCallUpdate()
        update.localizedCallerName = caller
        update.hasVideo = false//false for audio call and true for video call
        let uuid = UUID()
        provider.reportNewIncomingCall(with: uuid , update: update) { error in
            if let error = error {
                print("❌ CallKit report error: \(error)")
            } else {
                print("✅ Incoming call reported")
            }
        }
    }
    
    private func requestTransaction(_ transaction: CXTransaction) {
        callController.request(transaction) { error in
            if let error = error {
                print("❌ CallKit transaction error: \(error)")
            } else {
                print("✅ CallKit transaction requested.")
            }
        }
    }
    
    func dismissAudioCallScreen() {
        guard let rootVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            print("❌ Couldn't get root view controller")
            return
        }

        if let presented = rootVC.presentedViewController as? AudioCall {
            presented.dismiss(animated: true, completion: {
                print("✅ AudioCallVC dismissed")
            })
        } else {
            print("ℹ️ No AudioCallVC to dismiss")
        }
    }
    
    func dismissVideoCallScreen() {
        guard let rootVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            print("❌ Couldn't get root view controller")
            return
        }

        if let presented = rootVC.presentedViewController as? VideoCallVC {
            presented.dismiss(animated: true, completion: {
                print("✅ VideoCallVC dismissed")
            })
        } else {
            print("ℹ️ No VideoCallVC to dismiss")
        }
    }
}

extension CallManager: CXProviderDelegate{
    func providerDidReset(_ provider: CXProvider) {
        print("🔄 CallKit provider reset")
    }
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("📞 CXAnswerCallAction")
        action.fulfill()
    }
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        print("📞 CXStartCallAction")
        //currentChannelName = action.handle.value
        action.fulfill()
    }
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("📞 CXEndCallAction")
        action.fulfill()
    }
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("✅ didActivate: video session active")
        agoraManager.joinChannel(channelName: "harsh_Demo")
    }
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("✅ didDeactivate: video session inactive")
        agoraManager.leaveChannel()
        //dismissVideoCallScreen() //for video call screen
        dismissAudioCallScreen() //for audio call screen
    }
}
