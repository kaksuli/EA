#property copyright "sulaiman kadkhodaei"
#property link      "mspk7492@gmail.com"
#property version   "1.00"
#property strict

#include <classes\Enumerators.mqh>
#include <classes\Order.mqh>

class PriceBorder{

private:
   int NOT_VALID_VALUE;
   string symbol;
   int timeFrame;
   bool enabled;
   string TimeFrame;
   int HalfLength;
   int Price;
   double ATRMultiplier;
   int ATRPeriod;
   bool Interpolate;
   int allowed;
   double point;
   int slippage;
   
public:
   PriceBorder(string symbol, int timeFrame, int slippage, double point, bool enabled, string TimeFrame, int HalfLength, int Price, double ATRMultiplier, int ATRPeriod, bool Interpolate, int allowed);
   ~PriceBorder();
   PriceBorder(){}
   TRADE_TYPE getSignal();
   double getValue(int mode, int shift);
   bool getEnabled();
   void copy(PriceBorder &priceBorder);
};
bool PriceBorder::getEnabled(){
   return enabled;
}

void PriceBorder::copy(PriceBorder &priceBorder){
   this.symbol = priceBorder.symbol;
   this.timeFrame = priceBorder.timeFrame;
   this.enabled = priceBorder.enabled;
   this.TimeFrame = priceBorder.TimeFrame;
   this.HalfLength = priceBorder.HalfLength;
   this.Price = priceBorder.Price;
   this.ATRMultiplier = priceBorder.ATRMultiplier;
   this.ATRPeriod = priceBorder.ATRPeriod;
   this.Interpolate = priceBorder.Interpolate;
   this.allowed = priceBorder.allowed;
   this.point = priceBorder.point;
   this.slippage = priceBorder.slippage;
   NOT_VALID_VALUE = -100;
}

PriceBorder::PriceBorder(string s, int t, int sl, double p, bool e, string te, int h, int pe, double ar, int ad, bool ie, int al){
   this.symbol = s;
   this.timeFrame = t;
   this.slippage = sl;
   this.point = p;
   this.enabled = e;
   this.TimeFrame = te;
   this.HalfLength = h;
   this.Price = pe;
   this.ATRMultiplier = ar;
   this.ATRPeriod = ad;
   this.Interpolate = ie;
   this.allowed = al;
   NOT_VALID_VALUE = -100;
}
PriceBorder::~PriceBorder(){}

double PriceBorder::getValue(int mode, int shift){
   if(!enabled){
      return NOT_VALID_VALUE;
   }
   
   return iCustom(symbol, timeFrame, "Price Border", TimeFrame, HalfLength, Price, ATRMultiplier, ATRPeriod, Interpolate, mode - 1, shift);
}

TRADE_TYPE PriceBorder::getSignal(){
   double up = getValue(2, 0);
   double down = getValue(3, 0);
   
   if(up == NOT_VALID_VALUE || down == NOT_VALID_VALUE){
      return NONE;
   }
   
   Order order1(symbol, timeFrame, slippage);
   if(order1.getCurrentPrice() - (allowed*point) >= up){
      return SELL;
   }
   if(order1.getCurrentPrice() + (allowed*point) <= down){
      return BUY;
   }
   
   return BOTH;
}