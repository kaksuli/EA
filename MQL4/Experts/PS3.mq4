#property strict
#property show_inputs
#property copyright "کاری از گروه asranet";

#include <classes\MainStrategy.mqh>

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////CALIBRATION///////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

input string versionps3 = "parallel system 3"; // نسخه
input string versionps3Des = "همگام سازی نسخه با پیشرفت های قبلی"; // توضیح نسخه

extern int widthMargin2 = 180;
extern int fontSize = 11;
extern int HGap = 20;
extern color regularSellColor = clrRed;
extern color regularBuyColor = clrBlue;
extern color switch1SellColor = clrYellow;
extern color switch1BuyColor = clrLime;
extern color switch2SellColor = clrOrange;
extern color switch2BuyColor = clrGreenYellow;
extern int slippage = 20;

extern int PACK_TYPES_TOTAL = 2; //تعداد پک ها

input string a23324 = "======================================================================"; // حدها
extern double regularPackTP = 1000; // تی پی برای پک معمولی
extern double regularAndSwitch1TP = 1000; // تی پی برای پک معمولی و سویچ اول
extern double regularAndSwitch2TP = 1000; // تی پی سه پک
input string b15425 = "======================================================================"; // تنظیمات سیگنال ها
input string e5434 = "======================================================================"; // تنظیمات DMI
input  int             DmiPeriod         = 32;             // DMI period
input  enMaTypes       DmiMaMethod       = ma_smma;        // DMI smoothing method
input  int             Smooth            = 0;              // Smothing period (<=1 does not accept for no smoothing)
input  enMaTypes       SmoothType        = ma_ema;         // Smothing method
extern int             SignalPeriod      = 9;              // Signal period
input  enColorOn       ColorOn           = chg_onOuter;    // Change color on :
extern ENABLING         invertEnabled     = disable;
extern double           invert            = 1;

extern ENABLING dmiEnabledByColor = disable; //  صدور سیگنال براساس رنگ DMI
extern ENABLING2 dmiThreeColorEnabled = disable2;// تعداد حالت رنگ DMI صدور سیگنال

extern ENABLING dmiOverEnabled = enable;
extern double overSellArea = -110; // DMI پایین ترین مقدار مجاز فروش
extern double overBuyArea = 100; // DMI بالاترین مقدار مجاز خرید

input string k876534 = "======================================================================"; // تنظیمات stdDev
extern int ma_period0 = 10; // period
extern ENUM_MA_METHOD ma_method0 = MODE_SMA; // method
extern ENUM_APPLIED_PRICE stdDevAppliedPrice0 = PRICE_CLOSE; // Apply to
extern int ma_shift0 = 0; // moving average shift
extern int stdShift0 = 0; // shift

extern ENABLING stdDevEnabled = disable; // فیلتر انتهای موج stdDev
extern double maxStdDevValueBegin = 4;
extern double maxStdDevValueEnd = 20;
extern double minStdDevDifference = 0;

input string f5345 = "======================================================================"; // تنظیمات شیب
extern ENABLING channelDipLimitEnabled = disable; // فعالسازی شیب کانالی
extern int NumBarsDip = 10; // برای شیب NumBars
extern int dipReminder = 90; // باقی مانده سیکل

extern int highSellDip = -10; // شروع سیگنال فروش شیب
extern int lowSellDip = -45; // پایان سیگنال فروش شیب
extern int highBuyDip = 45; // پایان سیگنال خرید شیب
extern int lowBuyDip = 10; // شروع سیگنال خرید شیب

input string g534 = "======================================================================"; // تنظیمات RSI
extern ENABLING RSIEnabled = disable;
extern int highSellRSI = 100000; // RSI شروع سیگنال فروش
extern int lowSellRSI = 30; // RSI پایان سیگنال فروش
extern int highBuyRSI = 70; //  RSI پایان سیگنال خرید
extern int lowBuyRSI = -100000; // RSI شروع سیگنال خرید
extern ENUM_APPLIED_PRICE RSIPeriodAppliedPrice = PRICE_CLOSE; // RSIPeriodAppliedPrice
extern int RSIPeriod = 14; // RSIPeriod
extern int RSIShift = 0; // RSIShift

