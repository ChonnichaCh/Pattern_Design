<?php

interface Handler {
    public function setNext(Handler $handler);
    public function handle(array $products);
}

abstract class ProductFilter implements Handler {
    protected $nextHandler = null;
    
    public function setNext(Handler $handler) {
        $this->nextHandler = $handler;
        return $handler;
    }
    
    public function handle(array $products){
        if($this->nextHandler !== null){
            return $this->nextHandler->handle($products);
        }
        return $products;
    }
}

class CategoryFilter extends ProductFilter {
    private $category;
    
    public function __construct($category){
        $this->category = $category;
    }
    
    public function handle(array $products){
        $filtered = array_filter($products, function($p){
            return $p["category"] === $this->category;
        });
        return parent::handle($filtered);
    }
    
    public function getCategory(){
        return $this->category;
    }
}

class PriceFilter extends ProductFilter {
    private $min;
    private $max;
    
    public function __construct($min, $max){
        $this->min = $min;
        $this->max = $max;
    }
    
    public function handle(array $products){
        $filtered = array_filter($products, function($p){
            return $p["price"] >= $this->min && $p["price"] <= $this->max;
        });
        return parent::handle($filtered);
    }
    
    public function getMin(){
        return $this->min;
    }
    
    public function getMax(){
        return $this->max;
    }
}

class StockFilter extends ProductFilter {
    public function handle(array $products){
        $filtered = array_filter($products, function ($p){
            return $p["stock"]>0;
        });
        return parent::handle($filtered);
    }
}

$products = [
    ['name' => 'Laptop', 'category' => 'electronics', 'price' => 1200, 'stock' => 5],
    ['name' => 'Mouse', 'category' => 'electronics', 'price' => 20, 'stock' => 0],
    ['name' => 'Shirt', 'category' => 'clothing', 'price' => 30, 'stock' => 10],
    ['name' => 'Headphones', 'category' => 'electronics', 'price' => 80, 'stock' => 15],
    ['name' => 'Shoes', 'category' => 'clothing', 'price' => 50, 'stock' => 2],
];

echo "all products:\n";
foreach ($products as $p){
    echo " - {$p['name']} ({$p['price']} USD, stock: {$p['stock']})\n";
}

$category = new CategoryFilter("electronics");
$price = new PriceFilter(50, 2000);
$stock = new StockFilter();

$category->setNext($price)->setNext($stock);

$result = $category->handle($products);

echo "\n\nproducts(filter by category: {$category->getCategory()}, price: {$price->getMin()} - {$price->getMax()}):\n";
foreach ($result as $r){
    echo " - {$r['name']} ({$r['price']} USD, stock: {$r['stock']})\n";
}


$category = new CategoryFilter("clothing");
$price = new PriceFilter(50, 100);

$price->setNext($category)->setNext($stock);

$result = $price->handle($products);

echo "\n\nproducts(filter by category: {$category->getCategory()}, price: {$price->getMin()} - {$price->getMax()}):\n";
foreach ($result as $r){
    echo " - {$r['name']} ({$r['price']} USD, stock: {$r['stock']})\n";
}


$category = new CategoryFilter("jewelry");
$price = new PriceFilter(100, 200);

$result = $category->handle($products);

$result = $category->handle($products);

echo "\n\nproducts(filter by category: {$category->getCategory()}, price: {$price->getMin()} - {$price->getMax()}):\n";
foreach ($result as $r){
    echo " - {$r['name']} ({$r['price']} USD, stock: {$r['stock']})\n";
}

?>