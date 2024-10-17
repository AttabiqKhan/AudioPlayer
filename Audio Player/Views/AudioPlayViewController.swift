//
//  AudioPlayViewController.swift
//  Audio Player
//
//  Created by Attabiq Khan on 08/10/2024.
//

import UIKit
import AVFoundation

class AudioPlayViewController: UIViewController {
    
    // MARK: - Variables
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowshape.backward.fill"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    var audioFileName: String?
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 40.autoSized
        button.layer.borderWidth = 2.autoSized
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        return button
    }()
    private lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.5
        slider.tintColor = .black
        slider.addTarget(self, action: #selector(didChangeVolume(_:)), for: .valueChanged)
        return slider
    }()
    private var player: AVAudioPlayer!
    
    // MARK: - Overridden Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAudioSession()
    }
    
    // MARK: - Functions
    private func setupView() {
        view.backgroundColor = .systemGray4
        view.addSubview(backButton)
        view.addSubview(playPauseButton)
        view.addSubview(volumeSlider)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.autoSized),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.widthRatio),
            backButton.widthAnchor.constraint(equalToConstant: 44.widthRatio),
            backButton.heightAnchor.constraint(equalToConstant: 44.autoSized),
            
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 80.widthRatio),
            playPauseButton.heightAnchor.constraint(equalToConstant: 80.autoSized),
            
            volumeSlider.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 30.autoSized),
            volumeSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            volumeSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            volumeSlider.heightAnchor.constraint(equalToConstant: 30.autoSized)
        ])
    }
    private func setupAudioSession() {
        try! AVAudioSession.sharedInstance().setCategory(.playback, options: [])
    }

    private func playSound() {
        if let player = player, player.isPlaying {
            player.pause()
        } else {
            if player == nil {
                if let fileName = audioFileName, let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
                    do {
                        player = try AVAudioPlayer(contentsOf: url)
                        player.volume = volumeSlider.value
                    } catch {
                        print("Error initializing player: \(error.localizedDescription)")
                        return
                    }
                } else {
                    print("Audio file not found")
                    return
                }
            }
            player.play()
        }
    }
    private func updateButtonImage() {
        if player.isPlaying {
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    // MARK: - Selectors
    @objc private func didTapPlayPauseButton() {
        playSound()
        updateButtonImage()
    }
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: false)
    }
    @objc private func didChangeVolume(_ sender: UISlider) {
        player?.volume = sender.value
    }
}
