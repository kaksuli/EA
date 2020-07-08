#property copyright "sulaiman kadkhodaei"
#property link      "mspk7492@gmail.com"
#property version   "1.00"
#property strict

#include <classes\Enumerators.mqh>

class RSI{

private:
   int NOT_VALID_VALUE;
   string symbol;
   int timeFrame;
   bool enabled;
   int highSellRSI;
   int lowSellRSI;
   int highBuyRSI;
   int lowBuyRSI;
   ENUM_APPLIED_PRICE RSIPeriodAppliedPrice;
   int RSIPeriod;
   int RSIShift;
   
public:
   RSI(string symbol, int timeFrame, bool enabled, int highSellRSI, int lowSellRSI, int highBuyRSI, int lowBuyRSI, ENUM_APPLIED_PRICE RSIPeriodAppliedPrice, int RSIPeriod, int RSIShift);
   ~RSI();
   RSI(){}
   double getValue();
   TRADE_TYPE getSignal();
   bool getEnabled();
   void copy(RSI &rsi);
};

bool RSI::getEnabled(){
   return enabled;
}
RSI::RSI(string s, int t, bool e, int hs, int ls, int hb, int lb, ENUM_APPLIED_PRICE re, int rd, int rt){
   this.symbol = s;
   this.timeFrame = t;
   this.enabled = e;
   this.highSellRSI = hs;
   this.lowSellRSI = ls;
   this.highBuyRSI = hb;
   this.lowBuyRSI = lb;
   this.RSIPeriodAppliedPrice = re;
   this.RSIPeriod = rd;
   this.RSIShift = rt;
   NOT_VALID_VALUE = -100000;
}

void RSI::copy(RSI &rsi){
   this.symbol = rsi.symbol;
   this.timeFrame = rsi.timeFrame;
   this.enabled = rsi.enabled;
   this.highSellRSI = rsi.highSellRSI;
   this.lowSellRSI = rsi.lowSellRSI;
   this.highBuyRSI = rsi.highBuyRSI;
   this.lowBuyRSI = rsi.lowBuyRSI;
   this.RSIPeriodAppliedPrice = rsi.RSIPeriodAppliedPrice;
   this.RSIPeriod = rsi.RSIPeriod;
   this.RSIShift = rsi.RSIShift;
   NOT_VALID_VALUE = -100000;
}
RSI::~RSI(){}

double RSI::getValue(){
   if(!enabled){
      return NOT_VALID_VALUE;
   }
   
   return iRSI(symbol, timeFrame, RSIPeriod, RSIPeriodAppliedPrice, RSIShift);
}

TRADE_TYPE RSI::getSignal(){

   double rsi = getValue();
   
   if(rsi == NOT_VALID_VALUE){
      return NONE;
   }
   
   if(rsi >= lowSellRSI && rsi <= highSellRSI && rsi >= lowBuyRSI && rsi <= highBuyRSI){
      return BOTH;
   }
   
   if(rsi >= lowBuyRSI && rsi <= highBuyRSI){
      return BUY;
   }
   
   if(rsi >= lowSellRSI && rsi <= highSellRSI){
      return SELL;
   }
   
   return NONE;
   
}