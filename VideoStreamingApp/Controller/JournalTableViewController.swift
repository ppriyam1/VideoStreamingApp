//
//  JournalTableViewController.swift
//  VideoStreamingApp
//
//  Created by Preeti Priyam on 5/6/21.
//

import UIKit

class JournalTableViewController: UITableViewController {
    
    let retrieveJournal = RetrieveJournalModel()
    
    var currentUserName : String?
    var journalData : [Journal]?    
    private var chapter = [String]()
    private var userComment = [String]()
    private var date = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveJournal.retrieveModel(SaveJournalModel.userName!) { [weak self] (results) in
            for result in results {
                self!.chapter.append(result.chapterName)
                self!.userComment.append(result.comment)
                self!.date.append(result.date)
            }
            DispatchQueue.main.async {
             self!.tableView.reloadData()
            }
        }
        tableView.register(JournalTableViewCell.getNib(), forCellReuseIdentifier: JournalTableViewCell.identifier)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapter.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: JournalTableViewCell.identifier, for: indexPath) as! JournalTableViewCell
        customCell.chapterLabel.text = chapter[indexPath.row]
        customCell.datelabel.text = date[indexPath.row]
        customCell.userCommentLabel.text = userComment[indexPath.row]
        return customCell
    }
}

