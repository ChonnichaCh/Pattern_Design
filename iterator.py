from abc import ABC, abstractmethod

class Item(ABC):
    def __init__(self, rarity, name):
        self.name = name
        self.rarity = rarity

    def get_rarity(self):
        return self.rarity
    
    def get_name(self):
        return self.name

    @abstractmethod
    def get_type(self)->str:
        pass

        
class Weapon(Item):
    def __init__(self, rarity, name, level):
        super().__init__(rarity, name)
        self.level = level
        
    def get_type(self):
        return "weapon"
        
    def get_level(self):
        return self.level
        
        
class Potion(Item):
    def __init__(self, rarity, name, size):
        super().__init__(rarity, name)
        self.size = size
        
    def get_type(self):
        return "potion"
        
    def get_size(self):
        return self.size
        
class ItemIterator(ABC):
    @abstractmethod
    def has_next(self)->bool:
        pass
        
    @abstractmethod
    def get_next(self)->Item:
        pass
        
class Inventory:
    def __init__(self):
        self.items: list[Item] = []
        
    def add(self, item: Item):
        self.items.append(item)
        
    def all_items_iterator(self)->ItemIterator:
        return AllItemsIterator(self.items)
        
    def weapons_iterator(self)->ItemIterator:
        return WeaponFilteredIterator(self.items)
        
    def potions_iterator(self)->ItemIterator:
        return PotionFilteredIterator(self.items)
    
    def rare_iterator(self)->ItemIterator:
        return RareItemsIterator(self.items)
    
    def common_iterator(self)->ItemIterator:
        return CommonItemsIterator(self.items)
        
class AllItemsIterator(ItemIterator):
    def __init__(self, items: list[Item]):
        self.items = items
        self.index = 0
        
    def has_next(self)->bool:
        return self.index<len(self.items)
        
    def get_next(self)->Item:
        item = self.items[self.index]
        self.index += 1
        return item
        
class WeaponFilteredIterator(ItemIterator):
    def __init__(self, items: list[Item]):
        self.items = items
        self.index = 0
        
    def has_next(self)->bool:
        while self.index < len(self.items) and self.items[self.index].get_type() != "weapon":
            self.index += 1
        return self.index < len(self.items)
        
    def get_next(self)->Item:
        item = self.items[self.index]
        self.index += 1
        return item
    
class PotionFilteredIterator(ItemIterator):
    def __init__(self, items: list[Item]):
        self.items = items
        self.index = 0
        
    def has_next(self)->bool:
        while self.index < len(self.items) and self.items[self.index].get_type() != "potion":
            self.index += 1
        return self.index < len(self.items)
        
    def get_next(self)->Item:
        item = self.items[self.index]
        self.index += 1
        return item
    
class RareItemsIterator(ItemIterator):
    def __init__(self, items: list[Item]):
        self.items = items
        self.index = 0
        
    def has_next(self)->bool:
        while self.index < len(self.items) and self.items[self.index].get_rarity() != "rare":
            self.index += 1
        return self.index < len(self.items)
        
    def get_next(self)->Item:
        item = self.items[self.index]
        self.index += 1
        return item
    
class CommonItemsIterator(ItemIterator):
    def __init__(self, items: list[Item]):
        self.items = items
        self.index = 0
        
    def has_next(self)->bool:
        while self.index < len(self.items) and self.items[self.index].get_rarity() != "common":
            self.index += 1
        return self.index < len(self.items)
        
    def get_next(self)->Item:
        item = self.items[self.index]
        self.index += 1
        return item

def print_items(title: str, iterator: ItemIterator):
    print(f"==={title}===")
    while iterator.has_next():
        item = iterator.get_next()
        if item.get_type() == "weapon":
            print(f" - type: {item.get_type()}, rarity: {item.get_rarity()}, name: {item.get_name()}, level: {item.get_level()}")
        else:
            if(item.get_type() == "potion"):
                print(f" - type: {item.get_type()}, rarity: {item.get_rarity()}, name: {item.get_name()}, size: {item.get_size()}")
    print()
    
    
if __name__=="__main__":
    inventory = Inventory()
    
    inventory.add(Weapon("rare", "Iron Sword", 5))
    inventory.add(Potion("common", "Healing Potion", "small"))
    inventory.add(Weapon("common", "Silver Axe", 2))
    inventory.add(Potion("rare", "Mana Elixir", "large"))
    
    print_items("All Items", inventory.all_items_iterator())
    print_items("Weapon Filtered", inventory.weapons_iterator())
    print_items("Potion Filtered", inventory.potions_iterator())
    print_items("Rare Items", inventory.rare_iterator())
    print_items("Common Items", inventory.common_iterator())
        
        