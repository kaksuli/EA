#property copyright "sulaiman kadkhodaei"
#property link      "mspk7492@gmail.com"
#property version   "1.00"
#property strict
#include <classes\QuoteEncodeDecode.mqh>
#include <classes\Enumerators.mqh>

class Quote{
private:

public:
   int tradeType;
   int tradeNo;
   int packType;
   int packNo;
   Quote();
   ~Quote();
   string toString();
   string getCode();
};
Quote::Quote(){}
Quote::~Quote(){}


string Quote::toString(){
   string result = "";
   
   if(tradeType == BUY){
      result = StringConcatenate("(BUY : ", tradeNo, ", ");
   }else{
      result = StringConcatenate("(SELL : ", tradeNo, ", ");
   }
   
   return StringConcatenate(result, "SWITCH", packType, " : ", packNo, ")");
}

string Quote::getCode(){
   string result = "";
   
   if(tradeType == BUY){
      result = StringConcatenate("(BUY : ", tradeNo, ", ");
   }else{
      result = StringConcatenate("(SELL : ", tradeNo, ", ");
   }
   
   return StringConcatenate("(", tradeType, tradeNo, packType, packNo, ")");
}
