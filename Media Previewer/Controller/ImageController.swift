//
//  ImageController.swift
//  Media Previewer
//
//  Created by Nasibovic Fayzulloh on 23/10/22.
//

import Foundation
import UIKit
import SnapKit

class ImageController: UIViewController {
    
    let imageView = UIImageView()
    let bottomView = UIView()
    let shareButton = UIButton()
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        let apperance = UINavigationBarAppearance()
        apperance.configureWithOpaqueBackground()
        apperance.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.standardAppearance = apperance
    }
    
    override func viewDidLoad() {
        view.backgroundColor = #colorLiteral(red: 0.9593991637, green: 0.9593990445, blue: 0.9593990445, alpha: 1)
        initNavigationProperties()
        initViews()
    }
    
    func initNavigationProperties(){
        
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 35))
        backButton.setImage(UIImage(named: "Light"), for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem?.customView?.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let label = UILabel()
        label.text = "Name"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        navigationItem.titleView = label
        
        let sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 35))
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.black, for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        navigationItem.rightBarButtonItem?.customView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
   private func initViews() {

       
       view.addSubview(bottomView)
       bottomView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
       bottomView.snp.makeConstraints { make in
           make.left.right.equalToSuperview()
           make.height.equalToSuperview().multipliedBy(0.1)
           make.bottom.equalToSuperview()
       }
       view.addSubview(imageView)
       imageView.image = #imageLiteral(resourceName: "image")
       imageView.contentMode = .scaleToFill
       imageView.backgroundColor = .clear
       imageView.snp.makeConstraints { make in
           make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
           make.left.right.equalToSuperview()
           make.bottom.equalTo(bottomView.snp.top)
       }
       
       view.addSubview(shareButton)
       shareButton.setImage(UIImage(named: "share"), for: .normal)
       shareButton.snp.makeConstraints { make in
           make.top.equalTo(bottomView.snp.top).offset(25)
           make.left.equalTo(bottomView.snp.left).inset(15)
           make.height.width.equalTo(30)
       }
    }
    
}
