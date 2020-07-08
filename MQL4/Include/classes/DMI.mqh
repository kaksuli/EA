#property copyright "sulaiman kadkhodaei"
#property link      "mspk7492@gmail.com"
#property version   "1.00"
#property strict

#include <classes\Enumerators.mqh>

class DMI{

private:
   string symbol;
   int timeFrame;
   bool enabled;
   bool overEnabled;
   bool threeColorEnabled;
   double overBuyArea;
    double overSellArea;
   int DmiPeriod;
   int DmiMaMethod;
   int Smooth;
   int SmoothType;
   int SignalPeriod;
   int ColorOn;
   bool invertEnabled;
   double invert;
   double previosDmi1;
   
public:
   DMI(string symbol, int timeFrame,
       bool enabled, bool threeColorEnabled, bool overEnabled, double overBuyArea, double overSellArea,
       int DmiPeriod, int DmiMaMethod, int Smooth, int SmoothType, int SignalPeriod, int ColorOn, bool invertEnabled, double invert);
   DMI(){}
   ~DMI();
   
   TRADE_TYPE getSignalByDMIColor();
   TRADE_TYPE getSignalByDMIOver();
   double getValue(int mode, int shift);
   bool getEnabled();
   bool getOverEnabled();
   bool getThreeColorEnabled();
   void copy(DMI &dmi);
};
DMI::DMI(string s, int t,
       bool e, bool tt, bool o, double ob, double os,
       int dp, int dmm, int sh, int se, int sd, int cn, bool id, double it){

   this.symbol = s;
   this.timeFrame = t;
   this.enabled = e;
   this.threeColorEnabled = tt;
   this.overEnabled = o;
   this.overBuyArea = ob;
   this.overSellArea = os;
   this.DmiPeriod = dp;
   this.DmiMaMethod = dmm;
   this.Smooth = sh;
   this.SmoothType = se;
   this.SignalPeriod = sd;
   this.ColorOn = cn;
   this.invertEnabled = id;
   this.invert = it;
   previosDmi1 = 0;
}
void DMI::copy(DMI &dmi){

   this.symbol = dmi.symbol;
   this.timeFrame = dmi.timeFrame;
   this.enabled = dmi.enabled;
   this.overEnabled = dmi.overEnabled;
   this.threeColorEnabled = dmi.threeColorEnabled;
   this.overBuyArea = dmi.overBuyArea;
   this.overSellArea = dmi.overSellArea;
   this.DmiPeriod = dmi.DmiPeriod;
   this.DmiMaMethod = dmi.DmiMaMethod;
   this.Smooth = dmi.Smooth;
   this.SmoothType = dmi.SmoothType;
   this.SignalPeriod = dmi.SignalPeriod;
   this.ColorOn = dmi.ColorOn;
   this.invertEnabled = dmi.invertEnabled;
   this.invert = dmi.invert;
   previosDmi1 = 0;
}
DMI::~DMI(){}

bool DMI::getEnabled(){
   return enabled;
}
bool DMI::getOverEnabled(){
   return overEnabled;
}
bool DMI::getThreeColorEnabled(){
   return threeColorEnabled;
}
double DMI::getValue(int mode, int shift){
   return iCustom(symbol, timeFrame, "asranet MA", DmiPeriod, DmiMaMethod, Smooth, SmoothType, SignalPeriod, ColorOn, invertEnabled, invert, mode - 1, shift);
}

TRADE_TYPE DMI::getSignalByDMIColor(){
   if(!enabled){
      return NONE;
   }
   
   double dmi1 = getValue(1, 0);
   if(dmi1 == EMPTY_VALUE){
      dmi1 = 0;
   }
   
   if(dmi1 == 1){
      previosDmi1 = 1;
      return BUY;
   }
   
   if(dmi1 == -1){
      previosDmi1 = -1;
      return SELL;
   }
   
   if(!threeColorEnabled && previosDmi1 == -1){
      return BUY;
   }
   
   if(!threeColorEnabled && previosDmi1 == 1){
      return SELL;
   }
   
   return NONE;
}

TRADE_TYPE DMI::getSignalByDMIOver(){
   if(!overEnabled){
      return NONE;
   }
   
   double dmi3 = getValue(3, 0);
   
   if(dmi3 > overBuyArea || dmi3 < overSellArea){
      return NONE;
   }
   
   return BOTH;
}