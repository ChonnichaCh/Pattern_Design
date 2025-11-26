import Foundation

class CraftingTemplate{
    var name: String
    var craftTime: Int
    
    init(name: String, craftTime: Int){
        self.name = name
        self.craftTime = craftTime
    }
    func checkMaterials(){
        print("check materials for \(name)")
    }
    func selectRecipe(){
        fatalError("Subclasses must implement selectRecipe()")
    }
    func craftItem(){
        fatalError("Subclasses must implement craftItem()")
    }
    func additionalSteps(){}
    func saveItem(){
        print("save \(name) to inventory.\n")
    }
    final func craft(){
        checkMaterials()
        selectRecipe()
        craftItem()
        additionalSteps()
        saveItem()
    }
}

class JewelryCrafting:CraftingTemplate{
    var gem: String
    
    init(gem:String){
        self.gem = gem
        super.init(name: "ring", craftTime: 30)
    }
    override func selectRecipe(){
        print("recipe: ring with \(gem)")
    }
    override func craftItem(){
        print("craft \(name) with \(gem) take time \(craftTime) minute.")
    }
    override func additionalSteps(){
        print("add glitter [i told you we needed more glitter.]")
    }
}

class FoodCrafting:CraftingTemplate{
    var meat: String
    
    init(meat:String){
        self.meat = meat
        super.init(name: "steak", craftTime: 5)
    }
    override func selectRecipe(){
        print("recipe: \(meat) steak")
    }
    override func craftItem(){
        print("craft \(meat) \(name) take time \(craftTime) minute.")
    }
}

class ToolCrafting:CraftingTemplate{
    var material: String
    
    init(material:String){
        self.material = material
        super.init(name: "ax", craftTime: 20)
    }
    override func selectRecipe(){
        print("recipe: ax with \(material)")
    }
    override func craftItem(){
        print("craft \(name) with \(material) take time \(craftTime) minute.")
    }
}

let jewelry = JewelryCrafting(gem: "diamond")
let tool = ToolCrafting(material: "iron")
let food = FoodCrafting(meat: "chicken")

print("===Crafting Jewelry===")
jewelry.craft()

print("\n===Crafting Tool===")
tool.craft()

print("\n===Crafting Food===")
food.craft()