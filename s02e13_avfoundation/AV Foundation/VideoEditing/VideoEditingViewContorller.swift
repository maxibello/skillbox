//
//  ViewController.swift
//  s02e13_avfoundation
//
//  Created by Maksim Kuznetsov on 25.09.2021.
//

import UIKit
import AVFoundation

class AssetStore {
    let video1: AVAsset
    let video2: AVAsset
    let video3: AVAsset
    let music1: AVAsset
    let music2: AVAsset
    
    init(video1: AVAsset,
         video2: AVAsset,
         video3: AVAsset,
         music1: AVAsset,
         music2: AVAsset) {
        self.video1 = video1
        self.video2 = video2
        self.video3 = video3
        self.music1 = music1
        self.music2 = music2
    }
    
    static func asset(_ resource: String, type: String) -> AVAsset {
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else { fatalError() }
        let url = URL(fileURLWithPath: path)
        return AVAsset(url: url)
    }
    
    static func test() -> AssetStore {
        return AssetStore(video1: asset("sup", type: "mp4"),
                          video2: asset("messi", type: "mp4"),
                          video3: asset("party", type: "mp4"),
                          music1: asset("nine", type: "mp3"),
                          music2: asset("bullshit", type: "mp3"))
    }
    
    func compose() -> (asset: AVAsset, composition: AVMutableVideoComposition) {
        let composition = AVMutableComposition()
        let videoComposition: AVMutableVideoComposition = AVMutableVideoComposition(propertiesOf: composition)
        videoComposition.renderSize = .init(width: 720, height: 1280)
        
        guard let videoTrack1 = composition.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { fatalError() }
        guard let videoTrack2 = composition.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { fatalError() }
        guard let videoTrack3 = composition.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { fatalError() }
        guard let audioTrack1 = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { fatalError() }
        guard let audioTrack2 = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { fatalError() }
        
        let transitionDuration = CMTime(seconds: 2, preferredTimescale: 600)
        
        try? videoTrack1.insertTimeRange(
            CMTimeRange(
                start: CMTime.zero,
                duration: video1.duration
            ),
            of: video1.tracks(withMediaType: .video)[0],
            at: CMTime.zero
        )
        
        try? videoTrack2.insertTimeRange(
            CMTimeRange(
                start: CMTime.zero,
                duration: video2.duration
            ),
            of: video2.tracks(withMediaType: .video)[0],
            at: video1.duration - transitionDuration
        )
        
        try? videoTrack3.insertTimeRange(
            CMTimeRange(
                start: CMTime.zero,
                duration: video3.duration
            ),
            of: video3.tracks(withMediaType: .video)[0],
            at: video1.duration + video2.duration
        )
        
        try? audioTrack1.insertTimeRange(
            CMTimeRange(
                start: CMTime.zero,
                duration: video1.duration + video2.duration
            ),
            of: music1.tracks(withMediaType: .audio)[0],
            at: CMTime.zero
        )
        
        try? audioTrack2.insertTimeRange(
            CMTimeRange(
                start: CMTime.zero,
                duration: video3.duration
            ),
            of: music2.tracks(withMediaType: .audio)[0],
            at: video1.duration + video2.duration)
        
        let passThroughInstruction1 = AVMutableVideoCompositionInstruction()
        passThroughInstruction1.timeRange = CMTimeRange(start: CMTime.zero, duration: video1.duration - transitionDuration)
        let passThroughLayerInstruction1 = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack1)
        passThroughLayerInstruction1.setTransform(videoTrack1.preferredTransform, at: CMTime.zero)
        passThroughInstruction1.layerInstructions = [passThroughLayerInstruction1]
        
        
        let passThroughInstruction2 = AVMutableVideoCompositionInstruction()
        passThroughInstruction2.timeRange = CMTimeRange(start: video1.duration, duration: video2.duration)
        let passThroughLayerInstruction2 = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack2)
        passThroughLayerInstruction2.setTransform(videoTrack2.preferredTransform, at: CMTime.zero)
        passThroughInstruction2.layerInstructions = [passThroughLayerInstruction2]
        
        
        let passThroughInstruction3 = AVMutableVideoCompositionInstruction()
        passThroughInstruction3.timeRange = CMTimeRange(start: video1.duration + video2.duration, duration: video3.duration)
        
        //------------
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: video1.duration - transitionDuration, duration: transitionDuration)
        
        //MARK: инструкция к video1
        let video1Instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack1)
        // описание позиций video1 к инструкции
        let video1pos1 = CGAffineTransform(translationX: 0, y: 0)
        let video1pos2 = CGAffineTransform(translationX: videoComposition.renderSize.width, y: 0)
        // установка инструкции video1
        video1Instruction.setTransformRamp(fromStart: video1pos1, toEnd: video1pos2, timeRange: instruction.timeRange)
        
        //MARK: инструкция к video2
        let video2Instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack2)
        // описание позиций video2 к инструкции
        let video2pos1 = CGAffineTransform(translationX: -videoComposition.renderSize.width, y: 0)
        let video2pos2 = CGAffineTransform(translationX: 0, y: 0)
        // установка инструкции video2
        video2Instruction.setTransformRamp(fromStart: video2pos1, toEnd: video2pos2, timeRange: instruction.timeRange)
        //        videoComposition.instructions = [passthroughInstruction1, video1Instruction, video2Instruction, passThroughInstruction2, passThroughInstruction3]
        
        
        let video3Instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack3)
        
        let timeRange = CMTimeRange(start: video1.duration + video2.duration, duration: transitionDuration)
        
        let video2Size = video2.tracks(withMediaType: .video)[0].naturalSize
        let video3Size = video3.tracks(withMediaType: .video)[0].naturalSize
        
        let W = video2Size.width / video3Size.width
        let H = video2Size.height / video3Size.height
        
        
        let video3scale1 = CGAffineTransform(scaleX: 0.001, y: 0.001)
        let video3scale2 = CGAffineTransform(scaleX: W, y: H)
        
        video3Instruction.setTransformRamp(
            fromStart: video3scale1,
            toEnd: video3scale2,
            timeRange: timeRange)
        
        passThroughInstruction3.layerInstructions.append(video3Instruction)
        
        instruction.layerInstructions = [video1Instruction, video2Instruction, video3Instruction] //MARK: установка эффектов
        videoComposition.instructions = [passThroughInstruction1, instruction, passThroughInstruction2, passThroughInstruction3]
        
        
        //-----------
        
        
        //        let transitionRange = CMTimeRange(start: video1.duration - transitionDuration, duration: transitionDuration)
        //        let videoComposition = AVMutableVideoComposition(propertiesOf: composition)
        //
        //        let transitionInstruction = AVMutableVideoCompositionInstruction()
        //        transitionInstruction.timeRange = transitionRange
        //
        //        let fadeOutInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack1)
        ////        fadeOutInstruction.setOpacityRamp(fromStartOpacity: 1, toEndOpacity: 0, timeRange: transitionRange)
        //
        //        let transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
        //        fadeOutInstruction.setTransform(transform, at: transitionRange.start)
        //
        //
        //        let fadeInInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack2)
        ////        fadeInInstruction.setOpacityRamp(fromStartOpacity: 0, toEndOpacity: 1, timeRange: transitionRange)
        //        fadeInInstruction.setTransform(CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0), at: transitionRange.end)
        //        transitionInstruction.layerInstructions = [fadeOutInstruction,fadeInInstruction]
        //
        //
        //
        //        let passthroughInstruction1 = AVMutableVideoCompositionInstruction()
        //        passthroughInstruction1.timeRange = CMTimeRange(start: CMTime.zero, duration: video1.duration - transitionDuration)
        //
        //        let passthroughLayerInstruction1 = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack1)
        //        passthroughLayerInstruction1.setTransform(videoTrack1.preferredTransform, at: CMTime.zero)
        //        passthroughInstruction1.layerInstructions = [passthroughLayerInstruction1]
        //
        //        let passthroughInstruction2 = AVMutableVideoCompositionInstruction()
        //        passthroughInstruction2.timeRange = CMTimeRange(start: video1.duration, duration: video2.duration - transitionDuration)
        //
        //        let passthroughLayerInstruction2 = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack2)
        //        passthroughLayerInstruction2.setTransform(videoTrack2.preferredTransform, at: CMTime.zero)
        //        passthroughInstruction2.layerInstructions = [passthroughLayerInstruction2]
        //
        //        videoComposition.instructions = [passthroughInstruction1, transitionInstruction, passthroughInstruction2]
        
        //        func insertVideo(asset: AVAsset, at: CMTime) {
        //            try? videoTrack.insertTimeRange(
        //                CMTimeRange(
        //                    start: CMTime.zero,
        //                    duration: asset.duration
        //                ),
        //                of: asset.tracks(withMediaType: .video)[0],
        //                at: at)
        //        }
        //
        //        insertVideo(asset: video1, at: CMTime.zero)
        //        insertVideo(asset: video2, at: video1.duration)
        //        insertVideo(asset: video3, at: video1.duration + video2.duration)
        
        
        
        //        try? audioTrack.insertTimeRange(
        //            CMTimeRange(
        //                start: CMTime.zero,
        //                duration: video3.duration
        //            ),
        //            of: music2.tracks(withMediaType: .audio)[0],
        //            at: video1.duration + video2.duration)
        
        
        return (composition, videoComposition)
    }
    
    func export(asset: AVAsset, composition: AVVideoComposition, completion: @escaping (Bool) -> Void ) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }
        
        let url = documentDirectory.appendingPathComponent("merdegVideo.mov")
        
        guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetLowQuality) else { fatalError() }
        
        exporter.outputURL = url
        exporter.outputFileType = .mov
        exporter.videoComposition = composition
        
        exporter.exportAsynchronously {
            print(exporter.error ?? "No errors")
            DispatchQueue.main.async {
                completion(exporter.status == .completed)
            }
        }
    }
}

