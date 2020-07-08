#property copyright "sulaiman kadkhodaei"
#property link      "mspk7492@gmail.com"
#property version   "1.00"
#property strict

#include <classes\QuoteEncodeDecode.mqh>

class Order{
private:
   string symbol;
   int timeFrame;
   int slippage;
public:
   Order(string symbol, int timeFrame, int slippage);
   Order(){}
   ~Order();
   void close(int tradeType, int tradeNo, int packType, int packNo);
   double getProfit(int tradeType, int tradeNo, int packType, int packNo);
   double getCurrentPrice();
   bool placeOrder(int cmd, int magic, double lot, string comment, color clr);
   void copy(Order &order);
};

Order::Order(string s, int t, int sl){
   this.symbol = s;
   this.timeFrame = t;
   this.slippage = sl;
}
void Order::copy(Order &right){
   this.symbol = right.symbol;
   this.timeFrame = right.timeFrame;
   this.slippage = right.slippage;
}

Order::~Order(){}

double Order::getCurrentPrice(){
   return iClose(symbol, timeFrame, 0);
}

bool Order::placeOrder(int cmd, int magic, double lot, string comment, color clr){
   if(lot <= 0){
      Print(comment + " lot is 0");
      return false;
   }
   return OrderSend(symbol, cmd, lot, cmd == OP_BUY ? Ask : Bid, slippage, 0, 0, comment, magic, 0, clr) > 0;
}

void Order::close(int tradeType, int tradeNo, int packType, int packNo){
   for (int i = OrdersTotal() - 1;i >= 0 ;i--){
      bool temp = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      
      string orderComment = OrderComment();
      if(StringGetChar(orderComment, 0) != StringGetChar("@", 0)){
         continue;
      }
      int orderTradeType = QuoteEncodeDecode().getTradeType(orderComment);
      int orderTradeNo = QuoteEncodeDecode().getTradeNo(orderComment);
      int orderPackType = QuoteEncodeDecode().getPackType(orderComment);
      int orderPackNo = QuoteEncodeDecode().getPackNo(orderComment);
      
      if(   OrderSymbol() != symbol ||
            orderTradeType != tradeType || 
            (tradeNo != -1 && orderTradeNo != tradeNo) || 
            orderPackType != packType || 
            orderPackNo != packNo){
         continue;
      }
      
      temp = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), OrderType() == OP_BUY ? MODE_BID : MODE_ASK), slippage, Violet); 
   }
}

double Order::getProfit(int tradeType, int tradeNo, int packType, int packNo){
   double profit = 0;
   
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      bool temp = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      
      string orderComment = OrderComment();
      if(StringGetChar(orderComment, 0) != StringGetChar("@", 0)){
         continue;
      }
      int orderTradeType = QuoteEncodeDecode().getTradeType(orderComment);
      int orderTradeNo = QuoteEncodeDecode().getTradeNo(orderComment);
      int orderPackType = QuoteEncodeDecode().getPackType(orderComment);
      int orderPackNo = QuoteEncodeDecode().getPackNo(orderComment);
      
      if(   OrderSymbol() != symbol ||
            orderTradeType != tradeType || 
            (tradeNo != -1 && orderTradeNo != tradeNo) || 
            orderPackType != packType || 
            orderPackNo != packNo){
         continue;
      }
      
      profit += OrderProfit() + OrderCommission(); 
   }
   return profit;
}