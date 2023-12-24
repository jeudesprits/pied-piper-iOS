//
//  HomeViewController.swift
//
//
//  Created by Ruslan Lutfullin on 25/11/23.
//

import SwiftUtilities
import UIKit
import UIKitUtilities
import PiedPiperFoundationUI
import CoreImage
import CoreImage.CIFilterBuiltins

final class HomeViewController: ViewController {
    
    private(set) lazy var homeView = HomeView(frame: .zero)
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Смотреть"
    }
    
    @objc private func test1() {
        print(#function)
    }
    
    @objc private func test2() {
        print(#function)
    }
    
    override var prefersStatusBarHidden: Bool { true }
}

final class HomeView: View {
    
    private var categorySegmentedControl: CategorySegmentedControl = with(CategorySegmentedControl(
        frame: .zero,
        configuration: CategorySegmentedControl.Configuration(items: [
            .init(iconImage: UIImage(resource: .icons8OneRing), title: "Фильмы"),
            .init(iconImage: UIImage(resource: .icons8WalterWhite), title: "Сериалы"),
            .init(iconImage: UIImage(resource: .icons8PatrickStar), title: "Мультфильмы"),
            .init(iconImage: UIImage(resource: .icons8MyMelody), title: "Аниме"),
        ])
    )) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.state.selectedIndex = 0
    }
    
//    private var categorySegmentView: CategorySegmentView = with(CategorySegmentView(
//        frame: .zero,
//        configuration: CategorySegmentView.Configuration(iconImage: UIImage(resource: .icons8BabyYoda), title: "Сериалы")
//    )) {
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }
    
    override func setupCommon() {
        super.setupCommon()
        backgroundColor = .systemBackground
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) { [self] in
//            categorySegmentedControl.state.selectedIndex = 1
//            categorySegmentedControl.setNeedsAnimatedInputsChanges()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { [self] in
//            categorySegmentedControl.state.selectedIndex = 2
//            categorySegmentedControl.setNeedsAnimatedInputsChanges()
//        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        addSubview(categorySegmentedControl)
        //addSubview(categorySegmentView)
        NSLayoutConstraint.activate([
            categorySegmentedControl.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: categorySegmentedControl.trailingAnchor),
            categorySegmentedControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            
//            categorySegmentView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            categorySegmentView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
