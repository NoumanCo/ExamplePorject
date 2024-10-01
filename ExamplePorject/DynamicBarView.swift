import UIKit

class DynamicBarView: UIView {

    // Red and blue views representing the values
    private let redView = UIView()
    private let blueView = UIView()

    // For holding the boxing icon
    private let iconImageView = UIImageView(image: .pkIcon)

    // Labels to show the red and blue values
    private let redValueLabel = UILabel()
    private let blueValueLabel = UILabel()

    // Width constraints for red and blue views
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

        // Configure the labels
        redValueLabel.textColor = .white
        redValueLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        redValueLabel.textAlignment = .left
        blueValueLabel.textColor = .white
        blueValueLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        blueValueLabel.textAlignment = .right

        // Add subviews
        addSubview(redView)
        addSubview(blueView)
        addSubview(iconImageView)
        addSubview(redValueLabel)
        addSubview(blueValueLabel)

        // Set up constraints for red and blue views
        redView.translatesAutoresizingMaskIntoConstraints = false
        blueView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        redValueLabel.translatesAutoresizingMaskIntoConstraints = false
        blueValueLabel.translatesAutoresizingMaskIntoConstraints = false

        // Initialize width constraints
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
            iconImageView.widthAnchor.constraint(equalToConstant: 33), // Adjust as needed
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])

        // Add the icon's center X constraint relative to redView's trailing edge
        iconCenterXConstraint = iconImageView.centerXAnchor.constraint(equalTo: redView.trailingAnchor)
        iconCenterXConstraint.isActive = true

        // Set up constraints for the labels
        NSLayoutConstraint.activate([
            redValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            redValueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            blueValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            blueValueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // Method to update the bar dynamically with animation, including the icon's position and label values
    func updateBar(redValue: CGFloat, blueValue: CGFloat, totalValue: CGFloat) {
        let redRatio = redValue / totalValue
        let blueRatio = blueValue / totalValue

        // Update the labels' text
        redValueLabel.text = "\(Int(redValue).formatNumber())"
        blueValueLabel.text = "\(Int(blueValue).formatNumber())"

        // Total width of the bar
        let totalWidth = self.frame.width

        // Update constraints with animation
        UIView.animate(withDuration: firstTime ? 0 : 1.0) {
            self.firstTime = false
            // Update the width constraints
            self.redViewWidthConstraint.constant = totalWidth * redRatio
            self.blueViewWidthConstraint.constant = totalWidth * blueRatio

            // Update the red label to ensure it doesn't overlap with the red view
            let redLabelMaxX = self.redValueLabel.frame.maxX
            let redViewMaxX = self.redView.frame.maxX

            if redLabelMaxX >= redViewMaxX - 10 {
                self.redValueLabel.frame.origin.x = self.redView.frame.minX + 20
            }

            // Update the blue label to ensure it doesn't overlap with the blue view
            let blueLabelMinX = self.blueValueLabel.frame.minX
            let blueViewMinX = self.blueView.frame.minX

            if blueLabelMinX <= blueViewMinX + 10 {
                self.blueValueLabel.frame.origin.x = self.blueView.frame.maxX - self.blueValueLabel.frame.width - 20
            }

            // Recalculate layout
            self.layoutIfNeeded()
        }
    }
}
extension Int {
    func formatNumber() -> String {
        switch self {
        case let n where n >= 1_000_000_000_000:
            // Trillions (T)
            let formatted = Double(n) / 1_000_000_000_000
            return String(format: "%.1fT", formatted)
        case let n where n >= 1_000_000_000:
            // Billions (B)
            let formatted = Double(n) / 1_000_000_000
            return String(format: "%.1fB", formatted)
        case let n where n >= 1_000_000:
            // Millions (M)
            let formatted = Double(n) / 1_000_000
            return String(format: "%.1fM", formatted)
        case let n where n >= 1_000:
            // Thousands (K)
            let formatted = Double(n) / 1_000
            return String(format: "%.1fK", formatted)
        default:
            // Less than 1,000
            return "\(self)"
        }
    }
}
