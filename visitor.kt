interface GameItem{
    fun accept(visitor: ItemVisitor)
}

class Sword(val name: String, var durability: Int, var attackPower: Int):GameItem{
    override fun accept(visitor: ItemVisitor){
        visitor.visit(this)
    }
}

class Shield(val name: String, var durability: Int, var defensePower: Int):GameItem{
    override fun accept(visitor: ItemVisitor){
        visitor.visit(this)
    }
}

interface ItemVisitor{
    fun visit(sword: Sword)
    fun visit(shield: Shield)
}

class WearAndTear(var wearRate: Int): ItemVisitor{
    override fun visit(sword: Sword){
        sword.durability -= this.wearRate
        sword.attackPower -= 1
        println("===Wear Sword===")
        println("${sword.name} (durability: ${sword.durability}, attack: ${sword.attackPower})\n")
    }
    
    override fun visit(shield: Shield){
        shield.durability -= this.wearRate
        shield.defensePower -= 1
        println("===Wear Shield===")
        println("${shield.name} (durability: ${shield.durability}, defense: ${shield.defensePower})\n")
    }
}

class Repair(var repairRate: Int): ItemVisitor{
    override fun visit(sword: Sword){
        sword.durability += this.repairRate
        sword.attackPower += 1
        println("===Repair Sword===")
        println("${sword.name} (durability: ${sword.durability}, attack: ${sword.attackPower})\n")
    }
    
    override fun visit(shield: Shield){
        shield.durability += this.repairRate
        shield.defensePower += 1
        println("===Repair Sword===")
        println("${shield.name} (durability: ${shield.durability}, defense: ${shield.defensePower})\n")
    }
}

fun main(){
    val sword1 = Sword("Iron Sword", 100, 50)
    val sword2 = Sword("Copper Sword", 100, 50)
    val sword3 = Sword("Stone Sword", 100, 50)
    val shield = Shield("Copper Shield", 100, 30)
    val wear = WearAndTear(10)
    val repair = Repair(10)
    
    val items = arrayOf(sword1, sword2, sword3, shield)
    for (item in items) {
       item.accept(wear)
    }
    
    sword3.accept(wear)
    
    for (item in items) {
        item.accept(repair)
    }
    
}

