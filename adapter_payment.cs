using System;
using System.Collections.Generic;

namespace AdapterPattern
{
    interface PaymentGateway
    {
        float tradeCoins();
    }

    class TrueMoneyAdapter : PaymentGateway
    {
        private TrueMoneyAPI api;

        public TrueMoneyAdapter(TrueMoneyAPI trueMoneyApi)
        {
            api = trueMoneyApi;
        }

        public float tradeCoins()
        {
            api.topUp();
            float baht = api.getAmount();
            float coins = baht/2.5f;
            return coins;
        }
    }

    class StripeAdapter : PaymentGateway
    {
        private StripeAPI api;

        public StripeAdapter(StripeAPI stripeApi)
        {
            api = stripeApi;
        }

        public float tradeCoins()
        {
            api.payUSD();
            float usd = api.getAmount();
            float baht = usd / 35.0f;
            float coins = baht/2.5f;
            return coins;
        }
    }
    
    class TrueMoneyAPI
    {
        private string phoneNumber;
        private float amountBaht;

        public TrueMoneyAPI(string phone, float baht)
        {
            phoneNumber = phone;
            amountBaht = baht;
        }

        public void topUp()
        {
            Console.WriteLine($"TrueMoney top up {amountBaht} baht with phone {phoneNumber}.");
        }
        
        public float getAmount()
        {
            return amountBaht;
        }
    }
    
    class StripeAPI
    {
        private string cardNumber;
        private float amountUsd;

        public StripeAPI(string card, float usd)
        {
            cardNumber = card;
            amountUsd = usd;
        }

        public void payUSD()
        {
            Console.WriteLine($"Stripe pay ${amountUsd} with card {cardNumber}.");
        }
        
        public float getAmount()
        {
            return amountUsd;
        }
    }

    class PlayerWallet
    {
        private string playerId;
        private int balance;
        
        public PlayerWallet(string id)
        {
            playerId = id;
            balance = 0;
        }
        
        public void setBalance(PaymentGateway payment)
        {
            float coins = payment.tradeCoins();
            balance += (int)coins;

            Console.WriteLine($"\nplayer id {playerId} trade coins");
            Console.WriteLine($"payment method : {payment.GetType().Name}");
            Console.WriteLine($"total balance : {balance} coins");
        }
    }

    class Program
    {
        static void Main()
        {
            PlayerWallet player01 = new PlayerWallet("player01");

            TrueMoneyAPI truemoneyApi = new TrueMoneyAPI("098-1234567", 500);
            StripeAPI stripeApi = new StripeAPI("1234-1234-1234-1234", 1500);

            player01.setBalance(new TrueMoneyAdapter(truemoneyApi));
            Console.WriteLine("\n\n");
            player01.setBalance(new StripeAdapter(stripeApi));

        }
    }
}