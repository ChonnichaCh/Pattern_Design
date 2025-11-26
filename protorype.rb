class ProductModel
    attr_accessor :name, :height, :radius, :material, :color, :label

    def initialize(name, height, radius, material, color, label)
        @name = name
        @height = height
        @radius = radius
        @material = material
        @color = color
        @label = label
    end

    def detail
        puts "Product: #{@name}"
        puts "Size: height=#{@height}cm, radius=#{@radius}cm"
        puts "Material: #{@material}"
        puts "Color: #{@color}"
        puts "Label: #{@label}"
        puts "-" * 30
    end
end

class CanPrototype < ProductModel
    attr_accessor :tabType
    
    def initialize(name: "Soda Can", height: 12, 
        radius: 3.5, material: "aluminum", color: "red", 
        label: "Cola Original", tabType: "pop-tab")
        super(name, height, radius, material, color, label)
        @tabType = tabType
    end
    
    def clone
        CanPrototype.new(
            name: @name.dup,
            height: @height.dup,
            radius: @radius.dup,
            material: @material.dup,
            color: @color.dup,
            label: @label.dup,
            tabType: @tabType.dup
        )
    end
end

class BottlePrototype < ProductModel
    attr_accessor :neckScale, :capType
    
    def initialize(name: "Water Bottle", height: 22, 
        radius: 4, material: "plastic", color: "clear", 
        label: "Spring Water", neckScale: "1:3", 
        capType: "screw cap")
        super(name, height, radius, material, color, label)
        @neckScale = neckScale
        @capType = capType
    end
    
    def clone
        BottlePrototype.new(
            name: @name.dup,
            height: @height.dup,
            radius: @radius.dup,
            material: @material.dup,
            color: @color.dup,
            label: @label.dup,
            neckScale: @neckScale.dup,
            capType: @capType.dup
        )
    end
end

def packing(prototype, n)
    temp = Array.new()
    for i in (0...n)
        temp.push(prototype.clone)
    end
    temp
end

def unpack(pack)
    puts "pack #{pack.length}"
    puts "=" * 30
    for product in pack do
        product.detail
    end
    puts "=" * 30
end

#can prototype
base_can = CanPrototype.new()
base_can.detail

# clone can
promo_can = base_can.clone
promo_can.label = "Cola - Limited Edition"
promo_can.height = 14
promo_can.material = "recycled aluminum"
promo_can.detail

# clone can
zero_can = base_can.clone
zero_can.label = "Cola Zero Sugar"
zero_can.detail

# bottle prototype
base_bottle = BottlePrototype.new()
base_bottle.detail

# clone bottle
small_bottle = base_bottle.clone
small_bottle.height = 15
small_bottle.label = "Spring Water - Kids Size"
small_bottle.detail

puts "\n\n\n"
pack = packing(base_can, 3)
unpack(pack)