input string h554 = "======================================================================"; // تنظیمات ForexProfitSupreme
extern ENABLING ForexProfitSupremeSignalOpenEnabled = disable;
extern int FastMA = 5;
extern int FastMAShift = 0;
extern int FastMAMethod = 3;
extern int FastMAPrice = 0;
extern int SlowMA = 13;
extern int SlowMAShift = 0;
extern int SlowMAMethod = 3;
extern int SlowMAPrice = 0;

input string iitt54 = "======================================================================"; // تنظیمات buysellarrowscalper
extern ENABLING buysellarrowscalperOpenEnabled = disable;
extern int Amplitude = 2;
input string r4354 = "======================================================================"; // تنظیمات  price border
extern ENABLING PriceBorderEnabled = disable;
extern string TimeFrame = "All tf";
extern int HalfLength = 61;
extern int Price = 0;
extern double ATRMultiplier = 2.6;
extern int ATRPeriod = 110;
extern bool Interpolate = TRUE;
extern int allowed = 0;

input string jjh45h = "======================================================================"; // تنظیمات سویچ
input string k45454 = "======================================================================"; // تنظیمات سویچ stdDev
extern int ma_period = 10; // period
extern ENUM_MA_METHOD ma_method = MODE_SMA; // method
extern ENUM_APPLIED_PRICE stdDevAppliedPrice = PRICE_CLOSE; // Apply to
extern int ma_shift = 0; // moving average shift
extern int stdShift = 0; // shift

extern ENABLING stdDevSwitchEnabled = disable; // انجام سویچ براساس std
extern double maxStdDevValueBeginSwitch = 4;
extern double maxStdDevValueEndSwitch =   20;
extern double minStdDevDifferenceSwitch = 0;

input string m5464h = "======================================================================"; // تنظیمات سویچ DMI
extern ENABLING stdDMIEnabled = disable; // انجام سویچ براساس تغییر رنگ DMI
extern ENABLING2 stdDMIThreeColorEnabled = disable2;// تعداد حالت رنگ DMI

input string n6h5 = "======================================================================"; // تنظیمات سویچ شیب
extern ENABLING stdDipEnabled = disable; // انجام سویچ براساس شیب کانال
extern double stdDip = 10; // شیب

input string o544h = "======================================================================"; // تنظیمات سویچ RSI
extern ENABLING stdRSIEnabled = disable;// سویچ براساس  RSI
extern int highSellRSI1 = 100000; // RSI شروع سیگنال فروش
extern int lowSellRSI1 = 30; // RSI پایان سیگنال فروش
extern int highBuyRSI1 = 70; //  RSI پایان سیگنال خرید
extern int lowBuyRSI1 = -100000; // RSI شروع سیگنال خرید
input string oo45hr = "======================================================================"; // تنظیمات براساس پله اولین
extern ENABLING switchFirstStepEnabled = disable; // فعالسازی سویچ براساس تغییر پیپی از پله اولین
extern int switchFirstStepByPip = 100;
input string p343grtg = "======================================================================"; // تنظیمات سویچ ForexProfitSupreme
extern ENABLING ForexProfitSupremeSignalSwitchEnabled = disable;
extern int FastMAClose = 5; // FastMA
extern int FastMAShiftClose = 0; // FastMAShift
extern int FastMAMethodClose = 3; // FastMAMethod
extern int FastMAPriceClose = 0; // FastMAPrice
extern int SlowMAClose = 13; // SlowMA
extern int SlowMAShiftClose = 0; // SlowMAShift
extern int SlowMAMethodClose = 3; // SlowMAMethod
extern int SlowMAPriceClose = 0; // SlowMAPrice

input string qfh = "======================================================================"; // تنظیمات سویچ buysellarrowscalper
extern ENABLING buysellarrowscalperSwitchEnabled = disable;
extern int AmplitudeClose = 2; // Amplitude

input string r24334 = "======================================================================"; // تنظیمات سویچ price border
extern ENABLING PriceBorderSwitchEnabled = disable;
extern string TimeFrameSwitch = "All tf";
extern int HalfLengthSwitch = 61;
extern int PriceSwitch = 0;
extern double ATRMultiplierSwitch = 2.6;
extern int ATRPeriodSwitch = 110;
extern bool InterpolateSwitch = TRUE;
extern int allowedSwitch = 0;

