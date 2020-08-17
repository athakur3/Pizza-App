//
//  SizeQueue.swift
//  Pizza App
//
//  Created by Akshansh Thakur on 03/08/20.
//  Copyright © 2020 Akshansh Thakur. All rights reserved.
//

import Foundation
import UIKit

protocol SizeSelectionDelegate: class {
    func didSelectSize(_ text: String)
}

enum PizzaSize: String, CaseIterable {
    case Small = "Small"
    case Medium = "Medium"
    case Large = "Large"
}

class SizeQueue: QueueView {
    
    weak var delegate: SizeSelectionDelegate?
    
    var currentData = [String]()
    
    override func dropLow(view: UIView) {
        super.dropLow(view: view)
        guard let button = view as? UIButton else {return}
        
        button.titleEdgeInsets.bottom = -4.0
        button.titleEdgeInsets.top = 4.0
    }
    
    override func riseUp(view: UIView) {
        super.riseUp(view: view)
        guard let button = view as? UIButton else {return}
        
        button.titleEdgeInsets.top = -4.0
        button.titleEdgeInsets.bottom = 4.0
    }
    
    override func normalizeAllViews() {
        super.normalizeAllViews()
        animatableStack.arrangedSubviews.forEach { (view) in
            (view as? UIButton)?.setTitleColor(.darkGray, for: .normal)
        }
    }
    
    override func selectView() {
        super.selectView()
        (animatableStack.arrangedSubviews[2] as! UIButton).setTitleColor(UIColor.softRed, for: .normal)
    }
    
    override func configureNewView(view: UIView) {
        super.configureNewView(view: view)
        
        guard let button = view as? UIButton else {return}
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        button.setTitleColor(.darkGray, for: .normal)
        button.addTarget(self, action: #selector(SizeQueue.queueViewAction(_:)), for: .touchUpInside)
        
    }
    
    override func makeArrangements() {
        super.makeArrangements()
        
        configureNewView(view: leftHiddenView)
        leftHiddenView.setTitle(currentData[2], for: .normal)
        
        configureNewView(view: rightHiddenView)
        rightHiddenView.setTitle(currentData[0], for: .normal)
        
        animatableStack.addArrangedSubview(rightHiddenView)
        rightHiddenView.isHidden = true
        
        animatableStack.insertArrangedSubview(leftHiddenView, at: 0)
        leftHiddenView.isHidden = true
        
        animatableStack.arrangedSubviews.forEach { (view) in
            dropLow(view: view as! UIButton)
        }
        
        setInitialState()
        
    }
    
    override func setInitialState() {
        super.setInitialState()
        let centerButton = animatableStack.arrangedSubviews[2] as! UIButton
        centerButton.setTitleColor(UIColor.softRed, for: .normal)
    }
    
    @objc func queueViewAction(_ sender: UIButton) {
        
        delegate?.didSelectSize((sender.titleLabel?.text)!)
        
        animatableStack.arrangedSubviews.forEach { (view) in
            if view == sender {
                riseUp(view: sender)
            } else {
                dropLow(view: view as! UIButton)
            }
        }
        
        if sender == animatableStack.arrangedSubviews[3] {
            
            let viewToRemove = animatableStack.arrangedSubviews[1] as! UIButton
            
            animatableStack.removeArrangedSubview(viewToRemove)
            viewToRemove.removeFromSuperview()
            self.rightHiddenView.isHidden = false
            
            UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.layoutIfNeeded()
            }) { (value) in
                self.currentData.append(self.currentData.remove(at: 0))
                self.rightHiddenView = viewToRemove
                self.normalizeAllViews()
                self.selectView()
                self.makeArrangements()
            }
            
        } else if sender == animatableStack.arrangedSubviews[1] {
            
            let viewToRemove = animatableStack.arrangedSubviews[3] as! UIButton
            
            animatableStack.removeArrangedSubview(viewToRemove)
            viewToRemove.removeFromSuperview()
            self.leftHiddenView.isHidden = false
            
            UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.layoutIfNeeded()
            }) { (value) in
                self.currentData.insert(
                    self.currentData.remove(
                        at: self.currentData.count - 1
                    ), at: 0
                )
                self.leftHiddenView = viewToRemove
                self.normalizeAllViews()
                self.makeArrangements()
                self.selectView()
            }
            
        }
        
    }
    
}

extension UIColor {
    static let softRed = UIColor(red: 201.0/255.0, green: 46.0/255.0, blue: 25.0/255.0, alpha: 1.0)
}
