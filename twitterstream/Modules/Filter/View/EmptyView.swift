//
//  EmptyView.swift
//  twitterstream
//
//  Created by Fernando Ferreira on 22/04/18.
//  Copyright © 2018 Fernando Ferreira. All rights reserved.
//

import UIKit

protocol EmptyViewDelegate: class {
    func emptyButtonTouched()
}

struct EmptyFiller {
    let title: String?
    let subTile: String?
    let actionName: String?
}

final class EmptyView: UIView {
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var subTitleLabel: UILabel?
    @IBOutlet private var actionButton: UIButton?

    weak var delegate: EmptyViewDelegate?

    func fillEmptyState(_ filler: EmptyFiller) {
        titleLabel?.text = filler.title
        subTitleLabel?.text = filler.subTile
        actionButton?.setTitle(filler.actionName, for: .normal)

        titleLabel?.isHidden = filler.title == nil
        subTitleLabel?.isHidden = filler.subTile == nil
        let hasAction = filler.actionName != nil
        actionButton?.isHidden = !hasAction
        actionButton?.isEnabled = hasAction
    }

    @IBAction func buttonTouched() {
        delegate?.emptyButtonTouched()
    }
}
