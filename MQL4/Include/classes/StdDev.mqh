#property copyright "sulaiman kadkhodaei"
#property link      "mspk7492@gmail.com"
#property version   "1.00"
#property strict

#include <classes\Enumerators.mqh>
#include <classes\Order.mqh>

class StdDev{

private:
   int NOT_VALID_VALUE;
   string symbol;
   int timeFrame;
   bool enabled;
   int ma_period;
   ENUM_MA_METHOD ma_method;
   ENUM_APPLIED_PRICE stdDevAppliedPrice;
   int ma_shift;
   int stdShift;
   double begin;
   double end;
   double diff;
   
public:
   StdDev(string symbol, int timeFrame, bool enabled, int ma_period, ENUM_MA_METHOD ma_method, ENUM_APPLIED_PRICE stdDevAppliedPrice, int ma_shift, int stdShift, double begin, double end, double diff);
   ~StdDev();
   StdDev(){}
   TRADE_TYPE getSignal();
   double getValue(int shift);
   bool getEnabled();
   void copy(StdDev &stdDev);
};

StdDev::StdDev(string s, int t, bool e, int ma_periodq, ENUM_MA_METHOD ma_methodq, ENUM_APPLIED_PRICE stdDevAppliedPriceq, int ma_shiftq, int stdShiftq, double beginq, double endq, double diffq){
   this.symbol = s;
   this.timeFrame = t;
   this.enabled = e;
   this.ma_period = ma_periodq;
   this.ma_method = ma_methodq;
   this.stdDevAppliedPrice = stdDevAppliedPriceq;
   this.ma_shift = ma_shiftq;
   this.stdShift = stdShiftq;
   this.begin = beginq;
   this.end = endq;
   this.diff = diffq;
   NOT_VALID_VALUE = -100000;
}

void StdDev::copy(StdDev &stdDev){
   this.symbol = stdDev.symbol;
   this.timeFrame = stdDev.timeFrame;
   this.enabled = stdDev.enabled;
   this.ma_period = stdDev.ma_period;
   this.ma_method = stdDev.ma_method;
   this.stdDevAppliedPrice = stdDev.stdDevAppliedPrice;
   this.ma_shift = stdDev.ma_shift;
   this.stdShift = stdDev.stdShift;
   this.begin = stdDev.begin;
   this.end = stdDev.end;
   this.diff = stdDev.diff;
   NOT_VALID_VALUE = -100000;
}
StdDev::~StdDev(){}

double StdDev::getValue(int shift){
   if(!enabled){
      return NOT_VALID_VALUE;
   }
   
   return iStdDev(symbol, timeFrame, ma_period, ma_shift, ma_method, stdDevAppliedPrice, stdShift + shift);
}

bool StdDev::getEnabled(){
   return enabled;
}
TRADE_TYPE StdDev::getSignal(){
   double stdDev0 = getValue(0);
   double stdDev1 = getValue(1);
   
   if(stdDev0 == NOT_VALID_VALUE || stdDev1 == NOT_VALID_VALUE){
      return NONE;
   }
   
   if(stdDev0 >= begin && stdDev0 <= end && (stdDev0 - stdDev1 >= diff)){
      return BOTH;
   }
   return NONE;
}