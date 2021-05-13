//
//  MasterTableViewController.swift
//  VideoStreamingApp
//
//  Created by Preeti Priyam on 5/2/21.
//

import UIKit

class MasterTableViewController: UIViewController, ChildViewControllerProtocol {
    
    @IBOutlet weak var masterTableView: UITableView!
    
    private var isVideoPlayed : Bool?
    var childVC : ChildViewController? = nil
    private var count = -1
    
    var masterViewDataModel = MasterViewDataModel()
    let backgroundView = UIView()
    
    var latestWatchVideo = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        masterTableView.delegate = self
        masterTableView.dataSource = self
        
        if let lastWatched = UserDefaults.standard.value(forKey: SaveJournalModel.userName!) as? Int {
            latestWatchVideo = lastWatched
        }
        self.masterTableView.register(MasterTVCell.getNib(), forCellReuseIdentifier: MasterTVCell.identifier)
    }
    
    //delegate function to get notified when a video is finished
    func videoFinished() {
        latestWatchVideo = count
        DispatchQueue.main.async {
            //save the user data in user defaults
            UserDefaults.standard.set(self.latestWatchVideo, forKey:SaveJournalModel.userName!)
            UserDefaults.standard.synchronize()
            self.masterTableView.reloadData()
        }
    }

}

extension MasterTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //function to return the total number of rows counts.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        masterViewDataModel.masterViewData.count
    }
    
    //function to generate reusable cell and populate the data on the cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: MasterTVCell.identifier, for: indexPath) as! MasterTVCell
        customCell.textUiLabel.text = masterViewDataModel.masterViewData[indexPath.row].chapterName
        if indexPath.row < latestWatchVideo {
        // backgroundView.backgroundColor = CompletedChapterModel.bgColorCompleted
            customCell.backgroundColor = #colorLiteral(red: 0.0212367028, green: 0.1949231625, blue: 0.14209342, alpha: 1)
            backgroundView.backgroundColor = #colorLiteral(red: 0.3591029048, green: 0.6258577704, blue: 0.2535034418, alpha: 1)
            customCell.selectedBackgroundView = backgroundView
        }else{
            customCell.backgroundColor = #colorLiteral(red: 0.3591029048, green: 0.6258577704, blue: 0.2535034418, alpha: 1)
            backgroundView.backgroundColor = #colorLiteral(red: 0.0212367028, green: 0.1949231625, blue: 0.14209342, alpha: 1)
            customCell.selectedBackgroundView = backgroundView
        }
        return customCell
    }
    
    //function to get notified when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        count = indexPath.row + 1
        if  indexPath.row <= latestWatchVideo || indexPath.row == 0 {
            performSegue(withIdentifier: Constants.masterToChildSegue, sender: self)
        }else{
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    //function be called before performsegue to preapre the data to be send to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.masterToChildSegue {
            if let indexPath = self.masterTableView.indexPathForSelectedRow {
                    if let vc =  (segue.destination as! UINavigationController).topViewController as? ChildViewController {
                    childVC = vc
                    childVC?.delegate = self
                    childVC!.url = masterViewDataModel.masterViewData[indexPath.row].chapterUrl
                    childVC!.currentChapterId = count
                    childVC!.currentChapterName = masterViewDataModel.masterViewData[indexPath.row].chapterName
                    childVC!.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    childVC!.navigationItem.leftItemsSupplementBackButton = true
                    }
                }
            }
        }
    }
