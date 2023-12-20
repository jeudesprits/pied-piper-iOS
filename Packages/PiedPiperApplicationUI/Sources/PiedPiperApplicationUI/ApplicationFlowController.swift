//
//  ApplicationFlowController.swift
//
//
//  Created by Ruslan Lutfullin on 25/11/23.
//

import UIKit
import PiedPiperFoundationUI
import PiedPiperMainUI

public final class ApplicationFlowController: ViewController {
    
    private lazy var mainFlowController = MainFlowController()
    
    private lazy var applicationFlowView = ApplicationFlowView(frame: .zero, mainFlow: { mainFlowController.view })
    
    public override func loadView() {
        view = applicationFlowView
    }
    
    public override func setupViewConstraints() {
        super.setupViewConstraints()
        addChild(mainFlowController)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainFlowController.didMove(toParent: self)
    }
}

fileprivate final class ApplicationFlowView: View {
    
    private let mainFlowProvider: () -> UIView
    
    var mainFlowView: UIView { mainFlowProvider() }
    
    override func setupConstraints() {
        super.setupConstraints()
        mainFlowView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainFlowView)
        NSLayoutConstraint.activate([
            mainFlowView.topAnchor.constraint(equalTo: topAnchor),
            mainFlowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: mainFlowView.trailingAnchor),
            bottomAnchor.constraint(equalTo: mainFlowView.bottomAnchor),
        ])
    }
    
    init(frame: CGRect, @_implicitSelfCapture mainFlow mainFlowProvider: @escaping () -> UIView) {
        self.mainFlowProvider = mainFlowProvider
        super.init(frame: frame)
    }
}
