class NPC
    attr_reader :name
    
    def initialize(name)
        @name = name
    end
    
    def move_to(x, y)
        puts "#{@name} moves to (#{x}, #{y})"
    end
    
    def speak(text)
        puts "#{@name} says: \"#{text}\""
    end
    
    def hide
        puts "#{@name} disappears"
    end
end

class Command
    def execute
        raise NotImplementedError, "this method must be implement"
    end
end

class MoveCommand < Command
    def initialize(npc, x, y)
        @npc = npc
        @x = x
        @y = y
    end
    
    def execute
        @npc.move_to(@x, @y)
    end
end

class SpeakCommand < Command
    def initialize(npc, text)
        @npc = npc
        @text = text
    end
    
    def execute
        @npc.speak(@text)
    end
end

class HideCommand < Command
    def initialize(npc)
        @npc = npc
    end
    
    def execute
        @npc.hide
    end
end

class CutscenPlayer
    def initialize
        @queue = []
    end
    
    def setCommand(command)
        @queue << command
    end
    
    def executeCommand
        @queue.each do |cmd|
            cmd.execute
            puts "(Press Enter to continue..."
            STDIN.gets
        end
    end
end

npc1 = NPC.new("Alice Villager")
cutscen1 = CutscenPlayer.new

cutscen1.setCommand(MoveCommand.new(npc1, 10, 5))
cutscen1.setCommand(SpeakCommand.new(npc1, "Welcome, adventurer!"))
cutscen1.setCommand(MoveCommand.new(npc1, 0, 2))
cutscen1.setCommand(SpeakCommand.new(npc1, "Good luck on your journey!"))
cutscen1.executeCommand


puts "\n\n\n"
npc2 = NPC.new("Bob Villager")
cutscen2 = CutscenPlayer.new
cutscen2.setCommand(SpeakCommand.new(npc2, "Welcome, adventurer!"))
cutscen2.setCommand(MoveCommand.new(npc2, 0, 2))
cutscen2.setCommand(HideCommand.new(npc2))
cutscen2.executeCommand
        
        