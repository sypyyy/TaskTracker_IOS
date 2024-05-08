
import UIKit
import SwiftUI

final class SideMenuItemCell: UITableViewCell {
    weak var delegate: SideMenuViewController?
    var nodeId: String?
    var indentLevel: Int = 0
    
    let LEADING_PADDING: CGFloat = 22
    let ICON_SIZE: CGFloat = 20
    let EXPAND_ARROW_HEIGHT: CGFloat = 20
    let EXPAND_ARROW_WIDTH: CGFloat = 20 / 1.2
    let INDENT_PADDING: CGFloat = 6
    
    static let LABEL_FONT = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let LABEL_TEXT_COLOR = UIColor(Color.primary.opacity(0.7))
    
    static var identifier: String {
        String(describing: self)
    }

    private var itemIcon: UIImageView?
    
    private var labelLeadingPadding: CGFloat {
        get {
            (itemIcon == nil ? LEADING_PADDING : (LEADING_PADDING + ICON_SIZE + 8)) + (CGFloat(indentLevel) * INDENT_PADDING)
        }
    }
    
    private var labelTrailingPadding: CGFloat {
        get {
            isExpandable ? (LEADING_PADDING + EXPAND_ARROW_HEIGHT) : LEADING_PADDING
        }
    }
    
    private var expandArrow = ExpandArrowView()
    private var isExpandable: Bool = false

    private var itemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = LABEL_FONT
        label.textColor = LABEL_TEXT_COLOR
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: SideMenuItemCell.identifier)
        configureView()
        configureGestures()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configureView() {
        contentView.backgroundColor = .clear
        setupExpandArrow()
        if let icon = itemIcon {
            contentView.addSubview(icon)
        }
        contentView.addSubview(itemLabel)
        
        func setupExpandArrow() {
            contentView.addSubview(expandArrow)
            expandArrow.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configureGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        contentView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapCell() {
        delegate?.didTapRow(nodeId: nodeId ?? "")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureConstraints()
    }
    
    var labelLeadingConstraint: NSLayoutConstraint?
    
    var labelTrailingConstraint: NSLayoutConstraint?

    private func configureConstraints() {
        
        itemIcon?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        itemIcon?.widthAnchor.constraint(equalToConstant: ICON_SIZE).isActive = true
        itemIcon?.heightAnchor.constraint(equalToConstant: ICON_SIZE).isActive = true
        itemIcon?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LEADING_PADDING).isActive = true
        itemLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        labelLeadingConstraint = itemLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: labelLeadingPadding)
        labelLeadingConstraint?.isActive = true
        
        if isExpandable {
            expandArrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LEADING_PADDING).isActive = true
            expandArrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            expandArrow.heightAnchor.constraint(equalToConstant: EXPAND_ARROW_HEIGHT).isActive = true
            expandArrow.widthAnchor.constraint(equalToConstant: EXPAND_ARROW_WIDTH).isActive = true
        }
        labelTrailingConstraint = itemLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: labelTrailingPadding)
    }

    func configureCell(icon: UIImage?, text: String, isExpandable: Bool, isExpanded: Bool, delegate: SideMenuViewController, nodeId: String, indentLevel: Int) {
        self.delegate = delegate
        self.nodeId = nodeId
        self.indentLevel = indentLevel
        expandArrow.delegate = delegate
        expandArrow.nodeId = nodeId
        expandArrow.isHidden = !isExpandable
        self.isExpandable = isExpandable
        if let icon = icon {
            itemIcon = UIImageView(image: icon)
            itemIcon?.translatesAutoresizingMaskIntoConstraints = false
        }
        itemLabel.text = text
        backgroundColor = .clear
        updateLabelConstraints()
    }
    
    private func updateLabelConstraints() {
        labelLeadingConstraint?.constant = labelLeadingPadding
        labelTrailingConstraint?.constant = labelTrailingPadding
        setNeedsLayout()
    }
}

extension SideMenuItemCell {
    func highlight() {
        UIView.animate(withDuration: 0.3) {
            self.contentView.backgroundColor = UIColor(Color.primary.opacity(0.1))
        }
    }
    
    func unHighlight() {
        UIView.animate(withDuration: 0.3) {
            self.contentView.backgroundColor = .clear
        }
    }
}

class ExpandArrowView: UIView {
    weak var delegate: SideMenuViewController?
    var nodeId: String?
    private var expandArrow: UIImageView = UIImageView(image: UIImage(systemName: "chevron.down"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupExpandArrow()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapExpandArrow)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupExpandArrow() {
        addSubview(expandArrow)
        expandArrow.translatesAutoresizingMaskIntoConstraints = false
        expandArrow.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        expandArrow.tintColor = .gray.withAlphaComponent(0.4)
        expandArrow.preferredSymbolConfiguration = .init(pointSize: 16, weight: .regular)
    }
    
    @objc private func didTapExpandArrow() {
        self.delegate?.expandOrCollapseFolder(nodeId: nodeId ?? "")
        setNeedsLayout()
    }
}
