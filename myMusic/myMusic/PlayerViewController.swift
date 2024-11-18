//
//  PlayerViewController.swift
//  myMusic
//
//  Created by Данил Забинский on 06.07.2024.
//

import AVFoundation
import UIKit



class PlayerViewController: UIViewController {
    
    public var position: Int = 0
    
    public var songs: [Song] = []
    
    @IBOutlet var holder: UIView!
    
    var player: AVAudioPlayer?
    
    var trackDuration: TimeInterval = 0.0
    
    var updateTimer: Timer?
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let playPauseButton = UIButton()

    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica-Bold", size: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor =  .gray
        label.numberOfLines = 0
        return label
    }()
    
    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica", size: 14)
        label.textColor = .gray
        return label
    }()
    
    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont(name: "Helvetica", size: 14)
        label.textColor = .gray
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0 {
            configure()
        }
    }
    
    func configure(){
        let song = songs[position]
        
        let url = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            guard let url = url else {
                return
            }
            
            player = try AVAudioPlayer(contentsOf: URL(string: url)!)
            
            guard let player = player else{
                return
            }
            
            trackDuration = player.duration
            
            player.volume = 0.5
            
            player.play()
            
        } catch{
            print("error occured")
        }
       
        
        albumImageView.frame = CGRect(x: 10,
                                      y: 10,
                                      width: holder.frame.size.width-20,
                                      height: holder.frame.size.width-20)
        albumImageView.image = UIImage(named: song.imageName)
        holder.addSubview(albumImageView)
        
        songNameLabel.frame = CGRect(x: 65,
                                     y: albumImageView.frame.size.height + 10,
                                      width: holder.frame.size.width - 20,
                                      height: 70)

        artistNameLabel.frame = CGRect(x: 65,
                                       y: songNameLabel.frame.size.width + 39,
                                      width: holder.frame.size.width - 20,
                                      height: 70)
        
        songNameLabel.text = song.name
        artistNameLabel.text = song.artistName
        
        holder.addSubview(songNameLabel)
        holder.addSubview(artistNameLabel)
        
        let nextButton = UIButton()
        let backButton = UIButton()
        
        let yPosition = songNameLabel.frame.origin.y + 220
        let size: CGFloat = 60
        playPauseButton.frame = CGRect(x: (holder.frame.size.width - size) / 2.0,
                                       y: yPosition,
                                       width: size,
                                       height: size)
        nextButton.frame = CGRect(x: holder.frame.size.width - size - 20,
                                       y: yPosition,
                                       width: size,
                                       height: size)
        backButton.frame = CGRect(x: 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)
        
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        
        playPauseButton.tintColor = .black
        backButton.tintColor = .black
        nextButton.tintColor = .black
        
        holder.addSubview(playPauseButton)
        holder.addSubview(nextButton)
        holder.addSubview(backButton)
        
        // Slider
        let slider = UISlider(frame: CGRect(x: 20,
                                            y: holder.frame.size.height - 60,
                                            width: holder.frame.size.width - 40,
                                            height: 50))
        
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        holder.addSubview(slider)
        
        // ScrollSlider
        let scrollSlider = UISlider(frame: CGRect(x: 20, y: artistNameLabel.frame.origin.y + 60, width: holder.frame.size.width - 40, height: 50))
        scrollSlider.maximumValue = Float(player?.duration ?? 1.0)
        scrollSlider.addTarget(self, action: #selector(didScrollSlider(_:)), for: .valueChanged)
        holder.addSubview(scrollSlider)
        
        // Update slider thumb image
        let circleDiameter: CGFloat = 10.0
        UIGraphicsBeginImageContextWithOptions(CGSize(width: circleDiameter, height: circleDiameter), false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.gray.cgColor)
            context.fillEllipse(in: CGRect(x: 0, y: 0, width: circleDiameter, height: circleDiameter))
        }
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        scrollSlider.setThumbImage(thumbImage, for: .normal)
        
        // Add current time and remaining time labels
        currentTimeLabel.frame = CGRect(x: 20, y: scrollSlider.frame.origin.y + 40, width: 60, height: 20)
        remainingTimeLabel.frame = CGRect(x: holder.frame.size.width - 80, y: scrollSlider.frame.origin.y + 40, width: 60, height: 20)
        
        holder.addSubview(currentTimeLabel)
        holder.addSubview(remainingTimeLabel)
        
        updateTimer?.invalidate() // Invalidate any existing timer
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            if let self = self, let player = self.player, player.isPlaying {
                scrollSlider.value = Float(player.currentTime)
                self.currentTimeLabel.text = self.formatTime(player.currentTime)
                self.remainingTimeLabel.text = self.formatTime(player.duration - player.currentTime)
                
                if player.currentTime + 1.0 >= player.duration {
                    self.position += 1
                    player.stop()
                    for subview in self.holder.subviews {
                        subview.removeFromSuperview()
                    }
                    self.configure()
                    player.play()
                    timer.invalidate()
                }
            } else {
                timer.invalidate()
            }
        }
    }
    
    @objc func didTapBackButton() {
        if position > 0 {
            position -= 1
            player?.stop()
            
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        } else {
            position = songs.count - 1
            player?.stop()
            
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            
            configure()
        }
    }
   
    
    @objc func didTapNextButton() {
        if position < songs.count - 1 {
            position += 1
            player?.stop()
            
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        } else {
            position = 0
            player?.stop()
            
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    @objc func didTapPlayPauseButton(){
        if player?.isPlaying == true{
            // pause
            player?.pause()
            // show play button
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            
            // shrink image
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 30,
                                                   y: 30,
                                                   width: self.holder.frame.size.width-60,
                                                   height: self.holder.frame.size.width-60)
            })
        }
        else{
            // play
            player?.play()
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            // increase image size
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 10,
                                                   y: 10,
                                                   width: self.holder.frame.size.width-20,
                                                   height: self.holder.frame.size.width-20)
            })
        }
    }
    
    @objc func didSlideSlider(_ slider: UISlider){
        let value = slider.value
        player?.volume = value
    }
    
    @objc func didScrollSlider(_ scrollSlider: UISlider) {
        player?.currentTime = TimeInterval(scrollSlider.value)
        currentTimeLabel.text = formatTime(player?.currentTime ?? 0)
        remainingTimeLabel.text = formatTime((player?.duration ?? 0) - (player?.currentTime ?? 0))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated) // NEW
        updateTimer?.invalidate()
        updateTimer = nil
        if let player = player {
            player.stop()
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
            let minutes = Int(time) / 60
            let seconds = Int(time) % 60
            return String(format: "%02d:%02d", minutes, seconds)
    }
}
