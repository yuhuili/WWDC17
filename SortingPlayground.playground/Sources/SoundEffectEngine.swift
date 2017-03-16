import AVFoundation

public class SoundEffectEngine {
    private var soundPlayer = AVAudioPlayer()
    public static let main = SoundEffectEngine()
    
    private init() {
        var soundPlayer = AVAudioPlayer()
        let shuffleURL = Bundle.main.url(forResource: "shuffle", withExtension: "mp3")
        if let shuffleURL = shuffleURL {
            do {
                soundPlayer = try AVAudioPlayer(contentsOf: shuffleURL)
                soundPlayer.volume = 0.05
                soundPlayer.prepareToPlay()
            } catch {
                
            }
        }
    }
    
    public func playShuffle() {
        soundPlayer.stop()
        soundPlayer.currentTime = 0
        soundPlayer.play()
    }
}
