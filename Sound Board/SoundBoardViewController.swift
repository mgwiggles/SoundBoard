//
//  SoundBoardViewController.swift
//  Sound Board
//
//  Created by Mitch Guzman on 3/11/17.
//  Copyright © 2017 Mitch Guzman. All rights reserved.
//

import UIKit
import AVFoundation

class SoundBoardViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var audioRecorder : AVAudioRecorder? = nil
    var audioPlayer : AVAudioPlayer? = nil
    var audioURL : URL?
    
    override func viewDidLoad() {
        
        playButton.isEnabled = false
        
        addButton.isEnabled = false
        
        setupRecorder()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //    Function to handle all of the audio stuff
    func setupRecorder () {
        
        do {
            
            //        Create an audio session
            
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //        Create URL for the audio file
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            let pathComponents = [basePath, "audio.m4a"]
            
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            //        Create settings for audio recorder
            
            var settings : [String : Any] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            
            //        Create audio recorder object
            
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
            
        } catch let error as NSError {
            
            print(error)
            
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording {
//            Stop recording
            audioRecorder?.stop()
            
//            change button title to "record"
            recordButton.setTitle("Record", for: .normal)
            
            playButton.isEnabled = true
            
            addButton.isEnabled = true
            
        } else {
//            Start the recording
            audioRecorder?.record()
            
//            Change button title to "stop"
            recordButton.setTitle("Stop", for: .normal)
        }
        
    }
    @IBAction func playTapped(_ sender: Any) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        } catch {}
        
        
    }
    @IBAction func addTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: context)
        
        sound.name = nameTextField.text!
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
        
        
    }
}
