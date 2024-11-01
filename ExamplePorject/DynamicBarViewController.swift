//
//  DynamicBarViewController.swift
//  ExamplePorject
//
//  Created by MNouman on 01/10/2024.
//

import UIKit

class DynamicBarViewController: UIViewController {
    
    @IBOutlet weak var viewContainer : UIView!
    @IBOutlet weak var progressView : UIView!
    @IBOutlet weak var leftScoreLabel : UILabel!
    @IBOutlet weak var rightScoreLabel : UILabel!
    
    let dynamicBar = DynamicBarViewnew()
    let progressBar = TikTokProgressBar()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pkBarViewSetup()
//        setupTiktokBar()
    }
    private func setupTiktokBar(){
        viewContainer.addSubview(progressBar)

        // Example configuration
        progressBar.setSegments(segments: [0.2, 0.4, 0.4], colors: [.systemPink, .systemBlue, .systemGreen])
        progressBar.setLeftLabel(text: "0:00")
        progressBar.setRightLabel(text: "Live")

        // Update progress as needed
        progressBar.updateProgress(value: 0.5) // Moves knob halfway
    }
    private func pkBarViewSetup(){
        // Set up the dynamic bar view
        
        viewContainer.applyEqualSplitBackground(leftColor: .ML_FF_3_B_75, rightColor: .ML_0_DA_9_F_4)
        viewContainer.bringSubviewToFront(progressView)
        dynamicBar.frame = progressView.bounds
        progressView.addSubview(dynamicBar)
        // Set initial values (for example, redValue = 20000, blueValue = 8000, totalValue = 28000)
        dynamicBar.updateBar(redValue: 0, blueValue: 0, totalValue: 0,leftLabel: leftScoreLabel,rightLabel: rightScoreLabel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.dynamicBar.updateBar(redValue: 150, blueValue: 20, totalValue: 170,leftLabel: self.leftScoreLabel,rightLabel: self.rightScoreLabel)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.dynamicBar.updateBar(redValue: 10, blueValue: 190, totalValue: 200,leftLabel: self.leftScoreLabel,rightLabel: self.rightScoreLabel)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    self.dynamicBar.updateBar(redValue: 0, blueValue: 0, totalValue: 0,leftLabel: self.leftScoreLabel,rightLabel: self.rightScoreLabel)
                })
            })
           
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIView {
    
    func applyHalfAndHalfBackground(leftColor: UIColor, rightColor: UIColor) {
        // Remove existing gradient layers if any
        self.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        // Define the two colors for the gradient
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        
        // Set up the gradient locations to split the colors equally
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5) // Left side
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)   // Right side
        gradientLayer.locations = [0.0, 0.5, 0.5, 1.0]
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyEqualSplitBackground(leftColor: UIColor, rightColor: UIColor) {
            // Remove any existing background layers if they exist
            self.layer.sublayers?.filter { $0.name == "equalSplitBackground" }.forEach { $0.removeFromSuperlayer() }
            
            // Create a gradient layer
            let gradientLayer = CAGradientLayer()
            gradientLayer.name = "equalSplitBackground"
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
            
            // Set locations to make a hard split at the center
            gradientLayer.locations = [0.0, 0.5, 0.5, 1.0]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            
            // Add the gradient layer as a background
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
}
