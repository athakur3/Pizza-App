//
//  IngredientQueue.swift
//  Pizza App
//
//  Created by Akshansh Thakur on 03/08/20.
//  Copyright © 2020 Akshansh Thakur. All rights reserved.
//

import Foundation
import UIKit

protocol IngredientSelectionDelegate: class {
    func didSelectIngredient(_ image: String)
}

enum Ingredients: String, CaseIterable {
    case Olives = "Olives"
    case Onions = "Onions"
    case Mushrooms = "Mushrooms"
}

class IngredientQueue: QueueView {
    
    weak var delegate: IngredientSelectionDelegate?
    
    var currentData = [Ingredients]()
    
    override func dropLow(view: UIView) {
        super.dropLow(view: view)
        guard let button = view as? UIButton else {return}
        
        button.imageEdgeInsets.bottom = -4.0
        button.imageEdgeInsets.top = 4.0
    }
    
    override func riseUp(view: UIView) {
        super.riseUp(view: view)
        guard let button = view as? UIButton else {return}
        
        button.imageEdgeInsets.top = -4.0
        button.imageEdgeInsets.bottom = 4.0
    }
    
    override func addViewInArrangement(view: UIView) {
        super.addViewInArrangement(view: view)
        let viewTag = view.tag - 1000
        let ingredient = Ingredients.allCases[viewTag].rawValue
        view.accessibilityIdentifier = ingredient
    }
    
    override func configureNewView(view: UIView) {
        
        guard let button = view as? UIButton else {return}
        button.addTarget(self, action: #selector(IngredientQueue.queueViewAction(_:)), for: .touchUpInside)
        
    }
    
    override func makeArrangements() {
        super.makeArrangements()
        
        configureNewView(view: leftHiddenView)
        leftHiddenView.setImage(UIImage(named: currentData[2].rawValue), for: .normal)
        leftHiddenView.accessibilityIdentifier = currentData[2].rawValue
        
        configureNewView(view: rightHiddenView)
        rightHiddenView.setImage(UIImage(named: currentData[0].rawValue), for: .normal)
        rightHiddenView.accessibilityIdentifier = currentData[0].rawValue
        
        animatableStack.addArrangedSubview(rightHiddenView)
        rightHiddenView.isHidden = true
        
        animatableStack.insertArrangedSubview(leftHiddenView, at: 0)
        leftHiddenView.isHidden = true
        
        animatableStack.arrangedSubviews.forEach { (view) in
            dropLow(view: view as! UIButton)
        }
        
        setInitialState()
        
    }
    
    @objc func queueViewAction(_ sender: UIButton) {
        
        delegate?.didSelectIngredient(sender.accessibilityIdentifier ?? "")
        
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
                self.selectView()
                self.makeArrangements()
            }
            
        }
        
        
    }
    
}
