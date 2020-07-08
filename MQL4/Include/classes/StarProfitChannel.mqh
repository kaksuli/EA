#property copyright "sulaiman kadkhodaei"
#property link      "mspk7492@gmail.com"
#property version   "1.00"
#property strict

#include <classes\Enumerators.mqh>

class StarProfitChannel{

private:
   int NOT_VALID_VALUE;
   string symbol;
   int timeFrame;
   bool enabled;
   int NumBarsDip;
   int dipReminder;
   int highSellDip;
   int lowSellDip;
   int highBuyDip;
   int lowBuyDip;
   double limit;
   
public:
   StarProfitChannel(string symbol, int timeFrame, bool enabled, int NumBarsDip, int dipReminder, int highSellDip, int lowSellDip, int highBuyDip, int lowBuyDip, double limit);
   ~StarProfitChannel();
   StarProfitChannel(){}
   TRADE_TYPE getSignal();
   TRADE_TYPE getSignalByLimit();
   double getChannelDip();
   double getValue(int shift);
   bool getEnabled();
   void copy(StarProfitChannel &starProfitChannel);
};
StarProfitChannel::StarProfitChannel(string s, int t, bool e, int n, int d, int hs, int ls, int hb, int lb, double l){
   this.symbol = s;
   this.timeFrame = t;
   this.enabled = e;
   this.NumBarsDip = n;
   this.dipReminder = d;
   this.highSellDip = hs;
   this.lowSellDip = ls;
   this.highBuyDip = hb;
   this.lowBuyDip = lb;
   this.limit = l;
   NOT_VALID_VALUE = -100;
}

void StarProfitChannel::copy(StarProfitChannel &starProfitChannel){
   this.symbol = starProfitChannel.symbol;
   this.timeFrame = starProfitChannel.timeFrame;
   this.enabled = starProfitChannel.enabled;
   this.NumBarsDip = starProfitChannel.NumBarsDip;
   this.dipReminder = starProfitChannel.dipReminder;
   this.highSellDip = starProfitChannel.highSellDip;
   this.lowSellDip = starProfitChannel.lowSellDip;
   this.highBuyDip = starProfitChannel.highBuyDip;
   this.lowBuyDip = starProfitChannel.lowBuyDip;
   NOT_VALID_VALUE = -100;
}
StarProfitChannel::~StarProfitChannel(){}

bool StarProfitChannel::getEnabled(){
   return enabled;
}
double StarProfitChannel::getValue(int shift){
   if(!enabled){
      return NOT_VALID_VALUE;
   }
   
   return iCustom(symbol, timeFrame, "Star-Profit-Channel", NumBarsDip, 0, shift);
}

double StarProfitChannel::getChannelDip(){
   double channel0 = getValue(0);
   double channel1 = getValue(1);
   
   if(channel0 == NOT_VALID_VALUE || channel1 == NOT_VALID_VALUE){
      return NOT_VALID_VALUE;
   }
   
   return MathMod((MathArctan(channel0 - channel1)*180)/3.14, dipReminder);
}

TRADE_TYPE StarProfitChannel::getSignal(){
   double channelDip = getChannelDip();
   
   if(channelDip == NOT_VALID_VALUE){
      return NONE;
   }
   
   if(channelDip >= lowSellDip && channelDip <= highSellDip && channelDip >= lowBuyDip && channelDip <= highBuyDip){
      return BOTH;
   }
   
   if(channelDip >= lowBuyDip && channelDip <= highBuyDip){
      return BUY;
   }
   
   if(channelDip >= lowSellDip && channelDip <= highSellDip){
      return SELL;
   }
   
   return NONE;
}

TRADE_TYPE StarProfitChannel::getSignalByLimit(){
   double channelDip = getChannelDip();
   
   if(channelDip == NOT_VALID_VALUE){
      return NONE;
   }
   
   if(MathAbs(channelDip) >= limit){
      return BOTH;
   }
   
   return NONE;
}