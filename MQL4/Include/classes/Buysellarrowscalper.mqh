#property copyright "sulaiman kadkhodaei"
#property link      "mspk7492@gmail.com"
#property version   "1.00"
#property strict

#include <classes\Enumerators.mqh>

class Buysellarrowscalper{

private:
   int NOT_VALID_VALUE;
   string symbol;
   int timeFrame;
   bool enabled;
   int Amplitude;
   
public:
   Buysellarrowscalper(string symbol, int timeFrame, bool enabled, int Amplitude);
   Buysellarrowscalper(){}
   ~Buysellarrowscalper();
   TRADE_TYPE getSignal();
   double getValue(int mode, int shift);
   bool getEnabled();
   void copy(Buysellarrowscalper &buysellarrowscalper);
};
bool Buysellarrowscalper::getEnabled(){
   return enabled;
}

Buysellarrowscalper::Buysellarrowscalper(string s, int t, bool e, int a){
   this.symbol = s;
   this.timeFrame = t;
   this.enabled = e;
   this.Amplitude = a;
   NOT_VALID_VALUE = -100;
}

void Buysellarrowscalper::copy(Buysellarrowscalper &buysellarrowscalper){
   this.symbol = buysellarrowscalper.symbol;
   this.timeFrame = buysellarrowscalper.timeFrame;
   this.enabled = buysellarrowscalper.enabled;
   this.Amplitude = buysellarrowscalper.Amplitude;
   NOT_VALID_VALUE = -100;
}
Buysellarrowscalper::~Buysellarrowscalper(){}

double Buysellarrowscalper::getValue(int mode, int shift){
   if(!enabled){
      return NOT_VALID_VALUE;
   }
   
   return iCustom(symbol, timeFrame, "buysellarrowscalper", Amplitude, mode, shift);
}

TRADE_TYPE Buysellarrowscalper::getSignal(){

   double buy = getValue(0, 0);
   double sell = getValue(1, 0);
   
   if(sell == NOT_VALID_VALUE || buy == NOT_VALID_VALUE){
      return NONE;
   }
   
   if(sell != 0 && buy != 0){
      return NONE;
   }
   
   if(sell != 0){
      return SELL;
   }
   if(buy != 0){
      return BUY;
   }
   
   return NONE;
}