//
//  VideoController.swift
//  Media Previewer
//
//  Created by Nasibovic Fayzulloh on 18/09/22.
//

import Foundation
import UIKit
import AVKit

class VideoController: UIViewController {
    var isPlaying: Bool = false
    let bottomView = UIView()
    let sliderBackView = UIView()
    let shareButton = UIButton()
    let slider = UISlider()
    let minutLabel = UILabel()
    let playButton = UIButton()
    let videoView = UIView()
    var player = AVPlayer()
    var videoDisplayLink: CADisplayLink?
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
        loadVideo()
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
        
        view.addSubview(videoView)
        videoView.backgroundColor = .clear
        videoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(sliderBackView.snp.top)
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
        slider.addTarget(self, action: #selector(sliderHandler(sender: event:)), for: .valueChanged)
        slider.snp.makeConstraints { make in
            make.center.equalTo(sliderBackView.snp.center)
            make.right.equalTo(sliderBackView.snp.right).inset(50)
            make.left.equalTo(sliderBackView.snp.left).inset(10)
        }
        
        
        view.addSubview(minutLabel)
        minutLabel.text = "1:12"
        minutLabel.font = .systemFont(ofSize: 14)
        minutLabel.textColor = .black
        minutLabel.textAlignment = .right
        minutLabel.numberOfLines = 1
        minutLabel.snp.makeConstraints { make in
            make.center.equalTo(sliderBackView.snp.center)
            make.right.equalTo(sliderBackView.snp.right).inset(10)
            
        }
        
        
        view.addSubview(playButton)
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.addTarget(self, action: #selector(didSelect), for: .touchUpInside)
        playButton.snp.makeConstraints { make in
            make.center.equalTo(bottomView.snp.center)
            
        }
        
     
        
    }
    
    
    @objc func sliderHandler(sender: UISlider, event: UIEvent) {
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
        pauseVideo()
    }
    
    func afterFinishSeeking() {
        playVideo()
    }
    
    
    func onSeeking() {
        guard let currentItem = player.currentItem else {
            return
        }
        
        let duration = Float(currentItem.duration.seconds)
        let persentage = slider.value
        let currentTime = duration * persentage
        let time = CMTimeMake(value: Int64(Float64(currentTime * 1000)), timescale: 1000)
        player.currentItem?.seek(to: time, completionHandler: nil)
        updateCurrentTimeLabel()
        
        
    }
    
    func playVideo() {
        player.play()
        invalidateDisplayLink()
        videoDisplayLink = .init(target: self, selector: #selector(onPlayingVideo))
        videoDisplayLink?.add(to: .current, forMode: .common)
        isPlaying = true
        playButton.setImage(UIImage(named: "pause"), for: .normal)
        
        
    }
    
    func pauseVideo() {
        invalidateDisplayLink()
        player.pause()
        isPlaying = false
        playButton.setImage(UIImage(named: "play"), for: .normal)
        
        
    }
    
    func invalidateDisplayLink() {
        observer?.invalidate()
        videoDisplayLink?.invalidate()
        videoDisplayLink = nil
    }
    
    private func loadVideo() {
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }
        
        let path = Bundle.main.path(forResource: "video", ofType:"mp4")
        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)
        DispatchQueue.main.async { [self] in
            playerLayer.frame = self.videoView.frame
        }
        
//        playerLayer.frame = .init(x: 0, y: 100, width: 430, height: 720)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer.zPosition = -1
        self.view.layer.addSublayer(playerLayer)
        player.seek(to: CMTime.zero)
        player.volume = 1.0
        player.externalPlaybackVideoGravity = AVLayerVideoGravity.resizeAspectFill
        
        
    }
    
    func updateCurrentTimeLabel() {
        let currentTime = player.currentTime().seconds
        self.minutLabel.text = "\(Date.secondsToTimer(seconds: currentTime))"
    }
    
    @objc func onPlayingVideo() {
        let currentSeconds = player.currentItem?.currentTime().seconds ?? 0
        let duration = player.currentItem?.duration.seconds ?? 1
        let persentage = currentSeconds / duration
        
        DispatchQueue.main.async {
            self.slider.setValue(Float(persentage), animated: false)
            self.updateCurrentTimeLabel()
            
        }
    }
    
    @objc func didSelect() {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if isPlaying {
            pauseVideo()
            
        } else {
            playVideo()
            
        }
        
    }
}
