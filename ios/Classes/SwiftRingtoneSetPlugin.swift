import Flutter
import UIKit
import AVFoundation

public class SwiftRingtoneSetPlugin: NSObject, FlutterPlugin {
  private var audioPlayer: AVAudioPlayer?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ringtone_set", binaryMessenger: registrar.messenger())
    let instance = SwiftRingtoneSetPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getPlatformSdk":
      result(13) // Example SDK version for iOS
    case "setRingtone", "setNotification", "setAlarm":
      // On iOS, we can't set system ringtones, but we can play sounds
      if let args = call.arguments as? [String: Any],
         let path = args["path"] as? String {
        playSound(path: path)
        // Return a dictionary with information about iOS limitations
        result([
          "success": true,
          "platformLimited": true,
          "message": "On iOS, sounds can only be played within the app, not set as system sounds due to iOS restrictions."
        ])
      } else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Path is missing", details: nil))
      }
    case "isWriteGranted":
      // iOS doesn't have the concept of WRITE_SETTINGS permission
      result(false)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func playSound(path: String) {
    do {
      // Check if the file exists
      let fileManager = FileManager.default
      var soundURL: URL
      
      if path.hasPrefix("/") {
        // Absolute path
        soundURL = URL(fileURLWithPath: path)
      } else {
        // Relative path, assume it's a Flutter asset
        if let assetPath = Bundle.main.path(forResource: path, ofType: nil) {
          soundURL = URL(fileURLWithPath: assetPath)
        } else {
          print("File not found: \(path)")
          return
        }
      }
      
      if fileManager.fileExists(atPath: soundURL.path) {
        try AVAudioSession.sharedInstance().setCategory(.playback)
        try AVAudioSession.sharedInstance().setActive(true)
        
        audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
      } else {
        print("File does not exist at path: \(soundURL.path)")
      }
    } catch {
      print("Error playing sound: \(error.localizedDescription)")
    }
  }
}