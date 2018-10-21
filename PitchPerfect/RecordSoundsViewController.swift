//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Jonathan Dowdell on 10/15/18.
//  Copyright © 2018 Jonathan Dowdell. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    // MARK: - IB Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    // MARK: - Audio Recorder
    var audioRecorder:AVAudioRecorder!
    var correctPermission:Bool = false
    
    // MARK: - Start Recording
    @IBAction func recordButtonAction(_ sender: Any) {

        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            print("Permission Granted!")
            recordingLabel.text = "Tap to Record"
            correctPermission = true
        case .denied:
            print("Audio Permission Denied")
            recordingLabel.text = "Please grant microphone permissions in settings"
        case .undetermined:
            print("Lets Request Permission from Microphone")
            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
                if granted { self.correctPermission = true }
            }
        }
        
        if correctPermission {
            print("Correct Permissions")
            self.configureUI(recording: true)
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))
            print(filePath!)
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(.playAndRecord, mode: .default)
            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.isMeteringEnabled = true
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    }
    
    // MARK: - Stop Recording Action
    @IBAction func stopRecordingAction(_ sender: Any) {
        self.configureUI(recording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: - Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("It didn't turn out how you thought buddy...")
        }
    }
    
    // MARK: - Entry Point
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(recording:false)
    }
    
    // MARK: - View Will Apppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Configure UI
    func configureUI(recording:Bool) {
        if recording {
            UIView.animate(withDuration: 0.4) {
                self.stopRecording.isEnabled = true
                self.recordButton.isEnabled = false
                self.recordingLabel.text = "Recording in Progress"
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.stopRecording.isEnabled = false
                self.recordButton.isEnabled = true
                self.recordingLabel.text = "Tap to Record"
                self.view.layoutIfNeeded()
            }
        }
    }

}

