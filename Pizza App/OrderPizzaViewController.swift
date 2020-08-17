//
//  OrderPizzaViewController.swift
//  Pizza App
//
//  Created by Akshansh Thakur on 02/08/20.
//  Copyright © 2020 Akshansh Thakur. All rights reserved.
//

import UIKit

class OrderPizzaViewController: UIViewController {
    
    var currentRotation = CGFloat.zero
    var currentPosition: CGFloat = 0.0
    var pizzaSize = PizzaSize.Medium
    var sizeOptions = PizzaSize.allCases
    var ingredient = Ingredients.Olives
    var ingredientsOptions = Ingredients.allCases
    
    var pizzaWidthConstraint: NSLayoutConstraint!
    
    var pizzaSizeView: BezierView = {
        let view = BezierView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var ingredientsView: BezierView = {
        let view = BezierView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var pizza: UIImageView = {
        let pizza = UIImageView()
        pizza.translatesAutoresizingMaskIntoConstraints = false
        pizza.image = UIImage(named: "pizzaCircle")
        return pizza
    }()
    
    var sliderThumb: UIImageView = {
        let pizza = UIImageView()
        pizza.translatesAutoresizingMaskIntoConstraints = false
        pizza.image = UIImage(named: "sliderThumb")
        return pizza
    }()
    
    var ingredientQuantitySlider: BezierView = {
        let slider = BezierView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    var addPizzaButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .softRed
        button.layer.cornerRadius = 25.0
        button.tintColor = .white
        button.setImage(UIImage.init(systemName: "plus"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPizza()
        setupPizzaSizeArc()
        setupIngredientsArc()
        
        UIView.animate(withDuration: 0.0, animations: {
            self.view.layoutIfNeeded()
        }) { (value) in
            self.pizzaSizeView.setup()
            self.pizzaSizeView.getRedArcLayer()
            
            self.ingredientsView.setup()
            
            self.setupHierarchy()
        }
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(slidePanGesture))
        sliderThumb.isUserInteractionEnabled = true
        sliderThumb.addGestureRecognizer(panGestureRecognizer)
        
        addPizzaButton.addTarget(self, action: #selector(pizzaButtonClicked(_:)), for: .touchUpInside)
    }
    
    @objc func pizzaButtonClicked(_ sender: UIButton) {
        
        pizzaWidthConstraint.constant = 140.0
        addPizzaButton.setImage(nil, for: .normal)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { (value) in
            self.addPizzaButton.setTitle("Continue", for: .normal)
        }
        
    }
    
    @objc func slidePanGesture(gesture: UIPanGestureRecognizer) {
        
        let translationX = gesture.translation(in: sliderThumb).x
        
        let nextXPosition = translationX + self.currentPosition
        
        let offset = CGFloat(8)
        
        let threshHold = offset...(ingredientQuantitySlider.frame.width - offset)
        
        switch gesture.state {
            
        case .began:
            
            if threshHold.contains(nextXPosition) {
                ingredientQuantitySlider.updatePath(x: nextXPosition, y: 0.0)
                UIView.animate(withDuration: 0.2, animations: {
                    self.sliderThumb.center.x = nextXPosition
                }) { (value) in
                    self.view.layoutIfNeeded()
                }
            }
            
        case .changed:
            
            if threshHold.contains(nextXPosition) {
                ingredientQuantitySlider.updatePath(x: nextXPosition, y: 0.0)
                UIView.animate(withDuration: 0.2, animations: {
                    self.sliderThumb.center.x = nextXPosition
                }) { (value) in
                    self.view.layoutIfNeeded()
                }
            }
            
        case .ended:
            
            if nextXPosition < offset {
                currentPosition = offset
                UIView.animate(withDuration: 0.2, animations: {
                    self.sliderThumb.center.x = self.currentPosition
                    self.ingredientQuantitySlider.updatePath(x: self.currentPosition, y: 0.0)
                }) { (value) in
                    self.view.layoutIfNeeded()
                }
            } else if nextXPosition > ingredientQuantitySlider.frame.width - offset {
                currentPosition = ingredientQuantitySlider.frame.width - offset
                UIView.animate(withDuration: 0.2, animations: {
                    self.sliderThumb.center.x = self.currentPosition
                    self.ingredientQuantitySlider.updatePath(x: self.currentPosition, y: 0.0)
                }) { (value) in
                    self.view.layoutIfNeeded()
                }
            } else {
                currentPosition += translationX
                UIView.animate(withDuration: 0.2, animations: {
                    self.sliderThumb.center.x = self.currentPosition
                    self.ingredientQuantitySlider.updatePath(x: self.currentPosition, y: 0.0)
                }) { (value) in
                    self.view.layoutIfNeeded()
                }
            }
            
        default:
            break
        }
        
    }
    
    func addPizza() {
        
        view.addSubview(pizza)
        
        pizza.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pizza.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(view.bounds.height / 4.0) - 50.0).isActive = true
        pizza.widthAnchor.constraint(equalToConstant: view.bounds.height / 5.0).isActive = true
        pizza.heightAnchor.constraint(equalToConstant: view.bounds.height / 5.0).isActive = true
        
    }
    
    func setupHierarchy() {
        addSizeOptions()
        addIngredientOptions()
    }
    
    func addSizeOptions() {
        let sizeQueue = SizeQueue()
        
        sizeQueue.currentData = sizeOptions.map({$0.rawValue})
        sizeQueue.queueCapacity = sizeOptions.count
        sizeQueue.delegate = self
        sizeQueue.translatesAutoresizingMaskIntoConstraints = false
        
        pizzaSizeView.addSubview(sizeQueue)
        
        pizzaSizeView.addConstraintsWithFormat(format: "H:|[v0]|", views: sizeQueue)
        pizzaSizeView.addConstraintsWithFormat(format: "V:|[v0]|", views: sizeQueue)
        
        sizeOptions.forEach {
            sizeQueue.addViewInArrangement(view: getButtonWith(title: $0.rawValue, titleColor: .clear))
        }
    }
    
    func addIngredientOptions() {
        let ingredientsQueue = IngredientQueue()
        
        ingredientsQueue.currentData = ingredientsOptions
        
        ingredientsQueue.queueCapacity = ingredientsOptions.count
        ingredientsQueue.delegate = self
        ingredientsQueue.translatesAutoresizingMaskIntoConstraints = false
        
        ingredientsView.addSubview(ingredientsQueue)
        ingredientsView.addSubview(ingredientQuantitySlider)
        ingredientsView.addSubview(addPizzaButton)
        ingredientsView.addConstraintsWithFormat(format: "H:|[v0]|", views: ingredientsQueue)
        ingredientsView.addConstraintsWithFormat(format: "H:|-48-[v0]-48-|", views: ingredientQuantitySlider)
        ingredientsView.addConstraintsWithFormat(format: "V:|-12-[v0(70)]-32-[v1(32)]-32-[v2(50)]", views:
            ingredientsQueue, ingredientQuantitySlider, addPizzaButton)
        addPizzaButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
            
            
            pizzaWidthConstraint = addPizzaButton.widthAnchor.constraint(equalToConstant: 50.0)
        
        pizzaWidthConstraint.isActive = true
        
        
        ingredientsOptions.forEach {
            ingredientsQueue.addViewInArrangement(view: getButtonWith(image: $0.rawValue))
        }
        
        UIView.animate(withDuration: 0.0, animations: {
            self.view.layoutIfNeeded()
        }) { (value) in
            self.ingredientQuantitySlider.addSliderArcLayer()
            self.setupSliderThumb()
        }
        
    }
    
    func setupSliderThumb() {
        
        self.ingredientQuantitySlider.addSubview(sliderThumb)
        
        let bottomOffset: CGFloat = 8.0
        let radius: CGFloat = 10.0
        
        var arcDelta: CGFloat {
            return CGFloat(
                (
                    (sqrt(2 * (bottomOffset * bottomOffset)) + radius)
                        /
                        sqrt(2.0))
                    - bottomOffset
            )
        }
        
        sliderThumb.centerXAnchor.constraint(
            equalTo: ingredientQuantitySlider.leadingAnchor, constant: bottomOffset + arcDelta
        ).isActive = true
        
        sliderThumb.centerYAnchor.constraint(
            equalTo: ingredientQuantitySlider.centerYAnchor, constant: -7.0
        ).isActive = true
        
        sliderThumb.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        sliderThumb.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
    }
    
    fileprivate func setupPizzaSizeArc() {
        view.addSubview(pizzaSizeView)
        
        pizzaSizeView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(view.bounds.height / 4.0) + (view.bounds.height / 5.0)).isActive = true
        pizzaSizeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pizzaSizeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        pizzaSizeView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    fileprivate func setupIngredientsArc() {
        view.addSubview(ingredientsView)
        
        ingredientsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        ingredientsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        ingredientsView.topAnchor.constraint(equalTo: pizzaSizeView.bottomAnchor).isActive = true
        
        ingredientsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func getButtonWith(title: String, titleColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        return button
    }
    
    func getButtonWith(image: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: image), for: .normal)
        return button
    }
    
}

extension OrderPizzaViewController: SizeSelectionDelegate {
    
    func didSelectSize(_ text: String) {
        
        var transform = CGAffineTransform()
        currentRotation += CGFloat.pi * 0.99
        
        switch text {
        case PizzaSize.Large.rawValue:
            transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            transform = transform.concatenating(
                CGAffineTransform.init(rotationAngle: currentRotation)
            )
        case PizzaSize.Medium.rawValue:
            transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            transform = transform.concatenating(
                CGAffineTransform.init(rotationAngle: currentRotation)
            )
        case PizzaSize.Small.rawValue:
            transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            transform = transform.concatenating(
                CGAffineTransform.init(rotationAngle: currentRotation)
            )
        default:
            pizza.transform = .identity
        }
        
        UIView.animate(withDuration: 0.5) {
            self.pizza.transform = transform
        }
    }
    
}

extension OrderPizzaViewController: IngredientSelectionDelegate {
    
    func didSelectIngredient(_ image: String) {
        
        currentPosition = 0.0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.sliderThumb.center.x = 8.0
        }) { (value) in
            self.view.layoutIfNeeded()
        }
        
        ingredientQuantitySlider.resetPath()
    }
    
}

