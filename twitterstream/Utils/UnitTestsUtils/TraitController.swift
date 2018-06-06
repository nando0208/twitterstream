//
//  TraitController.swift
//  twitterstream
//
//  Created by Fernando Ferreira on 23/04/18.
//  Copyright © 2018 Fernando Ferreira. All rights reserved.
//

// Reference from: https://github.com/kickstarter/ios-oss/blob/master/Kickstarter-iOS/TestHelpers/TraitController.swift

import UIKit

internal enum Device {
    case phone4inch
    case phone47inch
    case phone55inch
    case phone58inch
    case pad
}

internal enum Orientation {
    case portrait
    case landscape
}

//swiftlint:disable:next cyclomatic_complexity function_body_length
internal func traitControllers(device: Device = .phone47inch,
                               orientation: Orientation = .portrait,
                               child: UIViewController = UIViewController(),
                               additionalTraits: UITraitCollection = .init(),
                               handleAppearanceTransition: Bool = true)
    -> (parent: UIViewController, child: UIViewController) {

        let parent = UIViewController()
        parent.addChildViewController(child)
        parent.view.addSubview(child.view)

        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let traits: UITraitCollection
        switch (device, orientation) {
        case (.phone4inch, .portrait):
            parent.view.frame = .init(x: 0, y: 0, width: 320, height: 568)
            traits = .init(traitsFrom: [
                .init(horizontalSizeClass: .compact),
                .init(verticalSizeClass: .regular),
                .init(userInterfaceIdiom: .phone)
                ])
        case (.phone4inch, .landscape):
            parent.view.frame = .init(x: 0, y: 0, width: 568, height: 320)
            traits = .init(traitsFrom: [
                .init(horizontalSizeClass: .compact),
                .init(verticalSizeClass: .compact),
                .init(userInterfaceIdiom: .phone)
                ])
        case (.phone47inch, .portrait):
            parent.view.frame = .init(x: 0, y: 0, width: 375, height: 667)
            traits = .init(traitsFrom: [
                .init(horizontalSizeClass: .compact),
                .init(verticalSizeClass: .regular),
                .init(userInterfaceIdiom: .phone)
                ])
        case (.phone47inch, .landscape):
            parent.view.frame = .init(x: 0, y: 0, width: 667, height: 375)
            traits = .init(traitsFrom: [
                .init(horizontalSizeClass: .compact),
                .init(verticalSizeClass: .compact),
                .init(userInterfaceIdiom: .phone)
                ])
        case (.phone55inch, .portrait):
            parent.view.frame = .init(x: 0, y: 0, width: 414, height: 736)
            traits = .init(traitsFrom: [
                .init(horizontalSizeClass: .compact),
                .init(verticalSizeClass: .regular),
                .init(userInterfaceIdiom: .phone)
                ])
        case (.phone55inch, .landscape):
            parent.view.frame = .init(x: 0, y: 0, width: 736, height: 414)
            traits = .init(traitsFrom: [
                .init(horizontalSizeClass: .regular),
                .init(verticalSizeClass: .compact),
                .init(userInterfaceIdiom: .phone)
                ])
        case (.phone58inch, .portrait):
            parent.view.frame = .init(x: 0, y: 0, width: 375, height: 812)
            traits = .init(traitsFrom: [
                .init(horizontalSizeClass: .compact),
                .init(verticalSizeClass: .regular),
                .init(userInterfaceIdiom: .phone)
                ])
        case (.phone58inch, .landscape):
            parent.view.frame = .init(x: 0, y: 0, width: 812, height: 375)
            traits = .init(traitsFrom: [
                .init(horizontalSizeClass: .compact),
                .init(verticalSizeClass: .compact),
                .init(userInterfaceIdiom: .phone)
                ])
        case (.pad, .portrait):
            parent.view.frame = .init(x: 0, y: 0, width: 768, height: 1024)
            traits = .init(traitsFrom: [
                .init(horizontalSizeClass: .regular),
                .init(verticalSizeClass: .regular),
                .init(userInterfaceIdiom: .pad)
                ])
        case (.pad, .landscape):
            parent.view.frame = .init(x: 0, y: 0, width: 1024, height: 768)
            traits = .init(traitsFrom: [
                .init(horizontalSizeClass: .regular),
                .init(verticalSizeClass: .regular),
                .init(userInterfaceIdiom: .pad)
                ])
        }

        child.view.frame = parent.view.frame

        parent.view.backgroundColor = .white
        child.view.backgroundColor = .white

        let allTraits = UITraitCollection.init(traitsFrom: [traits, additionalTraits])
        parent.setOverrideTraitCollection(allTraits, forChildViewController: child)

        if handleAppearanceTransition {
            parent.beginAppearanceTransition(true, animated: false)
            parent.endAppearanceTransition()
        }

        return (parent, child)
}