input string j2243er = "======================================================================"; // تنظیمات سویچ 2
input string k22yr7 = "======================================================================"; // تنظیمات سویچ stdDev 2
extern int ma_period2 = 10; // period
extern ENUM_MA_METHOD ma_method2 = MODE_SMA; // method
extern ENUM_APPLIED_PRICE stdDevAppliedPrice2 = PRICE_CLOSE; // Apply to
extern int ma_shift2 = 0; // moving average shift
extern int stdShift2 = 0; // shift

extern ENABLING stdDevSwitchEnabled2 = disable; // انجام سویچ براساس std
extern double maxStdDevValueBeginSwitch2 = 4;
extern double maxStdDevValueEndSwitch2 =   20;
extern double minStdDevDifferenceSwitch2 = 0;

input string m111 = "======================================================================"; // تنظیمات سویچ DMI 2
extern ENABLING stdDMIEnabled2 = disable; // انجام سویچ براساس تغییر رنگ DMI
extern ENABLING2 stdDMIThreeColorEnabled2 = disable2;// تعداد حالت رنگ DMI

input string n121 = "======================================================================"; // تنظیمات سویچ شیب 2
extern ENABLING stdDipEnabled2 = disable; // انجام سویچ براساس شیب کانال 2
extern double stdDip2 = 10; // شیب

input string o21312 = "======================================================================"; // تنظیمات سویچ RSI 2
extern ENABLING stdRSIEnabled2 = disable;// سویچ براساس  RSI
extern int highSellRSI2 = 100000; // RSI شروع سیگنال فروش
extern int lowSellRSI2 = 30; // RSI پایان سیگنال فروش
extern int highBuyRSI2 = 70; //  RSI پایان سیگنال خرید
extern int lowBuyRSI2 = -100000; // RSI شروع سیگنال خرید
input string oo312341 = "======================================================================"; // تنظیمات براساس پله اولین 2
extern ENABLING switchFirstStepEnabled2 = disable; // فعالسازی سویچ براساس تغییر پیپی از پله اولین 2
extern int switchFirstStepByPip2 = 100;

input string p2 = "======================================================================"; // تنظیمات سویچ ForexProfitSupreme 2
extern ENABLING ForexProfitSupremeSignalSwitchEnabled2 = disable;
extern int FastMAClose2 = 5; // FastMA
extern int FastMAShiftClose2 = 0; // FastMAShift
extern int FastMAMethodClose2 = 3; // FastMAMethod
extern int FastMAPriceClose2 = 0; // FastMAPrice
extern int SlowMAClose2 = 13; // SlowMA
extern int SlowMAShiftClose2 = 0; // SlowMAShift
extern int SlowMAMethodClose2 = 3; // SlowMAMethod
extern int SlowMAPriceClose2 = 0; // SlowMAPrice

input string q2 = "======================================================================"; // تنظیمات سویچ buysellarrowscalper 2
extern ENABLING buysellarrowscalperSwitchEnabled2 = disable;
extern int AmplitudeClose2 = 2; // Amplitude

input string r2432 = "======================================================================"; // تنظیمات سویچ price border 2
extern ENABLING PriceBorderSwitchEnabled2 = disable; 
extern string TimeFrameSwitch2 = "All tf";
extern int HalfLengthSwitch2 = 61;
extern int PriceSwitch2 = 0;
extern double ATRMultiplierSwitch2 = 2.6;
extern int ATRPeriodSwitch2 = 110;
extern bool InterpolateSwitch2 = TRUE;
extern int allowedSwitch2 = 0;

input string j222 = "======================================================================"; // تنظیمات سویچ 3
input string k223 = "======================================================================"; // تنظیمات سویچ stdDev 3
extern int ma_period3 = 10; // period
extern ENUM_MA_METHOD ma_method3 = MODE_SMA; // method
extern ENUM_APPLIED_PRICE stdDevAppliedPrice3 = PRICE_CLOSE; // Apply to
extern int ma_shift3 = 0; // moving average shift
extern int stdShift3 = 0; // shift

extern ENABLING stdDevSwitchEnabled3 = disable; // انجام سویچ براساس std
extern double maxStdDevValueBeginSwitch3 = 4;
extern double maxStdDevValueEndSwitch3 =   20;
extern double minStdDevDifferenceSwitch3 = 0;

