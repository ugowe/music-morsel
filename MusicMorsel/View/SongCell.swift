//
//  SongTableViewCell.swift
//  MusicMorsel
//
//  Created by Joseph Ugowe on 11/4/17.
//  Copyright © 2017 Joseph Ugowe. All rights reserved.
//

import UIKit

protocol SongCellDelegate {
    func pauseTapped(_ cell: SongCell)
    func resumeTapped(_ cell: SongCell)
    func cancelTapped(_ cell: SongCell)
    func downloadTapped(_ cell: SongCell)
}

class SongCell: UITableViewCell {

    var delegate: SongCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        if (pauseButton.titleLabel?.text == "Pause") {
            delegate?.pauseTapped(self)
        } else {
            delegate?.resumeTapped(self)
        }
    }
    
    @IBAction func pauseOrResumeTapped(_ sender: Any) {
        delegate?.cancelTapped(self)
    }
    
    @IBAction func downloadTapped(_ sender: Any) {
        delegate?.downloadTapped(self)
    }
    
    func configure(song: Song, downloaded: Bool) {
        titleLabel.text = song.name
        artistLabel.text = song.artist
        
        
        selectionStyle = downloaded ? UITableViewCellSelectionStyle.gray : UITableViewCellSelectionStyle.none
        downloadButton.isHidden = downloaded
    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
