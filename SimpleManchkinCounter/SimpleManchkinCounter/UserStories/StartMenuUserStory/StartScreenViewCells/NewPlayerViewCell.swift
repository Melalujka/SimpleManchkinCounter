//
//  NewPlayerViewCell.swift
//  SimpleManchkinCounter
//
//  Created by Antonov, Pavel on 4/21/18.
//  Copyright © 2018 paul. All rights reserved.
//

import UIKit

class NewPlayerViewCell: UITableViewCell, ConfigurableCell {


    @IBOutlet weak var frameBackgroundView: UIView!
    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet weak var label: UILabel!
    static var height: CGFloat = 40

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        frameBackgroundView.layer.cornerRadius = 8
        topBackgroundView.layer.cornerRadius = 8
//        frameBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
//        frameBackgroundView.layer.shadowRadius = 3
//        frameBackgroundView.layer.shadowOpacity = 0.3
//        frameBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: frameBackgroundView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
//        frameBackgroundView.layer.shouldRasterize = true
//        frameBackgroundView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func configure(with viewModel: CellViewModel) {
        
        if let viewModel = viewModel as? NewPlayerCellViewModel {
            label.text = viewModel.title
            frameBackgroundView.backgroundColor = UIColor(red: 74/256, green: 74/256, blue: 74/256, alpha: 1)//viewModel.frameBackgroundViewColor
            topBackgroundView.backgroundColor = viewModel.topBackgroundViewColor
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