input string m3111 = "======================================================================"; // تنظیمات سویچ DMI 3
extern ENABLING stdDMIEnabled3 = disable; // انجام سویچ براساس تغییر رنگ DMI
extern ENABLING2 stdDMIThreeColorEnabled3 = disable2;// تعداد حالت رنگ DMI

input string n131 = "======================================================================"; // تنظیمات سویچ شیب 3
extern ENABLING stdDipEnabled3 = disable; // انجام سویچ براساس شیب کانال 3
extern double stdDip3 = 10; // شیب
input string o31313 = "======================================================================"; // تنظیمات سویچ RSI 3
extern ENABLING stdRSIEnabled3 = disable;// سویچ براساس  RSI
extern int highSellRSI3 = 100000; // RSI شروع سیگنال فروش
extern int lowSellRSI3 = 30; // RSI پایان سیگنال فروش
extern int highBuyRSI3 = 70; //  RSI پایان سیگنال خرید
extern int lowBuyRSI3 = -100000; // RSI شروع سیگنال خرید
input string oo313341 = "======================================================================"; // تنظیمات براساس پله اولین 3
extern ENABLING switchFirstStepEnabled3 = disable; // فعالسازی سویچ براساس تغییر پیپی از پله اولین 3
extern int switchFirstStepByPip3 = 100;

input string p3 = "======================================================================"; // تنظیمات سویچ ForexProfitSupreme 3
extern ENABLING ForexProfitSupremeSignalSwitchEnabled3 = disable;
extern int FastMAClose3 = 5; // FastMA
extern int FastMAShiftClose3 = 0; // FastMAShift
extern int FastMAMethodClose3 = 3; // FastMAMethod
extern int FastMAPriceClose3 = 0; // FastMAPrice
extern int SlowMAClose3 = 13; // SlowMA
extern int SlowMAShiftClose3 = 0; // SlowMAShift
extern int SlowMAMethodClose3 = 3; // SlowMAMethod
extern int SlowMAPriceClose3 = 0; // SlowMAPrice

input string q3 = "======================================================================"; // تنظیمات سویچ buysellarrowscalper 3
extern ENABLING buysellarrowscalperSwitchEnabled3 = disable;
extern int AmplitudeClose3 = 3; // Amplitude

input string r3433 = "======================================================================"; // تنظیمات سویچ price border 3
extern ENABLING PriceBorderSwitchEnabled3 = disable; 
extern string TimeFrameSwitch3 = "All tf";
extern int HalfLengthSwitch3 = 61;
extern int PriceSwitch3 = 0;
extern double ATRMultiplierSwitch3 = 3.6;
extern int ATRPeriodSwitch3 = 110;
extern bool InterpolateSwitch3 = TRUE;
extern int allowedSwitch3 = 0;

input string tgdfgd = "======================================================================"; // لات هر پایه
extern double lot1 =  0.01;
extern double lot2 =  0.02;
extern double lot3 =  0.03;
extern double lot4 =  0.04;
extern double lot5 =  0.05;
extern double lot6 =  0.06;
extern double lot7 =  0.07;
extern double lot8 =  0.08;
extern double lot9 =  0.09;
extern double lot10 = 0.1;

input string t43 = "======================================================================"; // تی پی هر پایه
extern double tp1 =  0.01;
extern double tp2 =  0.02;
extern double tp3 =  0.03;
extern double tp4 =  0.04;
extern double tp5 =  0.05;
extern double tp6 =  0.06;
extern double tp7 =  0.07;
extern double tp8 =  0.08;
extern double tp9 =  0.09;
extern double tp10 = 0.1;

input string yy = "======================================================================"; // اختلاف برای پایه بعد
extern int difference2 = 100;
extern int difference3 = 120;
extern int difference4 = 150;
extern int difference5 = 200;
extern int difference6 = 280;
extern int difference7 = 400;
extern int difference8 = 550;
extern int difference9 = 700;
extern int difference10 = 800;

input string xx = "======================================================================"; // نگاشت پایه ی سویچ
extern ENABLING mapLotEnabled = disable;
extern int mapLot1 = 1;
extern int mapLot2 = 1;
extern int mapLot3 = 1;
extern int mapLot4 = 1;
extern int mapLot5 = 1;
extern int mapLot6 = 1;
extern int mapLot7 = 1;
extern int mapLot8 = 1;
extern int mapLot9 = 1;
extern int mapLot10 = 1;