class VideoEditingViewContorller: UIViewController {
    
    let store = AssetStore.test()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let (asset, videoComposition) = store.compose()
        startPlaying(asset: asset, videoComposition: videoComposition)
    }
    
    func startPlaying(asset: AVAsset, videoComposition: AVMutableVideoComposition) {
        let playerItem = AVPlayerItem(asset: asset)
        
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        
        let syncLayer = AVSynchronizedLayer.init(playerItem: playerItem)
        let frame = view.bounds.insetBy(dx: 0, dy: 200)
        playerLayer.frame = frame
        syncLayer.frame = frame
        let circleLayer = CAShapeLayer()
        
        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 100, height: 100), cornerRadius: 50).cgPath
        circleLayer.fillColor = UIColor.white.cgColor
        circleLayer.opacity = 0.3
        
        circleLayer.position = CGPoint(x: 0, y: frame.height)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = [0, frame.height]
        animation.toValue = [frame.width, 0]
        animation.duration = playerItem.asset.duration.seconds
        animation.beginTime = .zero
        animation.isRemovedOnCompletion = false
        animation.beginTime = AVCoreAnimationBeginTimeAtZero
        circleLayer.add(animation, forKey: "animatePosition")
        syncLayer.addSublayer(circleLayer)
        
        playerItem.videoComposition = videoComposition
        
        view.layer.addSublayer(playerLayer)
        view.layer.addSublayer(syncLayer)
        player.play()
    }
    
    @IBAction func export(_ sender: Any) {
        
        let compose = store.compose()
        store.export(asset: compose.asset, composition: compose.composition) { success in
            print(success)
        }
    }
    
}

