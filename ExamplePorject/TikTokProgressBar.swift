//
//  TikTokProgressBar.swift
//  ExamplePorject
//
//  Created by MNouman on 01/11/2024.
//


import UIKit

class TikTokProgressBar: UIView {

    private let progressContainerView = UIView()
    private let progressTrackView = UIView()
    private let knobImageView = UIImageView(image: UIImage.pkKnob)
    private var segmentViews: [UIView] = []
    
    private let leftLabel = UILabel()
    private let rightLabel = UILabel()
    
    private var progressTrackWidthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        // Setup container and track views
        progressContainerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        progressContainerView.layer.cornerRadius = 5
        progressContainerView.clipsToBounds = true
        
        progressTrackView.backgroundColor = .clear
        knobImageView.contentMode = .scaleAspectFit

        // Setup labels
        leftLabel.textColor = .white
        leftLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        rightLabel.textColor = .white
        rightLabel.font = UIFont.boldSystemFont(ofSize: 12)

        // Add subviews
        addSubview(progressContainerView)
        progressContainerView.addSubview(progressTrackView)
        addSubview(knobImageView)
        addSubview(leftLabel)
        addSubview(rightLabel)

        // Setup layout
        setupConstraints()
    }
    
    private func setupConstraints() {
        progressContainerView.translatesAutoresizingMaskIntoConstraints = false
        progressTrackView.translatesAutoresizingMaskIntoConstraints = false
        knobImageView.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            progressContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            progressContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressContainerView.heightAnchor.constraint(equalToConstant: 10),
            
            leftLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            leftLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            rightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            rightLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // Constraints for progress track view and knob
        progressTrackWidthConstraint = progressTrackView.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            progressTrackView.leadingAnchor.constraint(equalTo: progressContainerView.leadingAnchor),
            progressTrackView.topAnchor.constraint(equalTo: progressContainerView.topAnchor),
            progressTrackView.bottomAnchor.constraint(equalTo: progressContainerView.bottomAnchor),
            progressTrackWidthConstraint,
            
            knobImageView.centerYAnchor.constraint(equalTo: progressContainerView.centerYAnchor),
            knobImageView.widthAnchor.constraint(equalToConstant: 20),
            knobImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setSegments(segments: [CGFloat], colors: [UIColor]) {
        // Remove old segments
        segmentViews.forEach { $0.removeFromSuperview() }
        segmentViews = []
        
        // Create new segment views
        for (index, segment) in segments.enumerated() {
            let segmentView = UIView()
            segmentView.backgroundColor = colors[index % colors.count]
            segmentView.translatesAutoresizingMaskIntoConstraints = false
            progressContainerView.addSubview(segmentView)
            segmentViews.append(segmentView)
            
            let segmentWidth = progressContainerView.frame.width * segment
            NSLayoutConstraint.activate([
                segmentView.leadingAnchor.constraint(equalTo: index == 0 ? progressContainerView.leadingAnchor : segmentViews[index - 1].trailingAnchor),
                segmentView.widthAnchor.constraint(equalToConstant: segmentWidth),
                segmentView.topAnchor.constraint(equalTo: progressContainerView.topAnchor),
                segmentView.bottomAnchor.constraint(equalTo: progressContainerView.bottomAnchor)
            ])
        }
    }
    
    func updateProgress(value: CGFloat) {
        let maxWidth = progressContainerView.frame.width
        let trackWidth = maxWidth * value
        UIView.animate(withDuration: 0.25) {
            self.progressTrackWidthConstraint.constant = trackWidth
            self.knobImageView.center.x = self.progressTrackView.frame.maxX
            self.layoutIfNeeded()
        }
    }
    
    func setLeftLabel(text: String) {
        leftLabel.text = text
    }
    
    func setRightLabel(text: String) {
        rightLabel.text = text
    }
}
