#property copyright "sulaiman kadkhodaei"
#property link      "mspk7492@gmail.com"
#property version   "1.00"
#property strict
#include <classes\Quote.mqh>

class QuoteGroup{

private:
   string symbol;
   
public:
   QuoteGroup(string symbol);
   ~QuoteGroup();
   QuoteGroup(){}
   Quote quote[1000000];
   int quoteSize;
   
   void gatherAllQoutesByPackType(int packType);
   void gatherExsitedPacksByPackType(int packType);
   void gatherUniquePacks();
   bool isQuoteExist(Quote &q);
   bool hasUpperPackType(Quote &q);
   bool isSwitchPlaced(int tradeType);
   
   int getLastPackNoByQuote(Quote &q);
   int getLastPackNoByTradeTypeAndPackType(int tradeType, int packType);
   
   int getLastTradeNo(Quote &q);
   double getOpenPriceLastTicket(Quote &q);
   double getOpenPriceFirstTicket(Quote &q);
   void copy(QuoteGroup &q);
};

QuoteGroup::QuoteGroup(string s){
   this.symbol = s;
   quoteSize = 0;
}

void QuoteGroup::copy(QuoteGroup &q){
   this.symbol = q.symbol;
   quoteSize = q.quoteSize;
}
QuoteGroup::~QuoteGroup(){}

int QuoteGroup::getLastPackNoByTradeTypeAndPackType(int tradeType, int packType){
   Quote q;
   q.tradeType = tradeType;
   q.packType = packType;
   return getLastPackNoByQuote(q);
}

bool QuoteGroup::hasUpperPackType(Quote &q){
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      bool temp = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      string orderComment = OrderComment();
      if(StringGetChar(orderComment, 0) != StringGetChar("@", 0)){
         continue;
      }
      if(OrderSymbol() != symbol){
         continue;
      }
      
      if(q.tradeType != QuoteEncodeDecode().getTradeType(orderComment) && q.packType + 1 == QuoteEncodeDecode().getPackType(orderComment) && q.packNo == QuoteEncodeDecode().getPackNo(orderComment)){
         return true;
      }
   }
   return false;
}

int QuoteGroup::getLastPackNoByQuote(Quote &q){
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      bool temp = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      string orderComment = OrderComment();
      if(StringGetChar(orderComment, 0) != StringGetChar("@", 0)){
         continue;
      }
      if(OrderSymbol() != symbol){
         continue;
      }
      if(QuoteEncodeDecode().getTradeType(orderComment) == q.tradeType && QuoteEncodeDecode().getPackType(orderComment) == q.packType){
         return QuoteEncodeDecode().getPackNo(orderComment);
      }
   }
   
   return 0;
}

void QuoteGroup::gatherAllQoutesByPackType(int packType){
   for(int i = OrdersTotal() - 1; i >= 0; i--){
   
      bool temp = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      string orderComment = OrderComment();
      if(StringGetChar(orderComment, 0) != StringGetChar("@", 0)){
         continue;
      }
      if(OrderSymbol() != symbol || QuoteEncodeDecode().getPackType(orderComment) != packType){
         continue;
      }
      
      quote[quoteSize].tradeType = QuoteEncodeDecode().getTradeType(orderComment);
      quote[quoteSize].tradeNo = QuoteEncodeDecode().getTradeNo(orderComment);
      quote[quoteSize].packType = packType;
      quote[quoteSize].packNo = QuoteEncodeDecode().getPackNo(orderComment);
      quoteSize++;
   }
}

bool QuoteGroup::isQuoteExist(Quote &q){
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      bool temp = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      string orderComment = OrderComment();
      if(StringGetChar(orderComment, 0) != StringGetChar("@", 0)){
         continue;
      }
      if(OrderSymbol() != symbol){
         continue;
      }
      if(QuoteEncodeDecode().getTradeType(orderComment) == q.tradeType
          && QuoteEncodeDecode().getTradeNo(orderComment) == q.tradeNo
           && QuoteEncodeDecode().getPackType(orderComment) == q.packType
            && QuoteEncodeDecode().getPackNo(orderComment) == q.packNo){
         return true;
      }
   }
   
   return false;
}

bool QuoteGroup::isSwitchPlaced(int tradeType){
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      bool temp = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      string orderComment = OrderComment();
      if(StringGetChar(orderComment, 0) != StringGetChar("@", 0)){
         continue;
      }
      if(OrderSymbol() != symbol){
         continue;
      }
      
      if(QuoteEncodeDecode().getTradeType(orderComment) != tradeType && QuoteEncodeDecode().getPackType(orderComment) == SWITCH1){
         return true;
      }
      
      if(QuoteEncodeDecode().getTradeType(orderComment) == tradeType && QuoteEncodeDecode().getPackType(orderComment) == REGULAR){
         return false;
      }
   }
   
   return true;
}