input string w = "======================================================================"; // لات هر سویچ
extern double lotSwitch1 =  0.1;
extern double lotSwitch2 =  0.2;
extern double lotSwitch3 =  0.3;
extern double lotSwitch4 =  0.4;
extern double lotSwitch5 =  0.5;
extern double lotSwitch6 =  0.6;
extern double lotSwitch7 =  0.7;
extern double lotSwitch8 =  0.8;
extern double lotSwitch9 =  0.9;
extern double lotSwitch10 = 1;

input string yy2 = "======================================================================"; // اختلاف برای پایه بعد سویچ 1
extern int d1ifference2 = 100;
extern int d1ifference3 = 120;
extern int d1ifference4 = 150;
extern int d1ifference5 = 200;
extern int d1ifference6 = 280;
extern int d1ifference7 = 400;
extern int d1ifference8 = 550;
extern int d1ifference9 = 700;
extern int d1ifference10 = 800;

int OnInit(){

   createLabels();
   populateArrays();
   
   mainStrategy.symbol = symbol;
   mainStrategy.chart_id = chart_id;
   mainStrategy.point = point;
   mainStrategy.period = period;
   
   mainStrategy.currentBalance = 0;
   mainStrategy.lastBalance = 0;
   
   mainStrategy.PACK_TYPES_TOTAL = PACK_TYPES_TOTAL;
   mainStrategy.regularSellColor = regularSellColor;
   mainStrategy.regularBuyColor = regularBuyColor;
   mainStrategy.switch1SellColor = switch1SellColor;
   mainStrategy.switch1BuyColor = switch1BuyColor;
   mainStrategy.switch2SellColor = switch2SellColor;
   mainStrategy.switch2BuyColor = switch2BuyColor;
   mainStrategy.mapLotEnabled = mapLotEnabled;
   mainStrategy.pack1Tp = regularPackTP;
   mainStrategy.pack2Tp = regularAndSwitch1TP;
   mainStrategy.pack3Tp = regularAndSwitch2TP;
   
   mainStrategy.setLots(lots);
   mainStrategy.setTps(tps);
   mainStrategy.setLotSwitches(lotSwitches);
   mainStrategy.setMapLots(mapLots);
   mainStrategy.setDifferences(differences);
   mainStrategy.setDifferences1(differences1);
   
   mainStrategy.setLabels(labels);
   mainStrategy.setOrder(order);
   
   mainStrategy.setDmiSignal(dmiSignal);
   mainStrategy.setDmiSwitch1(dmiSwitch1);
   mainStrategy.setDmiSwitch2(dmiSwitch2);
   mainStrategy.setDmiSwitch3(dmiSwitch3);
   
   mainStrategy.setSpcSignal(spcSignal);
   mainStrategy.setSpcSwitch1(spcSwitch1);
   mainStrategy.setSpcSwitch2(spcSwitch2);
   mainStrategy.setSpcSwitch3(spcSwitch3);
   
   mainStrategy.setRsiSignal(rsiSignal);
   mainStrategy.setRsiSwitch1(rsiSwitch1);
   mainStrategy.setRsiSwitch2(rsiSwitch2);
   mainStrategy.setRsiSwitch3(rsiSwitch3);
   
   mainStrategy.setFpsSignal(fpsSignal);
   mainStrategy.setFpsSwitch1(fpsSwitch1);
   mainStrategy.setFpsSwitch2(fpsSwitch2);
   mainStrategy.setFpsSwitch3(fpsSwitch3);
   
   mainStrategy.setBuysellarrowscalperSignal(buysellarrowscalperSignal);
   mainStrategy.setBuysellarrowscalperSwitch1(buysellarrowscalperSwitch1);
   mainStrategy.setBuysellarrowscalperSwitch2(buysellarrowscalperSwitch2);
   mainStrategy.setBuysellarrowscalperSwitch3(buysellarrowscalperSwitch3);
   
   mainStrategy.setPriceBorderSignal(priceBorderSignal);
   mainStrategy.setPriceBorderSwitch1(priceBorderSwitch1);
   mainStrategy.setPriceBorderSwitch2(priceBorderSwitch2);
   mainStrategy.setPriceBorderSwitch3(priceBorderSwitch3);
   
   mainStrategy.setStdDevSwitch1(stdDevSwitch1);
   mainStrategy.setStdDevSwitch2(stdDevSwitch2);
   mainStrategy.setStdDevSwitch3(stdDevSwitch3);
   
   mainStrategy.switchFirstStepEnabled1 = switchFirstStepEnabled;
   mainStrategy.switchFirstStepByPip1 = switchFirstStepByPip;
   mainStrategy.switchFirstStepEnabled2 = switchFirstStepEnabled2;
   mainStrategy.switchFirstStepByPip2 = switchFirstStepByPip2;
   mainStrategy.switchFirstStepEnabled3 = switchFirstStepEnabled3;
   mainStrategy.switchFirstStepByPip3 = switchFirstStepByPip3;
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
}

