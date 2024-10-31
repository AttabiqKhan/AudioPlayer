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
        button.tintColor = .primary
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
        button.backgroundColor = .primary
        button.layer.cornerRadius = 40.autoSized
        button.layer.borderWidth = 2.autoSized
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        button.layer.shadowColor = UIColor.accent.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 8
        return button
    }()
    private lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.5
        slider.tintColor = .primary
        slider.thumbTintColor = .primary
        slider.addTarget(self, action: #selector(didChangeVolume(_:)), for: .valueChanged)
        return slider
    }()
    private lazy var secondaryVolumeSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.5
        slider.tintColor = .primary
        slider.thumbTintColor = .primary
        slider.addTarget(self, action: #selector(didChangeSecondaryVolume(_:)), for: .valueChanged)
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
    private lazy var dummyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash.square.fill"), for: .normal)
        button.tintColor = .primary
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectDummyButton), for: .touchUpInside)
        return button
    }()
    private lazy var volumeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "speaker.wave.2.fill")
        imageView.tintColor = .primary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapVolumeIcon)))
        return imageView
    }()
    private lazy var mixButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Mix", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .primary
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapMixButton), for: .touchUpInside)
        return button
    }()
    private var player: AVAudioPlayer!
    private lazy var players: [AVAudioPlayer?] = Array(repeating: nil, count: options.count)
    private let options: [Options] = [
        .init(title: "Nature"),
        .init(title: "Bird"),
        .init(title: "Water"),
        .init(title: "City"),
        .init(title: "Forest"),
        .init(title: "Garden")
    ]
    private var isMuted = false
    private var isRecordingMix = false
    private var mixEngine: AVAudioEngine?
    private var mixerNode: AVAudioMixerNode?
    private var audioFile: AVAudioFile?
    
    // MARK: - Overridden Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAudioSession()
        setupAudioEngine()
        playInitialAudio()
    }
    
    // MARK: - Functions
    private func setupUI() {
        view.addGradient(colors: [.secondary, .midGradient, .background], locations: [0.0, 0.6, 1.0])
        view.backgroundColor = .background
        view.addSubview(backButton)
        view.addSubview(playPauseButton)
        view.addSubview(volumeSlider)
        view.addSubview(secondaryVolumeSlider)
        view.addSubview(collectionView)
        view.addSubview(dummyButton)
        view.addSubview(volumeIcon)
        view.addSubview(mixButton)
        
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
            
            secondaryVolumeSlider.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 30.autoSized),
            secondaryVolumeSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            secondaryVolumeSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            secondaryVolumeSlider.heightAnchor.constraint(equalToConstant: 30.autoSized),
            
            collectionView.topAnchor.constraint(equalTo: secondaryVolumeSlider.bottomAnchor, constant: 50.autoSized),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            
            dummyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.autoSized),
            dummyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.widthRatio),
            dummyButton.widthAnchor.constraint(equalToConstant: 44.widthRatio),
            dummyButton.heightAnchor.constraint(equalToConstant: 44.autoSized),
            
            volumeIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            volumeIcon.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 16.widthRatio),
            volumeIcon.widthAnchor.constraint(equalToConstant: 24.widthRatio),
            volumeIcon.heightAnchor.constraint(equalToConstant: 24.autoSized),
            
            mixButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.autoSized),
            mixButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mixButton.widthAnchor.constraint(equalToConstant: 80.widthRatio),
            mixButton.heightAnchor.constraint(equalToConstant: 44.autoSized),
        ])
    }
    private func setupAudioSession() {
        //try! AVAudioSession.sharedInstance().setCategory(.playback, options: [])
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                options: [.mixWithOthers, .duckOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }
    private func playInitialAudio() {
        guard let fileName = audioFileName else { return }
        playAudio(
            fileName: fileName,
            forPlayer: &player
        )
    }
    private func playAudio(fileName: String, forPlayer player: inout AVAudioPlayer?) {
        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "mp3"
        ) else {
            print("Audio file not found")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.volume = volumeSlider.value
            player?.play()
        } catch {
            print("Error initializing player: \(error.localizedDescription)")
        }
    }
    private func playSound(for index: Int) {
        player.stop()
        player.currentTime = 0
        let option = options[index].title.lowercased()
        
        // Check if the tapped audio is already playing
        if let player = players[index], player.isPlaying {
            // Pause the currently playing audio for this cell
            print("Pausing audio for option: \(option)")
            player.stop()
            players[index] = nil
            return
        } else {
            // Stop, reset, and play all other audio players from the beginning
            for (i, otherPlayer) in players.enumerated() {
                if let otherPlayer = otherPlayer {
                    // Stop and reset other players
                    print("Stopping and resetting audio for option: \(options[i].title.lowercased())")
                    otherPlayer.stop() // Stop the audio
                    otherPlayer.currentTime = 0 // Reset to the beginning
                    otherPlayer.play() // Start the audio again from the beginning
                }
            }
            // Create or reset the player for the tapped audio
            if players[index] == nil {
                // Create a new player for the tapped audio
                guard let url = Bundle.main.url(forResource: option, withExtension: "mp3") else {
                    print("Audio file not found for option: \(option)")
                    return
                }
                do {
                    let newPlayer = try AVAudioPlayer(contentsOf: url)
                    newPlayer.numberOfLoops = -1
                    newPlayer.volume = secondaryVolumeSlider.value
                    players[index] = newPlayer
                    newPlayer.volume = isMuted ? 0 : secondaryVolumeSlider.value
                    newPlayer.play()  // Play the new audio
                    print("Playing new audio for option: \(option)")
                } catch {
                    print("Error initializing player for option \(option): \(error.localizedDescription)")
                }
            } else {
                // If the player exists, reset it to the beginning and play
                //players[index]?.currentTime = 0
                players[index]?.play()
                print("Playing audio for option: \(option) from the beginning.")
            }
        }
        player.play()
    }
    private func printCurrentlyPlayingAudios() {
        var currentlyPlaying: [String] = []
        
        if let mainPlayer = player, mainPlayer.isPlaying {
            let formattedTime = String(format: "%.2f", mainPlayer.currentTime)
            currentlyPlaying.append("Main Audio (\(audioFileName ?? "Unknown")): Playing at \(formattedTime) seconds")
        }
        
        for (index, player) in players.enumerated() {
            if let player = player, player.isPlaying {
                let optionTitle = options[index].title
                let currentTime = player.currentTime
                let formattedTime = String(format: "%.2f", currentTime) // Format timestamp to 2 decimal places
                currentlyPlaying.append("\(optionTitle): Playing at \(formattedTime) seconds")
            }
        }
        
        // Print the currently playing audios
        if currentlyPlaying.isEmpty {
            print("No audios are currently playing.")
        } else {
            print("Currently Playing Audios:")
            for audio in currentlyPlaying {
                print(audio)
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
    // Add these new functions for mixing functionality
    private func setupAudioEngine() {
        mixEngine = AVAudioEngine()
        mixerNode = AVAudioMixerNode()
        
        guard let engine = mixEngine, let mixer = mixerNode else { return }
        
        engine.attach(mixer)
        engine.connect(mixer, to: engine.mainMixerNode, format: nil)
        
        try? engine.start()
    }
    private func startMixing() {
            guard let engine = mixEngine else { return }
            
            // Create directory for saving mixed audio if it doesn't exist
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let mixesDirectory = documentsPath.appendingPathComponent("AudioMixes")
            
            do {
                try FileManager.default.createDirectory(at: mixesDirectory, withIntermediateDirectories: true)
            } catch {
                print("Failed to create directory: \(error.localizedDescription)")
                return
            }
            
            // Create unique filename with timestamp
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
            let timestamp = dateFormatter.string(from: Date())
            let mixFileName = "mix_\(timestamp).mp4"
            let mixFileUrl = mixesDirectory.appendingPathComponent(mixFileName)
            
            // Set up audio file
            let settings: [String: Any] = [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                audioFile = try AVAudioFile(forWriting: mixFileUrl, settings: settings)
                
                // Start the audio engine
                engine.prepare()
                try engine.start()
                
                // Install tap on main mixer node
                engine.mainMixerNode.installTap(onBus: 0, bufferSize: 4096, format: nil) { [weak self] buffer, time in
                    do {
                        try self?.audioFile?.write(from: buffer)
                    } catch {
                        print("Error writing buffer to file: \(error.localizedDescription)")
                    }
                }
                
            } catch {
                print("Error setting up audio file: \(error.localizedDescription)")
                return
            }
            
            // Example delay before stopping
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.stopMixing()
                
                // Check if file was created successfully
                if FileManager.default.fileExists(atPath: mixFileUrl.path) {
                    print("Mix file saved successfully at \(mixFileUrl)")
                } else {
                    print("Failed to save mix file.")
                }
            }
        }
    private func stopMixing() {
            
            mixEngine?.mainMixerNode.removeTap(onBus: 0)
            audioFile = nil
            
            // Show success alert
            let alert = UIAlertController(
                title: "Mix Saved",
                message: "Your audio mix has been saved to the device",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                // Assuming mixFileUrl is accessible here or pass it in as an argument
                if let mixFileUrl = self?.audioFile?.url {
                    self?.shareAudioFile(at: mixFileUrl)
                }
            }))
            present(alert, animated: true)
        }
    private func shareAudioFile(at url: URL) {
        let documentController = UIDocumentInteractionController(url: url)
        documentController.uti = "public.mpeg-4-audio"
        documentController.presentOptionsMenu(from: view.bounds, in: self.view, animated: true)
    }
    private func getPlayingAudioCount() -> Int {
        var count = 0
        
        // Check main player
        if let mainPlayer = player, mainPlayer.isPlaying {
            count += 1
        }
        // Check collection view players
        for player in players {
            if let player = player, player.isPlaying {
                count += 1
            }
        }
        return count
    }
    
    // MARK: - Selectors
    @objc private func didTapPlayPauseButton() {
        UIView.animate(withDuration: 0.1) {
            self.playPauseButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.playPauseButton.transform = .identity
            }
        }
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
    }
    @objc private func didChangeSecondaryVolume(_ sender: UISlider) {
        players.forEach { $0?.volume = sender.value }  // Update volume for all players in collection view
    }
    @objc private func didSelectDummyButton() {
        printCurrentlyPlayingAudios()
    }
    @objc private func didTapVolumeIcon() {
        isMuted.toggle()
        
        let iconName = isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill"
        UIView.transition(with: volumeIcon, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.volumeIcon.image = UIImage(systemName: iconName)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.volumeIcon.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.volumeIcon.transform = .identity
            }
        }
        // Toggle main player's volume
        if isMuted {
            player?.volume = 0
            players.forEach { $0?.volume = 0 }  // Mute all collection view players
        } else {
            player?.volume = volumeSlider.value  // Restore main player volume from slider
            players.forEach { $0?.volume = secondaryVolumeSlider.value  }  // Restore all players in collection view
        }
    }
    @objc private func didTapMixButton() {
        let playingCount = getPlayingAudioCount()
        
        if playingCount < 2 {
            let alert = UIAlertController(
                title: "Cannot Create Mix",
                message: "Please play at least two audio tracks to create a mix.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        isRecordingMix.toggle()
        
        if isRecordingMix {
            mixButton.backgroundColor = .midGradient
            mixButton.setTitle("Stop", for: .normal)
            startMixing()
        } else {
            mixButton.backgroundColor = .primary
            mixButton.setTitle("Mix", for: .normal)
            stopMixing()
        }
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
        cell.layer.cornerRadius = 12
        cell.contentView.layer.cornerRadius = 12
        cell.layer.shadowColor = UIColor.primary.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowOpacity = 0.1
        cell.layer.shadowRadius = 4
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let value = indexPath.item
        playSound(for: value)
    }
}
