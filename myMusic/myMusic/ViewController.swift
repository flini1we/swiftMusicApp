//
//  ViewController.swift
//  myMusic
//
//  Created by Данил Забинский on 05.07.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var table: UITableView!
    
    var songs = [Song]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSongs()
        
        table.delegate = self
        table.dataSource = self
    }
    
    func configureSongs(){
        songs.append(Song(name: "Supersonic",
                          albumName: "PEEKABOO",
                          artistName: "Big Baby Type, Aarne",
                          imageName: "cover1",
                          trackName: "Supersonic - Big Baby Type, Aarne"))
        songs.append(Song(name: "ЖАРА",
                          albumName: "ЛЕТНИЙ",
                          artistName: "Антоха МС",
                          imageName: "cover2",
                          trackName: "ЖАРА - Aнтоха МС"))
        songs.append(Song(name: "The Thrill",
                          albumName: "The Thrill",
                          artistName: "Wiz Khalifa, Empire Of The Sun",
                          imageName: "cover4",
                          trackName: "The Thrill - Wiz Khalifa, Empire Of The Sun"))
        songs.append(Song(name: "TURN IT ON!",
                          albumName: "TURN IT ON!",
                          artistName: "MORGENSHTERN, PALC",
                          imageName: "cover3",
                          trackName: "TURN_IT_ON! - MORGENSHERN, PALC"))
        songs.append(Song(name: "Яд",
                          albumName: "Кругозор",
                          artistName: "Местный",
                          imageName: "cover5",
                          trackName: "Местный-Яд"))
        songs.append(Song(name: "По ресторанам",
                          albumName: "По ресторанам",
                          artistName: "Руслан Набиев",
                          imageName: "cover6",
                          trackName: "Руслан Набиев-По ресторанам"))
        songs.append(Song(name: "Я не могу тебя найти",
                          albumName: "Я не могу тебя найти",
                          artistName: "SLAVA MARLOW",
                          imageName: "cover7",
                          trackName: "я не могу тебя найти"))
        songs.append(Song(name: "Outro",
                          albumName: "Outro",
                          artistName: "A-This",
                          imageName: "cover8",
                          trackName: "A-This-Outro"))
        songs.append(Song(name: "My Little Love (Dogger bootleg)",
                          albumName: "Lewis Mills ALBUM",
                          artistName: "Adele",
                          imageName: "cover9",
                          trackName: "Adele-My Little Love (Dogger bootleg)"))
        songs.append(Song(name: "Street S2 Echo",
                          albumName: "LONG LIVE 812",
                          artistName: "ALBLAK 52",
                          imageName: "cover10",
                          trackName: "ALBLAK 52-Street S2 Echo"))
        songs.append(Song(name: "SAD GIRLZ LUV MONEY",
                          albumName: "Lewis Mills ALBUM",
                          artistName: "Amaarae, Kali Uchis feat. Moliy",
                          imageName: "cover11",
                          trackName: "Amaarae, Kali Uchis feat. Moliy-SAD GIRLZ LUV MONEY"))
        songs.append(Song(name: "Lo Siento",
                          albumName: "VARSKVA",
                          artistName: "Big Baby Tape",
                          imageName: "cover12",
                          trackName: "Big Baby Tape-Lo Siento"))
        songs.append(Song(name: "Lyfe",
                          albumName: "VARSKVA",
                          artistName: "Big Baby Tape",
                          imageName: "cover12",
                          trackName: "Big Baby Tape-Lyfe"))
        songs.append(Song(name: "Redbone",
                          albumName: "Awaken, My love!",
                          artistName: "Childish Gambino",
                          imageName: "cover13",
                          trackName: "Childish Gambino-Redbone"))
        songs.append(Song(name: "Back To Back",
                          albumName: "Cristoforo Colombo",
                          artistName: "FRIENDLY THUG 52 NGG, Hugo Loud",
                          imageName: "cover14",
                          trackName: "FRIENDLY THUG 52 NGG, Hugo Loud-Back To Back"))
        songs.append(Song(name: "Город",
                          albumName: "Поколение Брат",
                          artistName: "GONE.Fludd",
                          imageName: "cover15",
                          trackName: "GONE.Fludd-Город"))
        songs.append(Song(name: "I GOT U",
                          albumName: "I GOY U",
                          artistName: "ToXi$",
                          imageName: "cover16",
                          trackName: "I GOT U"))
        songs.append(Song(name: "Maybe",
                          albumName: "Lewis Mills ALBUM",
                          artistName: "Kettenkarussel",
                          imageName: "cover17",
                          trackName: "Kettenkarussel-Maybe"))
        songs.append(Song(name: "Fantasy",
                          albumName: "Daydream",
                          artistName: "Mariah Carey",
                          imageName: "cover18",
                          trackName: "Mariah Carey-Fantasy"))
        songs.append(Song(name: "Тоска",
                          albumName: "Тоска",
                          artistName: "OG Buda, LOV66",
                          imageName: "cover19",
                          trackName: "og buda,lov66-тоска"))
        songs.append(Song(name: "BAD FOR YOUR HEALTH",
                          albumName: "Lewis Mills ALBUM",
                          artistName: "POSSESHOT",
                          imageName: "cover20",
                          trackName: "POSSESHOT-BAD FOR YOUR HEALTH"))
        songs.append(Song(name: "Raingurl",
                          albumName: "EP2",
                          artistName: "Yaeji",
                          imageName: "cover21",
                          trackName: "Yaeji-Raingurl"))
        songs.append(Song(name: "Again",
                          albumName: "Young",
                          artistName: "Young Thug",
                          imageName: "cover22",
                          trackName: "Young Thug-Again"))
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.albumName
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: song.imageName)
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let position = indexPath.row
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "player") as? PlayerViewController else{
            return
        }
        vc.songs = songs
        vc.position = position
        present (vc,animated: true)
    }
}

struct Song{
    let name: String
    let albumName: String
    let artistName: String
    let imageName: String
    let trackName: String
}
