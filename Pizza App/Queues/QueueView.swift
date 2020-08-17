//
//  QueueView.swift
//  Pizza App
//
//  Created by Akshansh Thakur on 02/08/20.
//  Copyright © 2020 Akshansh Thakur. All rights reserved.
//

import Foundation
import UIKit

class QueueView: UIView {
    
    var queueCapacity = 3
    var numberOfSubviews = 0
    
    var leftHiddenView = UIButton()
    var rightHiddenView = UIButton()
    
    var animatableStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 0.0
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHierarchy() {
        
        addSubview(animatableStack)
        addConstraintsWithFormat(format: "H:|[v0]|", views: animatableStack)
        addConstraintsWithFormat(format: "V:|[v0]|", views: animatableStack)
        
    }
    
    func addViewInArrangement(view: UIView) {
        
        guard let button = view as? UIButton else {return}
        
        if numberOfSubviews == queueCapacity {
            print("Cannot Add View. Capacity is full")
        } else {
            animatableStack.addArrangedSubview(view)
            configureNewView(view: button)
            view.tag = 1000 + numberOfSubviews
            numberOfSubviews += 1
        }
        
        if numberOfSubviews == queueCapacity {
            makeArrangements()
        }
    }
    
    func makeArrangements() {}
    
    func setInitialState() {
        let centerButton = animatableStack.arrangedSubviews[2] as! UIButton
        riseUp(view: centerButton)
    }
    
    func configureNewView(view: UIView) {}
    
    func normalizeAllViews() {}
    
    func selectView() {}
    
    func dropLow(view: UIView) {
        
        guard let button = view as? UIButton else {return}
        
        button.contentEdgeInsets.bottom = -4.0
        button.contentEdgeInsets.top = 4.0
    }
    
    func riseUp(view: UIView) {
        guard let button = view as? UIButton else {return}
        
        button.contentEdgeInsets.top = -4.0
        button.contentEdgeInsets.bottom = 4.0
    }
    
}
