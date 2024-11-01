import UIKit
//
//  DynamicBarView.swift
//  ExamplePorject
//
//  Created by MNouman on 01/10/2024.
//
import UIKit

class DynamicBarViewnew: UIView {

    // Red and blue views representing the values
    private let redView = UIView()
    private let blueView = UIView()

    // For holding the boxing icon
    private let iconImageView = UIImageView(image: UIImage.pkKnob)

    private var redViewWidthConstraint: NSLayoutConstraint!
    private var blueViewWidthConstraint: NSLayoutConstraint!
    private var iconCenterXConstraint: NSLayoutConstraint!
    private var firstTime = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        // Configure the red and blue views
        redView.backgroundColor = .ML_FF_3_B_75
        blueView.backgroundColor = .ML_0_DA_9_F_4
        addSubview(redView)
        addSubview(blueView)
        addSubview(iconImageView)

        redView.translatesAutoresizingMaskIntoConstraints = false
        blueView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        redViewWidthConstraint = redView.widthAnchor.constraint(equalToConstant: 0)
        blueViewWidthConstraint = blueView.widthAnchor.constraint(equalToConstant: 0)

        // Activate initial layout constraints
        NSLayoutConstraint.activate([
            redView.leadingAnchor.constraint(equalTo: leadingAnchor),
            redView.topAnchor.constraint(equalTo: topAnchor),
            redView.bottomAnchor.constraint(equalTo: bottomAnchor),
            redViewWidthConstraint,

            blueView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blueView.topAnchor.constraint(equalTo: topAnchor),
            blueView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blueViewWidthConstraint,

            // Icon constraints
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 55), // Adjust as needed
            iconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])

        // Add the icon's center X constraint relative to redView's trailing edge
        iconCenterXConstraint = iconImageView.centerXAnchor.constraint(equalTo: redView.trailingAnchor)
        iconCenterXConstraint.isActive = true

    }

//    // Method to update the bar dynamically with animation, including the icon's position and label values
    func updateBar(redValue: CGFloat, blueValue: CGFloat, totalValue: CGFloat,leftLabel:UILabel,rightLabel:UILabel) {
        iconImageView.image = UIImage.pkKnob
        let totalWidth = self.frame.width
        let safeTotalValue = totalValue > 0 ? totalValue : 1.0
        
        if totalValue == 0 {
            UIView.animate(withDuration: firstTime ? 0 : 1.0) {
                self.firstTime = false
                
                // Set both bars to 50% of the total width
                self.redViewWidthConstraint.constant = totalWidth / 2
                self.blueViewWidthConstraint.constant = totalWidth / 2
                
                // Center the icon in the middle of the view
                self.iconCenterXConstraint.constant = 0
                
                self.updateLabelWithZoomEffect(label: leftLabel, newText: "0")
                self.updateLabelWithZoomEffect(label: rightLabel, newText: "0")
                
                // Recalculate layout
                self.layoutIfNeeded()
            }
            return
        }
        let redRatio = redValue / safeTotalValue
        let blueRatio = blueValue / safeTotalValue

        // Update the labels' text
        let redValue = "\(Int(redValue))"
        let blueValue = "\(Int(blueValue))"
        updateLabelWithZoomEffect(label: leftLabel, newText: redValue)
        updateLabelWithZoomEffect(label: rightLabel, newText: blueValue)


        // Update constraints with animation
        UIView.animate(withDuration: firstTime ? 0 : 1.0) {
            self.firstTime = false
            // Update the width constraints
            self.redViewWidthConstraint.constant = totalWidth * redRatio
            self.blueViewWidthConstraint.constant = totalWidth * blueRatio
            self.layoutIfNeeded()
        }
    }
    // Function to update the UILabel's text with a zoom effect
    func updateLabelWithZoomEffect(label: UILabel, newText: String, duration: TimeInterval = 0.3, scale: CGFloat = 1.2) {
        // Animate the zoom in effect
        UIView.animate(withDuration: duration / 2, animations: {
            label.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: { _ in
            // Update the label's text
            label.text = newText
            
            // Animate the zoom out effect
            UIView.animate(withDuration: duration / 2, animations: {
                label.transform = CGAffineTransform.identity
            })
        })
    }

}
