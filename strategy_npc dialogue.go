package main
import(
    "fmt"
)

type NPC struct{
    name string
    strategy DialogueStrategy
}
func (npc *NPC) setDialogue(strategy DialogueStrategy){
    npc.strategy = strategy
}
func (npc *NPC) talk(){
    if npc.strategy != nil{
        npc.strategy.speak(npc.name)
    }else{
        fmt.Println("npc silent...")
    }
}

type DialogueStrategy interface{
    speak(npcName string)
}

type Greet struct{
    stance string
}
func(g *Greet) speak(npcName string){
    switch g.stance{
        case "pleased": fmt.Printf("%s: \"Hello~ Welcome.\"\n", npcName)
        case "displeased": fmt.Printf("%s: \"...\"\n", npcName)
        default: fmt.Printf("%s: \"Hello.\"\n", npcName)
    }
}

type Chat struct{
    mood string
}
func (c *Chat) speak(npcName string){
    switch c.mood{
        case "happy": fmt.Printf("%s: \"Look at the flower~\"\n", npcName)
        case "upset": fmt.Printf("%s: \"Don't step on the flowers!\"\n", npcName)
        default: fmt.Printf("%s: \"The weather is nice today.\"\n", npcName)
    }
}

type Farewell struct{
    gift string
}
func (c *Farewell) speak(npcName string){
    fmt.Printf("%s: \"Gives you a %s.\"\n", npcName, c.gift)
    fmt.Printf("%s: \"May the odds be ever in your favour.\"\n", npcName)
}

type Surprised struct{
    event string
}
func (c *Surprised) speak(npcName string){
    switch c.event{
        case "something strange": fmt.Printf("%s: \"What the What!\"\n", npcName)
        case "accident": fmt.Printf("%s: \"Look out!\"\n", npcName)
        default: fmt.Printf("%s: \"Nah ah...\"\n", npcName)
    }
}


func main(){
    npc := &NPC{name: "Alic"}
    
    fmt.Println("=== First Meet (pleased) ===")
    npc.setDialogue(&Greet{stance: "pleased"})
    npc.talk()
    fmt.Println("\n=== First Meet (displeased) ===")
    npc.setDialogue(&Greet{stance: "displeased"})
    npc.talk()
    fmt.Println("\n=== First Meet (..) ===")
    npc.setDialogue(&Greet{stance: ".."})
    npc.talk()
    
    
    fmt.Println("\n\n=== Chatting (upset) ===")
    npc.setDialogue(&Chat{mood: "upset"})
    npc.talk()
    fmt.Println("\n=== Chatting (happy) ===")
    npc.setDialogue(&Chat{mood: "happy"})
    npc.talk()
    fmt.Println("\n=== Chatting (..) ===")
    npc.setDialogue(&Chat{mood: ".."})
    npc.talk()
    
    fmt.Println("\n\n=== Say Goodbye (fruit) ===")
    npc.setDialogue(&Farewell{gift: "fruit"})
    npc.talk()
    fmt.Println("\n=== Say Goodbye (flowers) ===")
    npc.setDialogue(&Farewell{gift: "flowers"})
    npc.talk()
    fmt.Println("\n=== Say Goodbye (..) ===")
    npc.setDialogue(&Farewell{gift: ".."})
    npc.talk()
    
    
    fmt.Println("\n\n=== Unexpected Events (something strange) ===")
    npc.setDialogue(&Surprised{event: "something strange"})
    npc.talk()
    fmt.Println("\n=== Unexpected Events (accident) ===")
    npc.setDialogue(&Surprised{event: "accident"})
    npc.talk()
    fmt.Println("\n=== Unexpected Events (..)===")
    npc.setDialogue(&Surprised{event: ".."})
    npc.talk()
}