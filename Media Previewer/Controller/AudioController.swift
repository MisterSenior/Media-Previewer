//
//  ViewController.swift
//  Media Previewer
//
//  Created by Nasibovic Fayzulloh on 12/09/22.
//

import UIKit
import SnapKit
import AVFoundation


class AudioController: UIViewController {
    var isPlaying: Bool = false
    let bottomView = UIView()
    let sliderBackView = UIView()
    let shareButton = UIButton()
    let slider = UISlider()
    let label = UILabel()
    let playButton = UIButton()
    let centerView = UIView()
    let simpleImage = UIImageView()
    var player: AVPlayer?
    var avPlayerItem: AVPlayerItem?
    var audioDisplayLink: CADisplayLink?
    var observer: NSKeyValueObservation?
    
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.standardAppearance = appearance
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationProperties()
        view.backgroundColor = #colorLiteral(red: 0.9593991637, green: 0.9593990445, blue: 0.9593990445, alpha: 1)
        initViews()
        loadAudio()
        
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
    
    private func initViews(){
        
        
        view.addSubview(bottomView)
        bottomView.backgroundColor = #colorLiteral(red: 0.9593991637, green: 0.9593990445, blue: 0.9593990445, alpha: 1)
        bottomView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(1)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.bottom.equalToSuperview()
        }
        
        
        view.addSubview(sliderBackView)
        sliderBackView.backgroundColor = #colorLiteral(red: 0.9593991637, green: 0.9593990445, blue: 0.9593990445, alpha: 1)
        sliderBackView.layer.borderWidth = 0.3
        sliderBackView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        sliderBackView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomView.snp.top).offset(20)
            make.width.equalToSuperview().multipliedBy(1)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
        
        view.addSubview(shareButton)
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.top).offset(25)
            make.left.equalTo(bottomView.snp.left).inset(15)
            make.height.width.equalTo(30)
            
        }
        
        
        view.addSubview(slider)
        slider.backgroundColor = .clear
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.setThumbImage(UIImage(named: "Rectangle 169"), for: .normal)
        let highlighted = UIImage(named: "Rectangle")
        slider.setThumbImage(highlighted, for: .highlighted)
        slider.addTarget(self, action: #selector(sliderHandler(slider: event: )), for: .valueChanged)
        slider.snp.makeConstraints { make in
            make.center.equalTo(sliderBackView.snp.center)
            make.right.equalTo(sliderBackView.snp.right).inset(50)
            make.left.equalTo(sliderBackView.snp.left).inset(10)
        }
        
        
        view.addSubview(label)
        label.text = "00:00"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 1
        label.snp.makeConstraints { make in
            make.center.equalTo(sliderBackView.snp.center)
            make.right.equalTo(sliderBackView.snp.right).inset(10)
            
        }
        
        
        view.addSubview(playButton)
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.addTarget(self, action: #selector(didSelect), for: .touchUpInside)
        playButton.snp.makeConstraints { make in
            make.center.equalTo(bottomView.snp.center)
            
        }
        
        view.addSubview(centerView)
        centerView.backgroundColor = .white
        centerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(sliderBackView.snp.top)
        }
        
        view.addSubview(simpleImage)
        simpleImage.image = UIImage(named: "simple")
        simpleImage.backgroundColor = .clear
        simpleImage.snp.makeConstraints { make in
            make.center.equalTo(centerView.snp.center)
        }
    }
    
    
    
    @objc func sliderHandler(slider: UISlider, event: UIEvent) {
        if let touch = event.allTouches?.first {
            switch touch.phase {
            case .began:
                beforeStartSeeking()
            case .moved:
                onSeeking()
                break
            case .ended:
                afterFinishSeeking()
                break
            default:
                break
                
            }
        }
    }
    
    func beforeStartSeeking() {
        pauseAudio()
    }
    
    func afterFinishSeeking() {
        playAudio()
    }
    
    
    func onSeeking() {
        guard let currentItem = player?.currentItem else {
            return
        }
        
        let duration = Float(currentItem.duration.seconds)
        let persentage = slider.value
        let currentTime = duration * persentage
        let time = CMTimeMake(value: Int64(Float64(currentTime * 1000)), timescale: 1000)
        player?.currentItem?.seek(to: time, completionHandler: nil)
        updateCurrentTimeLabel()
    }
    
    func playAudio() {
        player!.play()
        invalidateDisplayLink()
        audioDisplayLink = .init(target: self, selector: #selector(onPlayingAudio))
        audioDisplayLink?.add(to: .current, forMode: .common)
        isPlaying = true
        playButton.setImage(UIImage(named: "pause"), for: .normal)
    }
    
    func pauseAudio() {
        invalidateDisplayLink()
        player!.pause()
        isPlaying = false
        playButton.setImage(UIImage(named: "play"), for: .normal)
        
    }
    
    func invalidateDisplayLink() {
        observer?.invalidate()
        audioDisplayLink?.invalidate()
        audioDisplayLink = nil
    }
    
    private func loadAudio() {
        let url = URL(string: "https://s3.amazonaws.com/kargopolov/kukushka.mp3")
        self.avPlayerItem = AVPlayerItem(url: url!)
        self.player = AVPlayer.init(playerItem: avPlayerItem)
        self.player?.volume = 1.0
        
        
    }
    
    func updateCurrentTimeLabel() {
        let currentTime = player!.currentTime().seconds
        self.label.text = "\(Date.secondsToTimer(seconds: currentTime))"
    }
    
    @objc func onPlayingAudio() {
        let currrentSeconds = player?.currentItem?.currentTime().seconds ?? 0
        let duration = player?.currentItem?.duration.seconds  ?? 1
        let persentage = currrentSeconds / duration
        
        DispatchQueue.main.async {
            self.slider.setValue(Float(persentage), animated: false)
            self.updateCurrentTimeLabel()
        }
    }
    
    
    
    @objc func didSelect() {
        if isPlaying {
            pauseAudio()
        } else {
            playAudio()
        }
    }
    
}