void OnTick(){
   mainStrategy.doStrategy();
}

void populateArrays(){
   for(int i = 0; i < 10; i++){
      switch(i){
         case 0 : tps[i] = tp1; lots[i] = lot1; differences1[i] = d1ifference2; differences[i] = difference2; lotSwitches[i] = lotSwitch1; mapLots[i] = mapLot1; break;
         case 1 : tps[i] = tp2; lots[i] = lot2; differences1[i] = d1ifference2; differences[i] = difference2; lotSwitches[i] = lotSwitch2; mapLots[i] = mapLot2; break;
         case 2 : tps[i] = tp3; lots[i] = lot3; differences1[i] = d1ifference3; differences[i] = difference3; lotSwitches[i] = lotSwitch3; mapLots[i] = mapLot3; break;
         case 3 : tps[i] = tp4; lots[i] = lot4; differences1[i] = d1ifference4; differences[i] = difference4; lotSwitches[i] = lotSwitch4; mapLots[i] = mapLot4; break;
         case 4 : tps[i] = tp5; lots[i] = lot5; differences1[i] = d1ifference5; differences[i] = difference5; lotSwitches[i] = lotSwitch5; mapLots[i] = mapLot5; break;
         case 5 : tps[i] = tp6; lots[i] = lot6; differences1[i] = d1ifference6; differences[i] = difference6; lotSwitches[i] = lotSwitch6; mapLots[i] = mapLot6; break;
         case 6 : tps[i] = tp7; lots[i] = lot7; differences1[i] = d1ifference7; differences[i] = difference7; lotSwitches[i] = lotSwitch7; mapLots[i] = mapLot7; break;
         case 7 : tps[i] = tp8; lots[i] = lot8; differences1[i] = d1ifference8; differences[i] = difference8; lotSwitches[i] = lotSwitch8; mapLots[i] = mapLot8; break;
         case 8 : tps[i] = tp9; lots[i] = lot9; differences1[i] = d1ifference9; differences[i] = difference9; lotSwitches[i] = lotSwitch9; mapLots[i] = mapLot9; break;
         case 9 : tps[i] = tp10; lots[i] = lot10; differences1[i] = d1ifference10; differences[i] = difference10; lotSwitches[i] = lotSwitch10; mapLots[i] = mapLot10; break;
      }
   }
}

