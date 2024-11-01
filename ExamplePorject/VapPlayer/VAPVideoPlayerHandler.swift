//
//  VAPVideoPlayerHandler.swift
//  ExamplePorject
//
//  Created by MNouman on 25/10/2024.
//


import UIKit
import AVKit

class VAPVideoPlayerHandler: NSObject {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var overlayLayer: CALayer?
    private var loadingIndicator: UIActivityIndicatorView?
    private var parentView: UIView

    init(parentView: UIView) {
        self.parentView = parentView
    }
    
    // MARK: - Setup Video Player
    func setupPlayer(with url: URL) {
        // Initialize AVPlayer with the remote URL
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        
        // Configure the player layer
        if let playerLayer = playerLayer {
            playerLayer.frame = parentView.bounds
            playerLayer.videoGravity = .resizeAspect
            parentView.layer.addSublayer(playerLayer)
        }
        
        // Add the overlay layer for top-right corner alpha animation
        setupOverlayLayer()
        
        // Add loading indicator
        setupLoadingIndicator()
        
        // Add observers to track playback
        addPlayerObservers()
    }

    // MARK: - Loading Indicator Setup
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator?.center = parentView.center
        loadingIndicator?.hidesWhenStopped = true
        if let loadingIndicator = loadingIndicator {
            parentView.addSubview(loadingIndicator)
            loadingIndicator.startAnimating()
        }
    }
    
    // MARK: - Overlay Layer Setup
    private func setupOverlayLayer() {
        overlayLayer = CALayer()
        overlayLayer?.frame = CGRect(x: parentView.bounds.width - 100, y: 0, width: 100, height: 100)
        overlayLayer?.backgroundColor = UIColor.red.withAlphaComponent(0.5).cgColor  // Example color with alpha
        overlayLayer?.cornerRadius = 50
        if let overlayLayer = overlayLayer {
            parentView.layer.addSublayer(overlayLayer)
            animateOverlayAlpha()
        }
    }

    private func animateOverlayAlpha() {
        guard let overlayLayer = overlayLayer else { return }
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.5
        animation.toValue = 1.0
        animation.duration = 1.5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        overlayLayer.add(animation, forKey: "alphaAnimation")
    }

    // MARK: - Playback Controls
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: .zero)
    }
    
    func replay() {
        player?.seek(to: .zero)
        player?.play()
    }

    // MARK: - Error Handling and Observers
    private func addPlayerObservers() {
        guard let playerItem = player?.currentItem else { return }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        
        playerItem.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
    }
    
    @objc private func playerDidFinishPlaying() {
        print("Playback completed.")
        replay()  // Replay video automatically or call stop() if needed
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            guard let status = player?.currentItem?.status else { return }
            switch status {
            case .readyToPlay:
                print("Player is ready to play.")
                loadingIndicator?.stopAnimating()  // Stop loading indicator
                play()
            case .failed:
                print("Failed to load video.")
                handlePlaybackError()
            default:
                break
            }
        }
    }
    
    private func handlePlaybackError() {
        loadingIndicator?.stopAnimating()
        // Handle playback error (e.g., show an alert)
        print("Error playing video. Please check the file format or network connection.")
    }

    // MARK: - Cleanup
    func cleanup() {
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        overlayLayer?.removeFromSuperlayer()
        loadingIndicator?.removeFromSuperview()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        player?.currentItem?.removeObserver(self, forKeyPath: "status")
    }
}
