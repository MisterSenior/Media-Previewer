//
//  UnsupportedViewController.swift
//  Media Previewer
//
//  Created by Nasibovic Fayzulloh on 13/11/22.
//

import Foundation
import UIKit

class UnsupportedViewController: UIViewController {
    
    let textLabel = UILabel()
    let shareButton = UIButton()
    let bottomView = UIView()
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        let apperance = UINavigationBarAppearance()
        apperance.configureWithOpaqueBackground()
        apperance.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.standardAppearance = apperance
    }
    
    override func viewDidLoad() {
        view.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
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
        
        view.addSubview(textLabel)
        textLabel.text = "Unsupported\n document"
        textLabel.textColor = .lightGray
        textLabel.contentMode = .top
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.font = .systemFont(ofSize: 40, weight: .bold)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
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
