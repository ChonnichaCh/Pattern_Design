object GameSettings {
    private var locked = false // ไม่สามารถอ่านหรือเปลี่ยนค่าจากนอก class ได้
    
    var language: String = "eng"
        private set //สามารถอ่านค่าจากนอก class ได้ แต่เปลี่ยนค่าไม่ได้

    var soundEffects: Boolean = true
        private set

    var musicVolume: Double = 0.5
        private set
        
    var voiceVolume: Double = 0.8
        private set
        
    var difficultyLevel: String = "normal"
        private set
        
    var graphicsResolution: String = "low"
        private set

    fun setLanguage(lang: String) {
        if(!checkLock()) return
        
        val supportedLanguages = listOf("eng", "th", "jp")
        if (lang in supportedLanguages) {
            language = lang
            println("Language set to $lang")
        } else {
            println("Unsupported language: $lang")
        }
    }

    fun toggleSoundEffects() {
        if(!checkLock()) return
        
        soundEffects = !soundEffects
        println("Sound is now ${if (soundEffects) "ON" else "OFF"}")
    }

    fun setMusicVolume(volume: Double) {
        if(!checkLock()) return
        
        if (volume in 0.0..1.0) {
            musicVolume = volume
            println("Music volume set to $volume")
        } else {
            println("Volume must be between 0.0 and 1.0")
        }
    }
    
    fun setVoiceVolume(volume: Double) {
        if(!checkLock()) return
        
        if (volume in 0.0..1.0) {
            voiceVolume = volume
            println("Music volume set to $volume")
        } else {
            println("Volume must be between 0.0 and 1.0")
        }
    }
    
    fun setDifficulty(level: String) {
        if(!checkLock()) return
    
        val validLevels = listOf("easy", "normal", "hard")
        if (level in validLevels) {
            difficultyLevel = level
            println("Difficulty level set to $level")
        } else {
            println("Invalid difficulty level: $level")
        }
    }
    
    fun setGraphics(level: String) {
        if(!checkLock()) return
        
        val validLevels = listOf("low", "medium", "high")
        if (level in validLevels) {
            graphicsResolution = level
            println("Graphics resolution set to $level")
        } else {
            println("Invalid graphics resolution: $level")
        }
    }

    fun showSettings() {
        println("Current Game Settings:")
        println("- Language: $language")
        println("- Sound Effects: ${if (soundEffects) "ON" else "OFF"}")
        println("- Music Volume: $musicVolume")
        println("- Voice Volume: $voiceVolume")
        println("- Difficulty Level: $difficultyLevel")
        println("- Graphics Resolution: $graphicsResolution")
    }
    
    fun lockSettings() {
        locked = true
    }
    
    fun unlockSettings() {
        locked = false
    }
    
    private fun checkLock() : Boolean {
        if(locked){
            println("settings are locked.")
            return false
        }
        return true
    }
}
fun main() {
    GameSettings.showSettings()

    println("\n")
    GameSettings.setLanguage("th")
    GameSettings.toggleSoundEffects()
    GameSettings.setMusicVolume(0.3)
    GameSettings.setVoiceVolume(0.9)
    GameSettings.setDifficulty("hard")
    GameSettings.setGraphics("high")

    println()
    GameSettings.showSettings()
    
    println("\n")
    GameSettings.lockSettings()
    GameSettings.setLanguage("eng")
    GameSettings.unlockSettings()

    // ตัวอย่างการใส่ค่าผิด
    println()
    GameSettings.setLanguage("de")
    GameSettings.setDifficulty("ultra")
    GameSettings.setMusicVolume(1.5)
}
