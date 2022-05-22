//
//  ImageCollectionViewCell.swift
//  DromTestApp
//
//  Created by Владимир on 21.05.2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView?
    var onReuse: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .lightGray
        
        let view: UIImageView = .init()
        imageView = view
        view.clipsToBounds = true
        contentView.addSubview(view)
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        onReuse?()
    }
}
