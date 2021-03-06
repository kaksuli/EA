#property copyright "sulaiman kadkhodaei"
#property link      "mspk7492@gmail.com"
#property version   "1.00"
#property strict

enum TRADE_TYPE{
   BUY, SELL, NONE, BOTH
};

enum ENABLING{
   disable, // غیر فعال
   enable, // فعال
};

enum DMI_STATUS{
   twoColor, // دورنگی
   threeColor, // سه رنگی
};
enum ENABLING2{
   disable2, // دورنگی
   enable2, // سه رنگی
};

enum enMaTypes
{
   ma_sma,    // Simple moving average
   ma_ema,    // Exponential moving average
   ma_smma,   // Smoothed MA
   ma_lwma    // Linear weighted MA
};
enum enColorOn
{
   chg_onZero,  // Change color on zero cross
   chg_onOuter, // Change color on levels cross
   chg_onSlope  // Change color on slope change
};

enum PACK_TYPE{
   REGULAR, SWITCH1, SWITCH2, SWITCH3
};

const int BUY_MAGIC_NUMBER = 1111;
const int SELL_MAGIC_NUMBER = 2222;
const int SWITCH_BUY_MAGIC_NUMBER = 3333;
const int SWITCH_SELL_MAGIC_NUMBER = 4444;
const int SWITCH2_BUY_MAGIC_NUMBER = 33332;
const int SWITCH2_SELL_MAGIC_NUMBER = 44442;

const int ALL_TRADES = -1;