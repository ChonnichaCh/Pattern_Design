protocol Publisher {
    func subscribe(_ observer: Observer)
    func unsubscribe(_ observer: Observer)
    func notify()
}

class EarthquakeAlert: Publisher {
    private var observers = [Observer]()
    private var earthquake = false
    private var epicenter = "" 
    private var intensity = 0.0

    func subscribe(_ observer: Observer){
        observers.append(observer)
    }
    func unsubscribe(_ observer: Observer){
        observers.removeAll{
            $0 === observer
        }
    }
    func notify(){
        let info = "Earthquake detected epicenter at '\(epicenter)' intensity \(intensity) magnitude!"
        for observer in observers{
            observer.update(info)
        }
    }
    func earthquakeDetect(_ e:String, _ i:Double){
        print("Earthquake Detected!")
        earthquake = true
        epicenter = e
        intensity = i
        notify()
    }
}

protocol Observer: AnyObject {
    func update(_ info: String)
}

class Individual: Observer{
    private var emergencyBag = [String]()
    
    func update(_ info: String){
        print("Individual Alert: \(info)")
        prepareEmergencyBag()
    }
    
    private func prepareEmergencyBag(){
        emergencyBag = ["Water", "Food", "First Aid Kit", "Flashlight", "Whistle"]
        print("     Individual prepared emergency bag: \(emergencyBag)")
    }
}

class Agency: Observer{
    private var countermeasures = ""
    
    func update(_ info: String){
        print("Agency Alert: \(info)")
        deployCountermeasures()
    }
    
    private func deployCountermeasures(){
        countermeasures = "Activate emergency response teams, Send medical supplies, Evacuate critical areas"
        print("     Agency deploying countermeasures: \(countermeasures)")
    }
}


let alert = EarthquakeAlert()
let individual = Individual()
let agency = Agency()

alert.subscribe(individual)
alert.subscribe(agency)

alert.earthquakeDetect("Myanmar", 7.6)
print("\n\n")

alert.unsubscribe(individual)

alert.earthquakeDetect("Myanmar", 5.5)