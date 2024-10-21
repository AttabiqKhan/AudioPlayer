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
    var audioFileName: String?  // For the audio selected from the table view
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
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
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150.autoSized, height: 120.autoSized)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(OptionsCollectionViewCell.self, forCellWithReuseIdentifier: OptionsCollectionViewCell.collectionViewIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    private var player: AVAudioPlayer!
    private var players: [String: AVAudioPlayer] = [:]
    private let options: [Options] = [.init(title: "Nature"), .init(title: "Bird"), .init(title: "Water"), .init(title: "City"), .init(title: "Forest"), .init(title: "Garden")]
    
    // MARK: - Overridden Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAudioSession()
        playInitialAudio()
    }
    
    // MARK: - Functions
    private func setupView() {
        view.backgroundColor = .systemMint
        view.addSubview(backButton)
        view.addSubview(playPauseButton)
        view.addSubview(volumeSlider)
        view.addSubview(collectionView)
        
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
            volumeSlider.heightAnchor.constraint(equalToConstant: 30.autoSized),
            
            collectionView.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 50.autoSized),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
        ])
    }
    private func setupAudioSession() {
        try! AVAudioSession.sharedInstance().setCategory(.playback, options: [])
    }
    private func playInitialAudio() {
        guard let fileName = audioFileName else { return }
        playAudio(fileName: fileName, forPlayer: &player)
    }
    private func playAudio(fileName: String, forPlayer player: inout AVAudioPlayer?) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = volumeSlider.value
            player?.play()
        } catch {
            print("Error initializing player: \(error.localizedDescription)")
        }
    }
    private func playSound(for option: String) {
        if let player = players[option], player.isPlaying {
            player.pause()
        } else {
            if players[option] == nil {
                guard let url = Bundle.main.url(forResource: option, withExtension: "mp3") else {
                    print("Audio file not found for option: \(option)")
                    return
                }
                do {
                    let newPlayer = try AVAudioPlayer(contentsOf: url)
                    newPlayer.volume = volumeSlider.value
                    players[option] = newPlayer
                    newPlayer.play()
                } catch {
                    print("Error initializing player for option \(option): \(error.localizedDescription)")
                }
            } else {
                players[option]?.play()
            }
        }
    }
    private func updateButtonImage() {
        if player.isPlaying  {
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    // MARK: - Selectors
    @objc private func didTapPlayPauseButton() {
        if let player = player, player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        updateButtonImage()
    }
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: false)
    }
    @objc private func didChangeVolume(_ sender: UISlider) {
        player?.volume = sender.value
        players.values.forEach { $0.volume = sender.value }  // Update volume for all players
    }
}

// MARK: - Collection View DataSource & Delegate
extension AudioPlayViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionsCollectionViewCell.collectionViewIdentifier, for: indexPath) as! OptionsCollectionViewCell
        cell.options = options[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let optionTitle = options[indexPath.item].title
        let selectedOption = optionTitle.lowercased()
        playSound(for: selectedOption)
    }
}
