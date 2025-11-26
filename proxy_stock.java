import java.util.HashMap;
import java.util.Map;

interface OrderService {
    void order(String productId, int quantity);
}

class RealOrderService implements OrderService {
    private Map<String, Integer> stockDB;
    
    public RealOrderService(Map<String, Integer> stockDB){
        this.stockDB = stockDB;
    }
    
    @Override
    public void order(String productId, int quantity){
        stockDB.put(productId, stockDB.get(productId) - quantity);
        System.out.println("order : product " + productId + " | " + quantity + " ea" + "\n");
    }
    
    public int getStock(String productId){
        System.out.println("product " + productId + " in stock " + stockDB.get(productId) + " ea");
        return stockDB.get(productId);
    }
}

class StockCheckingProxy implements OrderService {
    private RealOrderService realOrderService;
    
    public StockCheckingProxy(RealOrderService realOrderService){
        this.realOrderService = realOrderService;
    }
    
    @Override
    public void order(String productId, int quantity){
        if(realOrderService.getStock(productId) >= quantity){
            realOrderService.order(productId, quantity);
        }else{
            System.out.println("not enough stock for product " + productId + " | " + quantity + " ea" + "\n");
        }
    }
}

public class Main {
    public static void main(String[] args){
        Map<String,Integer> stockDB = new HashMap<>();
        stockDB.put("001", 50);
        stockDB.put("002", 20);
        
        RealOrderService realOrderService = new RealOrderService(stockDB);
        StockCheckingProxy proxy = new StockCheckingProxy(realOrderService);
        
        proxy.order("001", 20);
        proxy.order("001", 50);
        proxy.order("001", 30);
        proxy.order("002", 20);
        proxy.order("002", 1);
    }
}