//
//  VC2.swift
//  ExamplePorject
//
//  Created by MNouman on 14/09/2024.
//

//
//  ViewController.swift
//  ExampleProject
//
//  Created by MNouman on 29/08/2024.
//

import UIKit

class ViewController: UIViewController {
    
    // Array to hold actual views
    var views: [VideoPaticipentView] = []
    var colors: [UIColor] = [.red, .blue,.purple,.green,.brown] // Example colors for views
    
    private var originalCenter: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupVideoLayout(for: colors.count)
    }
    
    private func setupVideoLayout(for numberOfViews: Int) {
        // Remove existing subviews
        view.subviews.forEach { $0.removeFromSuperview() }
        
        views.removeAll() // Clear the views array
        
        switch numberOfViews {
        case 1:
            // Full-screen layout for one participant
            let videoView = createVideoView(index: 0)
            addTapGesture(to: videoView)
            view.addSubview(videoView)
            videoView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                videoView.topAnchor.constraint(equalTo: view.topAnchor),
                videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            views.append(videoView)
            
        case 2, 3, 4:
            // Grid layout for 2, 3, or 4 participants
            let mainStackView = UIStackView()
            mainStackView.axis = .vertical
            mainStackView.alignment = .fill
            mainStackView.distribution = .fillEqually
            mainStackView.spacing = 0
            
            let columns = 2
            let rows = Int(ceil(Double(numberOfViews) / Double(columns)))
            
            for rowIndex in 0..<rows {
                let rowStackView = UIStackView()
                rowStackView.axis = .horizontal
                rowStackView.alignment = .fill
                rowStackView.distribution = .fillEqually
                rowStackView.spacing = 0
                
                for columnIndex in 0..<columns {
                    let index = rowIndex * columns + columnIndex
                    if index < numberOfViews {
                        let videoView = createVideoView(index: index)
                        addTapGesture(to: videoView)
                        rowStackView.addArrangedSubview(videoView)
                        views.append(videoView) // Add view to the array
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
                mainStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: numberOfViews == 2 ? 0.5 : 0.65),
                mainStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
            ])
            
        default:
            // Layout for more than 4 views (adjust as per your need)
            let firstView = createVideoView(index: 0)
            addTapGesture(to: firstView)
            view.addSubview(firstView)
            firstView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                firstView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                firstView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                firstView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                firstView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
            ])
            views.append(firstView)
            
            // Right half layout (two-column grid for remaining views)
            let rightHalfStackView = UIStackView()
            rightHalfStackView.axis = .vertical
            rightHalfStackView.alignment = .fill
            rightHalfStackView.distribution = .fillEqually
            rightHalfStackView.spacing = 2
            
            let remainingViews = Array(1..<numberOfViews)
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
                        let videoView = createVideoView(index: index + 1)
                        addTapGesture(to: videoView)
                        rowStackView.addArrangedSubview(videoView)
                        views.append(videoView) // Add view to the array
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
                rightHalfStackView.heightAnchor.constraint(equalTo: firstView.heightAnchor, multiplier: CGFloat(0.25 * Double(rows)))
            ])
        }
    }
    private func setupReLayout(for numberOfViews: Int) {
        // Remove existing subviews from the main view
        view.subviews.forEach { $0.removeFromSuperview() }
        
        // Create new views only if needed
        while views.count < numberOfViews {
            let newView = createVideoView(index: views.count)
            addTapGesture(to: newView)
            views.append(newView)
        }
        
        switch numberOfViews {
        case 1:
            // Full-screen layout for one participant
            let videoView = views[0]
            view.addSubview(videoView)
            videoView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                videoView.topAnchor.constraint(equalTo: view.topAnchor),
                videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
        case 2, 3, 4:
            // Grid layout for 2, 3, or 4 participants
            let mainStackView = UIStackView()
            mainStackView.axis = .vertical
            mainStackView.alignment = .fill
            mainStackView.distribution = .fillEqually
            mainStackView.spacing = 0
            
            let columns = 2
            let rows = Int(ceil(Double(numberOfViews) / Double(columns)))
            
            for rowIndex in 0..<rows {
                let rowStackView = UIStackView()
                rowStackView.axis = .horizontal
                rowStackView.alignment = .fill
                rowStackView.distribution = .fillEqually
                rowStackView.spacing = 0
                
                for columnIndex in 0..<columns {
                    let index = rowIndex * columns + columnIndex
                    if index < numberOfViews {
                        let videoView = views[index]
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
                mainStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: numberOfViews == 2 ? 0.5 : 0.65),
                mainStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
            ])
            
        default:
            // Layout for more than 4 views (adjust as per your need)
            let firstView = views[0]
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
            
            let remainingViews = Array(1..<numberOfViews)
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
                        let videoView = views[index + 1]
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
                rightHalfStackView.heightAnchor.constraint(equalTo: firstView.heightAnchor, multiplier: CGFloat(0.25 * Double(rows)))
            ])
        }
        
        // Hide extra views if we have more than needed
        for i in numberOfViews..<views.count {
            views[i].removeFromSuperview()
        }
    }
    
    // Function to create a video view with a specific index
    private func createVideoView(index: Int) -> VideoPaticipentView {
        let videoView = VideoPaticipentView()
        videoView.backgroundColor = colors[index % colors.count] // Assign color based on the index
        videoView.tag = index // Assign tag to track view
        return videoView
    }
    
    // Function to add tap gesture for dragging
    private func addTapGesture(to videoView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        videoView.addGestureRecognizer(panGesture)
        videoView.isUserInteractionEnabled = true
    }
    
    @objc func handleDrag(_ gesture: UIPanGestureRecognizer) {
        guard let draggedView = gesture.view as? VideoPaticipentView else { return }
        
        switch gesture.state {
        case .began:
            originalCenter = draggedView.center // Save the original center for reference
            
        case .changed:
            let translation = gesture.translation(in: view)
            // Move the view as the user drags
            draggedView.center = CGPoint(x: draggedView.center.x + translation.x, y: draggedView.center.y + translation.y)
            gesture.setTranslation(.zero, in: view)
            
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
    
    func detectSwapTarget(for draggedView: VideoPaticipentView) -> VideoPaticipentView? {
        var closestView: VideoPaticipentView?
        var closestDistance: CGFloat = .greatestFiniteMagnitude
        
        // Get the center point of the dragged view
        let draggedCenter = draggedView.center
        let draggedViewArea = draggedView.frame.size.width * draggedView.frame.size.height
        
        // Recursively check all subviews of cameraView
        closestView = findClosestView(in: view, excluding: draggedView, draggedCenter: draggedCenter,draggedViewArea: draggedViewArea, closestDistance: &closestDistance)
        
//        // Return the closest view if it's within a reasonable distance (adjust this threshold as needed)
        if closestDistance < draggedView.frame.width {
            return closestView
        }
        return closestView
    }
    // Recursive function to traverse subviews and find the closest view
    func findClosestView(in containerView: UIView, excluding draggedView: VideoPaticipentView, draggedCenter: CGPoint,draggedViewArea: CGFloat, closestDistance: inout CGFloat) -> VideoPaticipentView? {
        var closestView: VideoPaticipentView?
        
        for subview in containerView.subviews {
            // If the subview is a stack view, traverse its arranged subviews
            if let stackView = subview as? UIStackView {
                // Recursively traverse the arrangedSubviews of the stackView
                for arrangedSubview in stackView.arrangedSubviews {
                    // Recursive check for nested stack views
                    if let nestedClosestView = findClosestView(in: arrangedSubview as! VideoPaticipentView, excluding: draggedView, draggedCenter: draggedCenter,draggedViewArea: draggedViewArea, closestDistance: &closestDistance) {
                        closestView = nestedClosestView
                    }
                }
            } else if subview != draggedView {
                // Convert the subview's frame to the coordinate space of the main view
                let convertedFrame = subview.convert(subview.bounds, to: view)
                let draggedFrame = draggedView.convert(draggedView.bounds, to: view)
                
                // Check if the frames intersect
                let intersectionFrame = draggedFrame.intersection(convertedFrame)
                if !intersectionFrame.isEmpty{
                    // Calculate the intersection area
                    let intersectionArea = intersectionFrame.size.width * intersectionFrame.size.height
                    
                    // Only consider views where more than half of the dragged view overlaps
                    if intersectionArea >= draggedViewArea / 2 {
                        // Calculate the distance between the centers of the dragged view and this subview
                        let distance = distanceBetweenPoints(draggedCenter, CGPoint(x: convertedFrame.midX, y: convertedFrame.midY))
                        
                        // Update the closest view if this subview is closer
                        if distance < closestDistance {
                            closestDistance = distance
                            closestView = subview as? VideoPaticipentView
                        }
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
    
    func swapViews(_ firstView: VideoPaticipentView, with secondView: VideoPaticipentView) {
        // Swap the views in the array
        if let firstIndex = views.firstIndex(of: firstView), let secondIndex = views.firstIndex(of: secondView) {
            let tempTag = firstView.tag
            firstView.tag = secondView.tag
            secondView.tag = tempTag
            views.swapAt(secondIndex, firstIndex)
        }
        setupReLayout(for: views.count)
        // Re-layout the views
//        setupVideoLayout(for: views.count)
    }
    
    func addDummyView() -> UIView {
        let dummyView = UIView()
        dummyView.backgroundColor = UIColor(red: 33/255, green: 23/255, blue: 42/255, alpha: 1.0)
        return dummyView
    }
}

import UIKit

class VideoPaticipentView: UIView {
    
    private let participantLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "Muhammad Nouman"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.liveMicSelectedNoBg, for: .normal)
        button.tintColor = .white.withAlphaComponent(0.75)
        button.backgroundColor = .clear // No background for the button
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.15)
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [actionButton,containerView])
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.spacing = 8 // Space between the label container and the button
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserDetailsViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUserDetailsViews()
    }
    
    private func setupUserDetailsViews() {
        // Add the stackView as a subview
        addSubview(stackView)
        
        // Add the label inside the containerView
        containerView.addSubview(participantLabel)
        
        // Set up constraints for the stackView
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20)
        ])
        
        // Set up constraints for the label inside the containerView
        NSLayoutConstraint.activate([
            participantLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            participantLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4),
            participantLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            participantLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
        
        // Set up constraints for the button (outside the containerView but part of the stackView)
//        NSLayoutConstraint.activate([
//            actionButton.widthAnchor.constraint(equalToConstant: 40),
//            actionButton.heightAnchor.constraint(equalToConstant: 40)
//        ])
    }
}
