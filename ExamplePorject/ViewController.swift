//
//  ViewController.swift
//  ExamplePorject
//
//  Created by MNouman on 29/08/2024.
//

import UIKit

class ViewController: UIViewController {
    
    var views = [1,2,3,4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupVideoLayout(for: views)
    }
    
    private func setupVideoLayout(for videoViews: [Int]) {
        // Remove existing subviews
        view.subviews.forEach { $0.removeFromSuperview() }
        
        switch videoViews.count {
        case 1:
            // Full-screen layout for one participant
            let videoView = UIView()
            videoView.backgroundColor = .red
            view.addSubview(videoView)
            videoView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                videoView.topAnchor.constraint(equalTo: view.topAnchor),
                videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
            
        case 2,3,4:
            // Center videos in a grid layout for 2, 3, or 4 participants
            let mainStackView = UIStackView()
            mainStackView.axis = .vertical
            mainStackView.alignment = .fill
            mainStackView.distribution = .fillEqually
            mainStackView.spacing = 0
            
            let columns = videoViews.count == 2 ? 2 : 2
            let rows = Int(ceil(Double(videoViews.count) / Double(columns)))
            
            for rowIndex in 0..<rows {
                let rowStackView = UIStackView()
                rowStackView.axis = .horizontal
                rowStackView.alignment = .fill
                rowStackView.distribution = .fillEqually
                rowStackView.spacing = 0
                
                for columnIndex in 0..<columns {
                    let index = rowIndex * columns + columnIndex
                    if index < videoViews.count {
                        let videoView = UIView()
                        videoView.backgroundColor = UIColor.random
                        rowStackView.addArrangedSubview(videoView)
                    } else {
                        rowStackView.addArrangedSubview(UIView()) // Empty view for grid balance
                    }
                }
                
                mainStackView.addArrangedSubview(rowStackView)
            }
            
            view.addSubview(mainStackView)
            mainStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                mainStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: videoViews.count == 2 ? 0.5 : 0.65),
                mainStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
            ])
            
        default:
            let firstView = UIView()
            firstView.backgroundColor = .red
            view.addSubview(firstView)
            firstView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                firstView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                firstView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                firstView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                firstView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
            ])
            
            // Right half layout (two-column grid for remaining views)
            let rightHalfStackView = UIStackView()
            rightHalfStackView.axis = .vertical
            rightHalfStackView.alignment = .fill
            rightHalfStackView.distribution = .fillEqually
            rightHalfStackView.spacing = 2
            
            let remainingViews = Array(videoViews.dropFirst())
            let columns = 2
            let rows = Int(ceil(Double(remainingViews.count) / Double(columns)))
            
            for rowIndex in 0..<rows {
                let rowStackView = UIStackView()
                rowStackView.axis = .horizontal
                rowStackView.alignment = .fill
                rowStackView.distribution = .fillEqually
                rowStackView.spacing = 2
                
                for columnIndex in 0..<columns {
                    let index = rowIndex * columns + columnIndex
                    if index < remainingViews.count {
                        let videoView = UIView()
                        videoView.backgroundColor = .random
                        rowStackView.addArrangedSubview(videoView)
                        
                    } else {
                        rowStackView.addArrangedSubview(UIView()) // Empty view for grid balance
                    }
                }
                
                rightHalfStackView.addArrangedSubview(rowStackView)
            }
            
            view.addSubview(rightHalfStackView)
            rightHalfStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                rightHalfStackView.topAnchor.constraint(equalTo: firstView.topAnchor),
                rightHalfStackView.leadingAnchor.constraint(equalTo: firstView.trailingAnchor, constant: 0),
                rightHalfStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//                rightHalfStackView.bottomAnchor.constraint(equalTo: firstView.bottomAnchor, constant: 0)
                rightHalfStackView.heightAnchor.constraint(equalTo: firstView.heightAnchor, multiplier: CGFloat(0.25*Double(rows)))
//                rightHalfStackView.widthAnchor.constraint(equalTo: firstView.widthAnchor, multiplier: 1),
//                rightHalfStackView.heightAnchor.constraint(equalTo: firstView.widthAnchor) // Match the height to the first view
            ])
            
        }
        
        
    }
}
extension UIColor {
    static var random: UIColor {
        return .init(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
    }
}
