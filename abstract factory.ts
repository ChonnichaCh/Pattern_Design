interface Character {
    dressUp():void;
}
interface Jessica extends Character {}

class JessicaCyber implements Jessica {
    dressUp():void {
        console.log("Jessica in cyber costume");
    }
}

class JessicaForest implements Jessica {
    dressUp():void {
        console.log("Jessica in forest costume");
    }
}

interface Monica extends Character {}

class MonicaCyber implements Monica {
    dressUp():void {
        console.log("Monica in cyber costume");
    }
}

class MonicaForest implements Monica {
    dressUp():void {
        console.log("Monica in forest costume");
    }
}

interface ThemeCostumeFactory {
    createJessica():Jessica;
    createMonica():Monica;
}

class CyberFactory implements ThemeCostumeFactory {
    createJessica():Jessica {
        return new JessicaCyber();
    }
    createMonica():Monica {
        return new MonicaCyber();
    }
}

class ForestFactory implements ThemeCostumeFactory {
    createJessica():Jessica {
        return new JessicaForest();
    }
    createMonica():Monica {
        return new MonicaForest();
    }
}

class CharacterInCostume {
    private jessicaCostume: Jessica;
    private monicaCostume: Monica;
    
    constructor(factory: ThemeCostumeFactory){
        this.jessicaCostume = factory.createJessica();
        this.monicaCostume = factory.createMonica();
    }
    
    dressUp():void {
        console.log("Costume :")
        this.jessicaCostume.dressUp();
        this.monicaCostume.dressUp();
    }
    
    changeCostume(factory: ThemeCostumeFactory):void {
        this.jessicaCostume = factory.createJessica();
        this.monicaCostume = factory.createMonica();
    }
}

//main
console.log("--Cyber Costume--");
const custume1 = new CharacterInCostume(new CyberFactory());
custume1.dressUp();

console.log("/n--Change Costume--");
custume1.changeCostume(new ForestFactory());
custume1.dressUp();

console.log("/n--Forest Costume--");
const custume2 = new CharacterInCostume(new ForestFactory());
custume2.dressUp()