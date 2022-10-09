//
//  SelectionsGalleryCell.swift
//  YPImagePicker
//
//  Created by Nik Kov || nik-kov.com on 09.04.18.
//  Copyright © 2018 Yummypets. All rights reserved.
//

import UIKit
import Stevia

public protocol YPSelectionsGalleryCellDelegate: NSObject {
    func selectionsGalleryCellDidTapRemove(cell: YPSelectionsGalleryCell)
    func selectionsGalleryCellDidTapEdit(cell: YPSelectionsGalleryCell)
    func selectionsGalleryCellDidTapAdd()
}

public class YPSelectionsGalleryCell: UICollectionViewCell {
    
    weak var delegate: YPSelectionsGalleryCellDelegate?
    let imageView = UIImageView()
    let editButton = UIButton()
    let removeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        sv(
            imageView,
            editButton,
            removeButton
        )
        editButton.backgroundColor = UIColor.white
        imageView.fillContainer()
        editButton.size(32).left(12).bottom(12)
                
        removeButton.top(12).trailing(12)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 4, height: 7)
        layer.shadowRadius = 5
        layer.backgroundColor = UIColor.clear.cgColor
        imageView.style { i in
            i.clipsToBounds = true
            i.contentMode = .scaleAspectFill
        }
        editButton.style { v in
            v.backgroundColor = UIColor.ypSystemBackground
            v.layer.cornerRadius = 16
            v.layer.borderWidth = 1
            v.layer.borderColor = UIColor.ypLabel.cgColor
        }
        editButton.tintColor = UIColor.ypLabel
        editButton.setImage(YPConfig.icons.editImage, for: .normal)
        
        removeButton.setImage(YPConfig.icons.removeImage, for: .normal)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func removeButtonTapped() {
        delegate?.selectionsGalleryCellDidTapRemove(cell: self)
    }
    
    @objc
    func editButtonTapped() {
        delegate?.selectionsGalleryCellDidTapEdit(cell: self)
    }
    
    func setEditable(_ editable: Bool) {
        self.editButton.isHidden = !editable
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            if self.isHighlighted {
                                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                                self.alpha = 0.8
                            } else {
                                self.transform = .identity
                                self.alpha = 1
                            }
            }, completion: nil)
        }
    }
}

public class AddSelectionsGalleryCell: UICollectionViewCell {
    
    weak var delegate: YPSelectionsGalleryCellDelegate?
    let addButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        sv(
            addButton
        )

        contentView.addSubview(addButton)
        contentView.backgroundColor = .clear
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        addButton.setImage(YPConfig.icons.addButtonImage, for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
        
    @objc
    func addButtonTapped() {
        delegate?.selectionsGalleryCellDidTapAdd()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            if self.isHighlighted {
                                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                                self.alpha = 0.8
                            } else {
                                self.transform = .identity
                                self.alpha = 1
                            }
            }, completion: nil)
        }
    }
}