int QuoteGroup::getLastTradeNo(Quote &q){
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      bool temp = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      
      string orderComment = OrderComment();
      if(StringGetChar(orderComment, 0) != StringGetChar("@", 0)){
         continue;
      }
      if(OrderSymbol() != symbol){
         continue;
      }
      if(q.tradeType == QuoteEncodeDecode().getTradeType(orderComment) && q.packType == QuoteEncodeDecode().getPackType(orderComment) && q.packNo == QuoteEncodeDecode().getPackNo(orderComment)){
         return QuoteEncodeDecode().getTradeNo(orderComment);
      }
   }
   return 0;
}

double QuoteGroup::getOpenPriceLastTicket(Quote &q){
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      bool temp = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      
      string orderComment = OrderComment();
      if(StringGetChar(orderComment, 0) != StringGetChar("@", 0)){
         continue;
      }
      if(OrderSymbol() != symbol){
         continue;
      }
      if(q.tradeType == QuoteEncodeDecode().getTradeType(orderComment) && q.packType == QuoteEncodeDecode().getPackType(orderComment) && q.packNo == QuoteEncodeDecode().getPackNo(orderComment)){
         return OrderOpenPrice();
      }
   }
   return 0;
}

double QuoteGroup::getOpenPriceFirstTicket(Quote &q){
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      bool temp = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      
      string orderComment = OrderComment();
      if(StringGetChar(orderComment, 0) != StringGetChar("@", 0)){
         continue;
      }
      if(OrderSymbol() != symbol){
         continue;
      }
      if(QuoteEncodeDecode().getTradeNo(orderComment) == 1 && q.tradeType == QuoteEncodeDecode().getTradeType(orderComment) && q.packType == QuoteEncodeDecode().getPackType(orderComment) && q.packNo == QuoteEncodeDecode().getPackNo(orderComment)){
         return OrderOpenPrice();
      }
   }
   return 0;
}

void QuoteGroup::gatherExsitedPacksByPackType(int packType){
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      bool temp = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      string orderComment = OrderComment();
      if(StringGetChar(orderComment, 0) != StringGetChar("@", 0)){
         continue;
      }
      if(OrderSymbol() != symbol || QuoteEncodeDecode().getPackType(orderComment) != packType){
         continue;
      }
      
      bool isHasBeenSearched = false;
      int tradeType = QuoteEncodeDecode().getTradeType(orderComment);
      int packNo = QuoteEncodeDecode().getPackNo(orderComment);
      
      for(int iterator = 0; iterator < quoteSize; iterator++){
         if(quote[iterator].tradeType == tradeType && quote[iterator].packNo == packNo){
            isHasBeenSearched = true;
            break;
         }
      }
      
      if(isHasBeenSearched){
         continue;
      }
      
      quote[quoteSize].tradeType = tradeType;
      quote[quoteSize].tradeNo = QuoteEncodeDecode().getTradeNo(orderComment);
      quote[quoteSize].packType = packType;
      quote[quoteSize].packNo = packNo;
      quoteSize++;
   }
}

void QuoteGroup::gatherUniquePacks(){
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      bool temp = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      string orderComment = OrderComment();
      if(StringGetChar(orderComment, 0) != StringGetChar("@", 0)){
         continue;
      }
      if(OrderSymbol() != symbol){
         continue;
      }
      
      bool isHasBeenSearched = false;
      int tradeType = QuoteEncodeDecode().getTradeType(orderComment);
      int packType = QuoteEncodeDecode().getPackType(orderComment);
      int packNo = QuoteEncodeDecode().getPackNo(orderComment);
      
      for(int iterator = 0; iterator < quoteSize; iterator++){
            
         if(quote[iterator].tradeType == tradeType && quote[iterator].packType == packType && quote[iterator].packNo == packNo){
            isHasBeenSearched = true;
            break;
         }
      }
      
      if(isHasBeenSearched){
         continue;
      }
      
      quote[quoteSize].tradeType = tradeType;
      quote[quoteSize].tradeNo = QuoteEncodeDecode().getTradeNo(orderComment);
      quote[quoteSize].packType = packType;
      quote[quoteSize].packNo = packNo;
      quoteSize++;
   }
}
