//
//  ViewController.swift
//  Kit02
//
//  Created by msklv on 6.04.24.
//

import UIKit

class ViewController: UIViewController {
    
    let button1 = CustomButton(title: "Hello world!")
    let button2 = CustomButton(title: "Hello world!@#$%^")
    let button3 = CustomButton(title: "Hello")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.presentationController?.delegate = self
        
        button3.addTarget(self, action: #selector(showModal), for: .touchUpInside)
        
        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        button3.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        
        NSLayoutConstraint.activate([
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 20),
            
            button3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 20),
        ])
    }
    
    @objc func showModal() {
        let modalVC = ModalViewController()
        modalVC.presentationController?.delegate = self
        present(modalVC, animated: true, completion: nil)
        button1.setColorsForModalPresentation()
        button2.setColorsForModalPresentation()
        button3.setColorsForModalPresentation()
    }
    
    func handleModalDismissal() {
        print("Modal dismissed")
        self.button1.setupBtn(title: "Hello world!")
        self.button2.setupBtn(title: "Hello world!@#$%^")
        self.button3.setupBtn(title: "Hello")
    }
}

class CustomButton: UIButton {
    
    private var isAnimating: Bool = false
    var image = UIImage(systemName: "arrow.right.circle")
    var restoreOriginalColors: (() -> Void)?
    
    init(title: String) {
        super.init(frame: .zero)
        setupBtn(title: title)
    }
    
    func setupBtn(title: String) {
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        setTitleColor(.label, for: .normal)
        backgroundColor = .systemBlue
        layer.cornerRadius = 8
        tintColor = .white
        semanticContentAttribute = .forceRightToLeft
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
        setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        setImage(image?.withRenderingMode(.alwaysOriginal), for: .highlighted)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColorsForModalPresentation() {
        backgroundColor = .systemGray3
        setTitleColor(.systemGray2, for: .normal)
        
        if let currentImage = imageView?.image {
            let coloredImage = currentImage.withTintColor(.systemGray2)
            setImage(coloredImage, for: .normal)
            setImage(coloredImage, for: .highlighted)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let titleSize = titleLabel?.intrinsicContentSize ?? CGSize.zero
        let imageSize = imageView?.intrinsicContentSize ?? CGSize.zero
        let totalWidth = titleSize.width + 28 + imageSize.width + 8
        let totalHeight = max(titleSize.height, imageSize.height) + 20
        return CGSize(width: totalWidth, height: 44)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    }
    
    override var isHighlighted: Bool {
        didSet {
            let scale: CGFloat = isHighlighted ? 0.9 : 1.0
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
    }
    
    @objc private func touchDown() {
        if !isAnimating {
            isAnimating = true
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { _ in
                self.isAnimating = false
            })
        }
    }
    
    @objc private func touchUpInside() {
        if !isAnimating {
            isAnimating = true
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                self.transform = .identity
            }, completion: { _ in
                self.isAnimating = false
            })
        }
    }
    
    @objc private func touchUpOutside() {
        if !isAnimating {
            isAnimating = true
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                self.transform = .identity
            }, completion: { _ in
                self.isAnimating = false
            })
        }
    }
    
    func restoreColors() {
        restoreOriginalColors?()
    }
    
}

class ModalViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

extension ViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
      
        handleModalDismissal()
    }
}
