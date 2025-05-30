import SpriteKit
import AVFoundation

class StartScene: SKScene {
    
    var backgroundMusicPlayer: AVAudioPlayer? // Para controlar a música
    var slider: UISlider? // Para o controle de volume
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        // Começar a música de fundo
        playBackgroundMusic()

        // Adicionar a imagem de fundo
        let background = SKSpriteNode(imageNamed: "mainBackground")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.size
        background.zPosition = -1
        addChild(background)

        // Título do jogo
       // let titleLabel = SKLabelNode(text: "FruitBallers")
       // titleLabel.fontName = "ArialRoundedMTBold"
        //titleLabel.fontSize = 50
        //titleLabel.fontColor = .white
        //titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 150)
        //addChild(titleLabel)

        // Botão START
        let startButton = SKLabelNode(text: "Start")
        startButton.name = "startButton"
        startButton.fontName = "AvenirNext-Bold"
        startButton.fontSize = 40
        startButton.fontColor = .green
        startButton.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(startButton)

        // Botão QUIT
        let quitButton = SKLabelNode(text: "Quit")
        quitButton.name = "quitButton"
        quitButton.fontName = "AvenirNext-Bold"
        quitButton.fontSize = 30
        quitButton.fontColor = .red
        quitButton.position = CGPoint(x: frame.midX, y: frame.midY - 60)
        addChild(quitButton)

        // Botão para controlar o som
        let soundButton = SKLabelNode(text: "Sound")
        soundButton.name = "soundButton"
        soundButton.fontName = "AvenirNext-Bold"
        soundButton.fontSize = 30
        soundButton.fontColor = .yellow
        soundButton.position = CGPoint(x: frame.midX, y: frame.midY - 120)
        addChild(soundButton)
    }

    // Função para iniciar a música de fundo
    func playBackgroundMusic() {
        if let url = Bundle.main.url(forResource: "Music", withExtension: "mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundMusicPlayer?.numberOfLoops = -1 // Toca indefinidamente
                backgroundMusicPlayer?.play()
            } catch {
                print("Erro ao carregar a música: \(error)")
            }
        }
    }

    // Função chamada quando o botão de som é pressionado
    func showSoundControl() {
        // Cria um slider para controlar o volume
        if slider == nil {
            slider = UISlider(frame: CGRect(x: 50, y: 50, width: self.size.width - 100, height: 30))
            slider?.minimumValue = 0.0
            slider?.maximumValue = 1.0
            slider?.value = 1.0
            slider?.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
            
            // Adiciona o slider à tela
            if let view = self.view {
                view.addSubview(slider!)
            }
        }
    }

    // Ajusta o volume da música com base no valor do slider
    @objc func sliderChanged(_ sender: UISlider) {
        backgroundMusicPlayer?.volume = sender.value
    }

    // Função para lidar com toques na tela
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let node = self.atPoint(location)

        if node.name == "startButton" {
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 1.0))
        } else if node.name == "quitButton" {
            exit(0) // Fecha a aplicação
        } else if node.name == "soundButton" {
            // Mostra o controle de som
            showSoundControl()
        }
    }

    // Função chamada quando a cena for desfeita (para remover o slider)
    override func willMove(from view: SKView) {
        slider?.removeFromSuperview() // Remove o slider da tela
    }
}
