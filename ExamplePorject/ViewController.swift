//
//  ViewController.swift
//  ExamplePorject
//
//  Created by MNouman on 29/08/2024.
//

import UIKit

class ViewController2: UIViewController {
    
    var views = [1,2]
    var colors:[UIColor] = [.red,.blue]
    private var originalCenter: CGPoint?
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
            videoView.backgroundColor = colors[0]
            videoView.tag = 0
            addTapGesture(to: videoView)
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
                        videoView.tag = index
                        addTapGesture(to: videoView)
                        videoView.backgroundColor = colors[index]
                        rowStackView.addArrangedSubview(videoView)
                    } else {
                        rowStackView.addArrangedSubview(addDummyView()) // Empty view for grid balance
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
            firstView.tag = 0
            addTapGesture(to: firstView)
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
            let add = 7 - remainingViews.count
            let rows = Int(ceil(Double(remainingViews.count + add) / Double(columns)))
//            rows = rows + add
            
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
                        videoView.tag = index
                        addTapGesture(to: videoView)
                        videoView.backgroundColor = colors[index]
                        rowStackView.addArrangedSubview(videoView)
                        
                    } else {
                        rowStackView.addArrangedSubview(addDummyView()) // Empty view for grid balance
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
    func addDummyView() -> UIView {
        let dummyView = UIView()
        dummyView.backgroundColor = UIColor(red: 33/255, green: 23/255, blue: 42/255, alpha: 1.0)
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("Add", for: .normal)
        dummyView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: dummyView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: dummyView.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 28),
            button.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        // Add the dummy view to the array
//        dummyViews.append(dummyView)
        return dummyView
    }
    
    // Function to clear all dummy views
    func clearDummyViews() {
//        dummyViews.forEach { $0.removeFromSuperview() }
//        dummyViews.removeAll()
    }
    private func addTapGesture(to videoView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        videoView.addGestureRecognizer(panGesture)
        
        videoView.isUserInteractionEnabled = true
        
    }
    @objc func handleDrag(_ gesture: UIPanGestureRecognizer) {
        guard let draggedView = gesture.view else { return }
        
        switch gesture.state {
        case .began:
            originalCenter = draggedView.center // Save the original center for reference
            
        case .changed:
            let translation = gesture.translation(in: view)
            // Move the view as the user drags
            draggedView.center = CGPoint(x: draggedView.center.x + translation.x, y: draggedView.center.y + translation.y)
            gesture.setTranslation(.zero, in: view)
            // Prevent dragging outside of cameraView's bounds
            let newCenter = CGPoint(x: draggedView.center.x + translation.x, y: draggedView.center.y + translation.y)
            
            if view.bounds.contains(newCenter) {
                draggedView.center = newCenter
            }
            
        case .ended, .cancelled:
            if let swapTarget = detectSwapTarget(for: draggedView) {
                swapViews(draggedView, with: swapTarget)
            } else {
                // If no swap target is detected, move the view back to its original position
                UIView.animate(withDuration: 0.3) {
                    draggedView.center = self.originalCenter ?? draggedView.center
                }
            }
            
        default:
            break
        }
    }
    func detectSwapTarget(for draggedView: UIView) -> UIView? {
        var closestView: UIView?
        var closestDistance: CGFloat = .greatestFiniteMagnitude
        
        // Get the center point of the dragged view
        let draggedCenter = draggedView.center
        
        // Recursively check all subviews of cameraView
        closestView = findClosestView(in: view, excluding: draggedView, draggedCenter: draggedCenter, closestDistance: &closestDistance)
        
        // Return the closest view if it's within a reasonable distance (adjust this threshold as needed)
//        if closestDistance < draggedView.frame.width {
//            return closestView
//        }
        
        return closestView
    }
    // Recursive function to traverse subviews and find the closest view
    func findClosestView(in containerView: UIView, excluding draggedView: UIView, draggedCenter: CGPoint, closestDistance: inout CGFloat) -> UIView? {
        var closestView: UIView?
        
        for subview in containerView.subviews {
            // If the subview is a stack view, traverse its arranged subviews
            if let stackView = subview as? UIStackView {
                // Recursively traverse the arrangedSubviews of the stackView
                for arrangedSubview in stackView.arrangedSubviews {
                    // Recursive check for nested stack views
                    if let nestedClosestView = findClosestView(in: arrangedSubview, excluding: draggedView, draggedCenter: draggedCenter, closestDistance: &closestDistance) {
                        closestView = nestedClosestView
                    }
                }
            } else {
                // If it's not a stack view and not the dragged view itself, check the distance
                if subview != draggedView {
                    // Convert the subview's frame to the coordinate space of cameraView
                    let convertedFrame = subview.convert(subview.bounds, to: view)
                    
                    // Calculate the distance between the centers
                    let distance = distanceBetweenPoints(draggedCenter, CGPoint(x: convertedFrame.midX, y: convertedFrame.midY))
                    
                    // Update the closest view if this subview is closer
                    if distance < closestDistance {
                        closestDistance = distance
                        closestView = subview
                    }
                }
            }
        }
        
        return closestView
    }
    func distanceBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let dx = point1.x - point2.x
        let dy = point1.y - point2.y
        return sqrt(dx * dx + dy * dy)
    }
    func swapViews(_ firstView: UIView, with secondView: UIView) {
        let firstTag = firstView.tag
        let secondTag = secondView.tag
        
        // Swap centers of the views
        let firstCenter = firstView.center
        let secondCenter = secondView.center
        
        UIView.animate(withDuration: 0.3) {
            firstView.center = secondCenter
            secondView.center = firstCenter
        }
        
        views.swapAt(secondTag, firstTag)
        setupVideoLayout(for: views)
    }
}
extension UIColor {
    static var random: UIColor {
        return .init(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
    }
}
