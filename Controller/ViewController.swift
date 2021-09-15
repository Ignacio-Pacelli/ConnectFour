
import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var playerLabel: UILabel!
    
    var game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startGameFromServer()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return game?.rows ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game?.columns ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Space", for: indexPath) as? SpaceCell else {
            // we failed to get a SpaceCell – bail out!
            fatalError("Unable to dequeue SpaceCell.")
        }
        
        let pointer = indexPath.section * game!.columns + indexPath.item
        let space = game!.spaces[pointer]
        cell.bindSpace(space: space)

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch game?.insertChipInColumn(column: indexPath.item) {
        case .failed_column_filled:
            showErrorColumnFilled()
            
        case .success_without_winner:
            playerLabel.text = "Current player: \(game!.currentPlayer.name)"
            
        case .success_with_winner:
            finishGameWithWinner(player: game!.currentPlayer)
        
        case .success_with_board_full:
            finishGameWithBoardFull()
        default:
            collectionView.reloadData()
        }
        
        collectionView.reloadData()
    }
    
    func showErrorColumnFilled() {
        let alert = UIAlertController(title: "Error!", message: "The column is already filled!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - Networking
    func startGameFromServer(){
        AF.request(BASE_URL).response { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let data):
                do {
                    let gameData = try JSONDecoder().decode([GameData].self, from: data!)
                    self.initGame(gameData: gameData[0])
                } catch let error {
                    print(error)
                }
            }
        }
    }
    
    func initGame(gameData : GameData){
        //init players
        let c1 = Color(hex: gameData.color1 ?? "#fccf03")
        let p1 = Player(name: gameData.name1 ?? "Player 1", color: c1)
        
        let c2 = Color(hex: gameData.color2 ?? "#20fc03")
        let p2 = Player(name: gameData.name2 ?? "Player 2", color: c2)
        
        //init game
        game = Game(id: gameData.id!, player1: p1, player2: p2, currentPlayer: p1)
        
        //init visuals
        playerLabel.text = "Current player: \(game!.currentPlayer.name)"
        collectionView.reloadData()
    }
    
    func restartGame(){
        self.game?.reset()
        self.playerLabel.text = "Current player: \(self.game!.currentPlayer.name)"
        self.collectionView.reloadData()
        self.playerLabel.textColor = .black
    }
    
    func finishGameWithWinner(player : Player) {
//        print("\(player.name) won!")
        playerLabel.text = "\(player.name) won!"
        playerLabel.textColor = hexStringToUIColor(hex: (player.color.hex))
        
        let alert = UIAlertController(title: "\(player.name) won!", message: "Congrats on your victory \(player.name) !", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.restartGame()
        }))
        self.present(alert, animated: true)
    }
    
    func finishGameWithBoardFull() {
        playerLabel.text = "Nobody wins!"
        
        let alert = UIAlertController(title: "Nobody wins!", message: "Should we start again?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.restartGame()
        }))
        self.present(alert, animated: true)
    }
}
