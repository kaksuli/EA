#property copyright "sulaiman kadkhodaei"
#property link      "mspk7492@gmail.com"
#property version   "1.00"
#property strict

#include <classes\Enumerators.mqh>

class ForexProfitSupreme{

private:
   int NOT_VALID_VALUE;
   string symbol;
   int timeFrame;
   bool enabled;
   int FastMA;
   int FastMAShift;
   int FastMAMethod;
   int FastMAPrice;
   int SlowMA;
   int SlowMAShift;
   int SlowMAMethod;
   int SlowMAPrice;
   
public:
   ForexProfitSupreme(string symbol, int timeFrame, bool enabled, int FastMA, int FastMAShift, int FastMAMethod, int FastMAPrice, int SlowMA, int SlowMAShift, int SlowMAMethod, int SlowMAPrice);
   ~ForexProfitSupreme();
   ForexProfitSupreme(){}
   double getValue(int mode, int shift);
   TRADE_TYPE getSignal();
   bool getEnabled();
   void copy(ForexProfitSupreme &forexProfitSupreme);
};
bool ForexProfitSupreme::getEnabled(){
   return enabled;
}

ForexProfitSupreme::ForexProfitSupreme(string s, int t, bool e, int fa, int ft, int fd, int fe, int sa, int st, int sd, int se){
   this.symbol = s;
   this.timeFrame = t;
   this.enabled = e;
   this.FastMA = fa;
   this.FastMAShift = ft;
   this.FastMAMethod = fd;
   this.FastMAPrice = fe;
   this.SlowMAShift = st;
   this.SlowMAMethod = sd;
   this.SlowMAPrice = se;
   NOT_VALID_VALUE = -10000;
}
void ForexProfitSupreme::copy(ForexProfitSupreme &forexProfitSupreme){
   this.symbol = forexProfitSupreme.symbol;
   this.timeFrame = forexProfitSupreme.timeFrame;
   this.enabled = forexProfitSupreme.enabled;
   this.FastMA = forexProfitSupreme.FastMA;
   this.FastMAShift = forexProfitSupreme.FastMAShift;
   this.FastMAMethod = forexProfitSupreme.FastMAMethod;
   this.FastMAPrice = forexProfitSupreme.FastMAPrice;
   this.SlowMAShift = forexProfitSupreme.SlowMAShift;
   this.SlowMAMethod = forexProfitSupreme.SlowMAMethod;
   this.SlowMAPrice = forexProfitSupreme.SlowMAPrice;
   NOT_VALID_VALUE = -10000;
}
ForexProfitSupreme::~ForexProfitSupreme(){}

double ForexProfitSupreme::getValue(int mode, int shift){
   if(!enabled){
      return NOT_VALID_VALUE;
   }
   
   return iCustom(symbol, timeFrame, "Forexprofitsupreme Signal(www.forexstrategy.ir)",
                  FastMA, FastMAShift, FastMAMethod, FastMAPrice,
                  SlowMA, SlowMAShift, SlowMAMethod, SlowMAPrice,
                  0, shift);
}

TRADE_TYPE ForexProfitSupreme::getSignal(){
   for(int i = 0; i < Bars;i++){
      double buy = getValue(0, i);
      double sell = getValue(1, i);
      
      if(sell == NOT_VALID_VALUE || buy == NOT_VALID_VALUE){
         return NONE;
      }
      
      if(sell != EMPTY_VALUE){
         return SELL;
      }
      if(buy != EMPTY_VALUE){
         return BUY;
      }
   }
   return NONE;
   
}