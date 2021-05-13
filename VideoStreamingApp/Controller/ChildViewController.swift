//
//  ChildViewController.swift
//  VideoStreamingApp
//
//  Created by Preeti Priyam on 5/3/21.
//

import UIKit
import AVKit
import AVFoundation

protocol ChildViewControllerProtocol {
    func videoFinished()
}

class ChildViewController: UIViewController {
    @IBOutlet weak var playPauseUIButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var backwardUIButton: UIButton!
    @IBOutlet weak var forwardUIButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var journalButton: UIButton!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    let videoController = AVPlayerViewController()
    let saveJournal = SaveJournalModel()
    
    var player: AVPlayer!
    
    var currentChapterId = 0
    var currentChapterName = ""
    var videoInFullScreen: Bool?
    
    var delegate: ChildViewControllerProtocol?
    
    var url : String? {
        didSet {
            //call method to update the url
            update()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UIStackView.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).spacing = 15
        playPauseUIButton.setImage(UIImage(named: Constants.pause), for: UIControl.State.normal)
        backwardUIButton.setImage(UIImage(named: Constants.backward), for: UIControl.State.normal)
        forwardUIButton.setImage(UIImage(named: Constants.forward), for: UIControl.State.normal)
        titleLabel.text = currentChapterName
        update()
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        self.videoController.player?.pause()
        let scene = self.view.window?.windowScene?.delegate as? SceneDelegate
        scene?.SignOut()
    }
    
    //func to play/pause the video
    @IBAction func playPauseButtonPressed(_ sender: UIButton) {
        if sender.isSelected {
            playPauseUIButton.setImage(UIImage(named: Constants.pause), for: UIControl.State.normal)
            self.videoController.player?.play()
            sender.isSelected = false
        }else{
            playPauseUIButton.setImage(UIImage(named: Constants.play), for: UIControl.State.normal)
            self.videoController.player?.pause()
            sender.isSelected = true
        }
    }
    
    @IBAction func backwardButtonPressed(_ sender: UIButton) {
        let currentTime = CMTimeGetSeconds((videoController.player?.currentTime())!)
        var newTime = currentTime - 5.0
        if newTime < 0 {
            newTime = 0
            self.videoController.player?.play()
        }
        let time: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
        self.videoController.player?.seek(to: time)
    }
    
    //function to forward the video to 5 seconds
    @IBAction func forwardButtonPressed(_ sender: UIButton) {
        guard let duration = self.videoController.player?.currentItem?.duration else {return}
        let currentTime = CMTimeGetSeconds((videoController.player?.currentTime())!)
        let newTime = currentTime + 5.0
        
        if newTime < (CMTimeGetSeconds(duration) - 5.0) {
            let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
            self.videoController.player?.seek(to: time)
        }
    }
    
    
    @IBAction func timeSlider(_ sender: UISlider) {
        videoController.player?.seek(to: CMTimeMake(value: Int64(sender.value*1000), timescale: 1000))
    }
    
    //method to retrieve the journal
    @IBAction func journalButtonAction(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "childToJournal", sender: self)
    }
}

// MARK: Utility functions
extension ChildViewController {
    
    //function to show the video of the corresponding cell
    func update(){
        if let url = url {
            guard let videoUrl = URL(string: url) else {return}
            videoController.showsPlaybackControls = false
            player = AVPlayer(url: videoUrl)
            player.currentItem?.addObserver(self, forKeyPath: Constants.keyPath, options: [.new,.initial], context: nil)
            videoController.player = player
            addTimeObserver()

            if let view = videoView {
                if view.subviews.count == 0 {
                    videoController.view.frame = view.bounds
                    videoController.view.frame.size.height = view.frame.size.height
                    videoController.view.frame.size.width = view.frame.size.width
                    view.addSubview(videoController.view)
                }
            }
            self.videoController.player?.play()
        }
    }
    
    //function to create the UI Alert
    func CreateUIAlert(_ level: Int, _ chapterName: String) {
        let alert = UIAlertController(title: Constants.alertComment, message: Constants.alertMessage, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "..."
        }
        //create add action
        let addAction = UIAlertAction(title: Constants.titleSubmit, style: .default) { (_) in
            guard let comments = alert.textFields?.first?.text else {return}
            //call api to add the comments
            self.saveJournal.saveComments(cName: chapterName, cComment: comments, cLevel: level) { (result) in
                if(result){
                    print("Journal Saved")
                }else{
                    print("Journal NotSaved")
                }
                self.delegate?.videoFinished()
            }
        }
        //create submit action
        let cancelAction = UIAlertAction(title: Constants.titleCancel, style: .default) { (_) in
            // Do Nothing
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //function to update the total duration of a video to the label
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Constants.keyPath, let duration = videoController.player?.currentItem?.duration.seconds, duration > 0.0 {
            self.durationLabel.text = getTimeInStringFormat(from: (videoController.player?.currentItem!.duration)!)
        }
    }
    
    //helper function to get the time
    func getTimeInStringFormat(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds/3600)
        let minutes = Int(totalSeconds/60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: Constants.timFormatInHours, hours,minutes,seconds)
        }else{
            return String(format: Constants.timFormatInMinutes, minutes,seconds)
        }
    }
    
    //function to observer video time
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.player.currentItem else {return}
            self?.currentTimeSlider.maximumValue = Float(currentItem.duration.seconds)
            self?.currentTimeSlider.minimumValue = 0
            
            self?.currentTimeSlider.value = Float(currentItem.currentTime().seconds)
            self?.currentTimeLabel.text = self?.getTimeInStringFormat(from: currentItem.currentTime())
            
            if(currentItem.currentTime() == currentItem.duration) {
                //call CreateUIAlert and save comments
                self!.CreateUIAlert(self!.currentChapterId, self!.currentChapterName)  
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as? JournalTableViewController
            destinationVC?.currentUserName = SaveJournalModel.userName!
    }
    
}