void createLabels(){
   int hGap = 0;
   labels.addLabel(chart_id, "lastBalance",      0,    /*x*/(int)ChartGetInteger(chart_id, CHART_WIDTH_IN_PIXELS, 0) - widthMargin2, /*y*/hGap, 0, "0", "Arial", fontSize, clrYellow, 0); 
   hGap += HGap;
   labels.addLabel(chart_id, "currentBalance",      0,    /*x*/(int)ChartGetInteger(chart_id, CHART_WIDTH_IN_PIXELS, 0) - widthMargin2, /*y*/hGap, 0, "0", "Arial", fontSize, clrOrange, 0); 
   hGap += HGap;
   labels.addLabel(chart_id, "reBuy",      0,    /*x*/(int)ChartGetInteger(chart_id, CHART_WIDTH_IN_PIXELS, 0) - widthMargin2, /*y*/hGap, 0, "0", "Arial", fontSize, clrWhite, 0); 
   hGap += HGap;
   labels.addLabel(chart_id, "reSell",      0,    /*x*/(int)ChartGetInteger(chart_id, CHART_WIDTH_IN_PIXELS, 0) - widthMargin2, /*y*/hGap, 0, "0", "Arial", fontSize, clrRed, 0); 
   hGap += HGap;
   labels.addLabel(chart_id, "sw1Buy",      0,    /*x*/(int)ChartGetInteger(chart_id, CHART_WIDTH_IN_PIXELS, 0) - widthMargin2, /*y*/hGap, 0, "0", "Arial", fontSize, clrWhite, 0); 
   hGap += HGap;
   labels.addLabel(chart_id, "sw1Sell",      0,    /*x*/(int)ChartGetInteger(chart_id, CHART_WIDTH_IN_PIXELS, 0) - widthMargin2, /*y*/hGap, 0, "0", "Arial", fontSize, clrRed, 0); 
   hGap += HGap;
   labels.addLabel(chart_id, "sw2Buy",      0,    /*x*/(int)ChartGetInteger(chart_id, CHART_WIDTH_IN_PIXELS, 0) - widthMargin2, /*y*/hGap, 0, "0", "Arial", fontSize, clrWhite, 0); 
   hGap += HGap;
   labels.addLabel(chart_id, "sw2Sell",      0,    /*x*/(int)ChartGetInteger(chart_id, CHART_WIDTH_IN_PIXELS, 0) - widthMargin2, /*y*/hGap, 0, "0", "Arial", fontSize, clrRed, 0); 
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////VARIABLES///////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
const string symbol = Symbol();
const long chart_id = ChartID();
const double point = Point;
const int period = Period();

int currentBalance = 0;
int lastBalance = 0;

double lots[10];
double tps[10];
double lotSwitches[10];
double mapLots[10];

int differences[10];
int differences1[10];
Label labels;
Order order(symbol, period, slippage);

StdDev stdDevSwitch1(symbol, period, stdDevSwitchEnabled , ma_period , ma_method , stdDevAppliedPrice , ma_shift , stdShift , maxStdDevValueBeginSwitch , maxStdDevValueEndSwitch , minStdDevDifferenceSwitch );
StdDev stdDevSwitch2(symbol, period, stdDevSwitchEnabled2, ma_period2, ma_method2, stdDevAppliedPrice2, ma_shift2, stdShift2, maxStdDevValueBeginSwitch2, maxStdDevValueEndSwitch2, minStdDevDifferenceSwitch2);
StdDev stdDevSwitch3(symbol, period, stdDevSwitchEnabled3, ma_period3, ma_method3, stdDevAppliedPrice3, ma_shift3, stdShift3, maxStdDevValueBeginSwitch3, maxStdDevValueEndSwitch3, minStdDevDifferenceSwitch3);

DMI dmiSignal (symbol, period, dmiEnabledByColor, dmiThreeColorEnabled     , dmiOverEnabled  , overBuyArea, overSellArea, DmiPeriod, DmiMaMethod, Smooth, SmoothType, SignalPeriod, ColorOn, invertEnabled, invert);
DMI dmiSwitch1(symbol, period, stdDMIEnabled    , stdDMIThreeColorEnabled  , false           , 0, 0                                     , DmiPeriod, DmiMaMethod, Smooth, SmoothType, SignalPeriod, ColorOn, invertEnabled, invert);
DMI dmiSwitch2(symbol, period, stdDMIEnabled2   , stdDMIThreeColorEnabled2 , false, 0, 0                                     , DmiPeriod, DmiMaMethod, Smooth, SmoothType, SignalPeriod, ColorOn, invertEnabled, invert);
DMI dmiSwitch3(symbol, period, stdDMIEnabled3   , stdDMIThreeColorEnabled3 , false, 0, 0                                     , DmiPeriod, DmiMaMethod, Smooth, SmoothType, SignalPeriod, ColorOn, invertEnabled, invert);

StarProfitChannel spcSignal (symbol, period, channelDipLimitEnabled  , NumBarsDip, dipReminder, highSellDip, lowSellDip, highBuyDip, lowBuyDip, 0      );
StarProfitChannel spcSwitch1(symbol, period, stdDipEnabled           , NumBarsDip, dipReminder, highSellDip, lowSellDip, highBuyDip, lowBuyDip, stdDip );
StarProfitChannel spcSwitch2(symbol, period, stdDipEnabled2          , NumBarsDip, dipReminder, highSellDip, lowSellDip, highBuyDip, lowBuyDip, stdDip2);
StarProfitChannel spcSwitch3(symbol, period, stdDipEnabled3          , NumBarsDip, dipReminder, highSellDip, lowSellDip, highBuyDip, lowBuyDip, stdDip3);

RSI rsiSignal (symbol, period, RSIEnabled    , highSellRSI , lowSellRSI , highBuyRSI , lowBuyRSI , RSIPeriodAppliedPrice, RSIPeriod, RSIShift);
RSI rsiSwitch1(symbol, period, stdRSIEnabled , highSellRSI1, lowSellRSI1, highBuyRSI1, lowBuyRSI1, RSIPeriodAppliedPrice, RSIPeriod, RSIShift);
RSI rsiSwitch2(symbol, period, stdRSIEnabled2, highSellRSI2, lowSellRSI2, highBuyRSI2, lowBuyRSI2, RSIPeriodAppliedPrice, RSIPeriod, RSIShift);
RSI rsiSwitch3(symbol, period, stdRSIEnabled3, highSellRSI3, lowSellRSI3, highBuyRSI3, lowBuyRSI3, RSIPeriodAppliedPrice, RSIPeriod, RSIShift);

ForexProfitSupreme fpsSignal (symbol, period, ForexProfitSupremeSignalOpenEnabled   , FastMA       , FastMAShift        , FastMAMethod       , FastMAPrice        , SlowMA       , SlowMAShift        , SlowMAMethod       , SlowMAPrice        );
ForexProfitSupreme fpsSwitch1(symbol, period, ForexProfitSupremeSignalSwitchEnabled , FastMAClose  , FastMAShiftClose   , FastMAMethodClose  , FastMAPriceClose   , SlowMAClose  , SlowMAShiftClose   , SlowMAMethodClose  , SlowMAPriceClose   );
ForexProfitSupreme fpsSwitch2(symbol, period, ForexProfitSupremeSignalSwitchEnabled2, FastMAClose2 , FastMAShiftClose2  , FastMAMethodClose2 , FastMAPriceClose2  , SlowMAClose2 , SlowMAShiftClose2  , SlowMAMethodClose2 , SlowMAPriceClose2  );
ForexProfitSupreme fpsSwitch3(symbol, period, ForexProfitSupremeSignalSwitchEnabled3, FastMAClose3 , FastMAShiftClose3  , FastMAMethodClose3 , FastMAPriceClose3  , SlowMAClose3 , SlowMAShiftClose3  , SlowMAMethodClose3 , SlowMAPriceClose3  );

Buysellarrowscalper buysellarrowscalperSignal (symbol, period, buysellarrowscalperOpenEnabled   , Amplitude       );
Buysellarrowscalper buysellarrowscalperSwitch1(symbol, period, buysellarrowscalperSwitchEnabled , AmplitudeClose  );
Buysellarrowscalper buysellarrowscalperSwitch2(symbol, period, buysellarrowscalperSwitchEnabled2, AmplitudeClose2 );
Buysellarrowscalper buysellarrowscalperSwitch3(symbol, period, buysellarrowscalperSwitchEnabled3, AmplitudeClose3 );

PriceBorder priceBorderSignal (symbol, period, slippage, point, PriceBorderEnabled        , TimeFrame       , HalfLength         , Price        , ATRMultiplier         , ATRPeriod       , Interpolate        , allowed         );
PriceBorder priceBorderSwitch1(symbol, period, slippage, point, PriceBorderSwitchEnabled  , TimeFrameSwitch , HalfLengthSwitch   , PriceSwitch  , ATRMultiplierSwitch   , ATRPeriodSwitch , InterpolateSwitch  , allowedSwitch   );
PriceBorder priceBorderSwitch2(symbol, period, slippage, point, PriceBorderSwitchEnabled2 , TimeFrameSwitch2, HalfLengthSwitch2  , PriceSwitch2 , ATRMultiplierSwitch2  , ATRPeriodSwitch2, InterpolateSwitch2 , allowedSwitch2  );
PriceBorder priceBorderSwitch3(symbol, period, slippage, point, PriceBorderSwitchEnabled3 , TimeFrameSwitch3, HalfLengthSwitch3  , PriceSwitch3 , ATRMultiplierSwitch3  , ATRPeriodSwitch3, InterpolateSwitch3 , allowedSwitch3  );

MainStrategy mainStrategy();