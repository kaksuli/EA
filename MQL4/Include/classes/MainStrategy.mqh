#property copyright "sulaiman kadkhodaei"
#property link      "mspk7492@gmail.com"
#property version   "1.00"
#property strict
#property stacksize 1024

#include <classes\Label.mqh>
#include <classes\DMI.mqh>
#include <classes\StarProfitChannel.mqh>
#include <classes\RSI.mqh>
#include <classes\ForexProfitSupreme.mqh>
#include <classes\buysellarrowscalper.mqh>
#include <classes\PriceBorder.mqh>
#include <classes\StdDev.mqh>
#include <classes\QuoteGroup.mqh>

class MainStrategy{
private:
   void showBalanceDetails();
   void checkForClosingAll();
   void checkForTPClosingAll();
   void checkForFirstStepRegularOpening();
   void checkForOpeningAll();
   void openFirstStepRegular(TRADE_TYPE tradeType);
   void checkForOpening(bool shouldCheckForFirstStep);
   void checkForFirstStepSwitchOpening(Quote &previousQuote);
   void checkForOtherStepsOpening(Quote &q);
   void checkForClosing(int packType);
   void checkForTPClosing(int packType);
   void quoteClosing(Quote &q);
   void quoteTPClosing(Quote &q);
   void closeWholePackNo(Quote &q);
   double getProfitOfWholePackNo(Quote &q);
   bool getSwitchSignal(Quote &q);
   bool getSwitch1Signal(Quote &q);
   bool getSwitch2Signal(Quote &q);
   bool getSwitch3Signal(Quote &q);

   double lots[10];
   double tps[10];
   double lotSwitches[10];
   double mapLots[10];

   int differences[10];
   int differences1[10];
   
   DMI dmiSignal;
   DMI dmiSwitch1;
   DMI dmiSwitch2;
   DMI dmiSwitch3;
   
   StarProfitChannel spcSignal;
   StarProfitChannel spcSwitch1;
   StarProfitChannel spcSwitch2;
   StarProfitChannel spcSwitch3;

   RSI rsiSignal;
   RSI rsiSwitch1;
   RSI rsiSwitch2;
   RSI rsiSwitch3;

   ForexProfitSupreme fpsSignal;
   ForexProfitSupreme fpsSwitch1;
   ForexProfitSupreme fpsSwitch2;
   ForexProfitSupreme fpsSwitch3;

   Buysellarrowscalper buysellarrowscalperSignal;
   Buysellarrowscalper buysellarrowscalperSwitch1;
   Buysellarrowscalper buysellarrowscalperSwitch2;
   Buysellarrowscalper buysellarrowscalperSwitch3;

   PriceBorder priceBorderSignal;
   PriceBorder priceBorderSwitch1;
   PriceBorder priceBorderSwitch2;
   PriceBorder priceBorderSwitch3;

   StdDev stdDevSwitch1;
   StdDev stdDevSwitch2;
   StdDev stdDevSwitch3;
   
   Label labels;
   Order order;
public:
   MainStrategy();
   ~MainStrategy();
   void doStrategy();
   string symbol;
   long chart_id;
   double point;
   int period;

   int currentBalance;
   int lastBalance;
   
   void setLots(double &lots[]);
   void setTps(double &tps[]);
   void setLotSwitches(double &lotSwitches[]);
   void setMapLots(double &mapLots[]);
   void setDifferences(int &differences[]);
   void setDifferences1(int &differences1[]);
   
   int PACK_TYPES_TOTAL;
   color regularSellColor;
   color regularBuyColor;
   color switch1SellColor;
   color switch1BuyColor;
   color switch2SellColor;
   color switch2BuyColor;
   bool mapLotEnabled;
   double pack1Tp;
   double pack2Tp;
   double pack3Tp;
   
   void setDmiSignal(DMI &);
   void setDmiSwitch1(DMI &);
   void setDmiSwitch2(DMI &);
   void setDmiSwitch3(DMI &);
   
   void setSpcSignal(StarProfitChannel &);
   void setSpcSwitch1(StarProfitChannel &);
   void setSpcSwitch2(StarProfitChannel &);
   void setSpcSwitch3(StarProfitChannel &);

   void setRsiSignal(RSI &);
   void setRsiSwitch1(RSI &);
   void setRsiSwitch2(RSI &);
   void setRsiSwitch3(RSI &);

   void setFpsSignal(ForexProfitSupreme &);
   void setFpsSwitch1(ForexProfitSupreme &);
   void setFpsSwitch2(ForexProfitSupreme &);
   void setFpsSwitch3(ForexProfitSupreme &);

   void setBuysellarrowscalperSignal(Buysellarrowscalper &);
   void setBuysellarrowscalperSwitch1(Buysellarrowscalper &);
   void setBuysellarrowscalperSwitch2(Buysellarrowscalper &);
   void setBuysellarrowscalperSwitch3(Buysellarrowscalper &);

   void setPriceBorderSignal(PriceBorder &);
   void setPriceBorderSwitch1(PriceBorder &);
   void setPriceBorderSwitch2(PriceBorder &);
   void setPriceBorderSwitch3(PriceBorder &);

   void setStdDevSwitch1(StdDev &);
   void setStdDevSwitch2(StdDev &);
   void setStdDevSwitch3(StdDev &);
   
   void setLabels(Label &);
   void setOrder(Order &);
   
   bool switchFirstStepEnabled1;
   int switchFirstStepByPip1;
   bool switchFirstStepEnabled2;
   int switchFirstStepByPip2;
   bool switchFirstStepEnabled3;
   int switchFirstStepByPip3;
};

void MainStrategy::doStrategy(){
   
   showBalanceDetails();
   
   if(PACK_TYPES_TOTAL < 1){
      return;
   }
   
   checkForClosingAll();
   checkForTPClosingAll();
   
   checkForFirstStepRegularOpening();
   checkForOpeningAll();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////OPENING/////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
void MainStrategy::checkForFirstStepRegularOpening(){
   TRADE_TYPE tradeType = getRegularSignal();
   
   if(tradeType == BUY || tradeType == BOTH){
      openFirstStepRegular(BUY);
   }
   
   if(tradeType == SELL || tradeType == BOTH){
      openFirstStepRegular(SELL);
   }
}

void MainStrategy::openFirstStepRegular(TRADE_TYPE tradeType){
   QuoteGroup regular(symbol);
   if(!regular.isSwitchPlaced(tradeType)){
      return;
   }
   order.placeOrder(tradeType == BUY ? OP_BUY : OP_SELL,
                    tradeType == BUY ? BUY_MAGIC_NUMBER : SELL_MAGIC_NUMBER,
                    lots[0],
                    QuoteEncodeDecode().encodeQuote(tradeType, 1, REGULAR, regular.getLastPackNoByTradeTypeAndPackType(tradeType, REGULAR) + 1),
                    tradeType == BUY ? regularBuyColor : regularSellColor);
}

void MainStrategy::checkForOpeningAll(){
   for(int packType = 0; packType < PACK_TYPES_TOTAL; packType++){
      checkForOpening(packType != PACK_TYPES_TOTAL - 1);
   }
}

void MainStrategy::checkForOpening(bool shouldCheckForFirstStep){
   QuoteGroup quoteGroup(symbol);
   quoteGroup.gatherUniquePacks();
   int total = quoteGroup.quoteSize;
   
   for(int i = 0; i < total; i++){
      Quote q = quoteGroup.quote[i];
      if(shouldCheckForFirstStep && getSwitchSignal(q)){
         checkForFirstStepSwitchOpening(q);
      }
      checkForOtherStepsOpening(q);
   }
}

void MainStrategy::checkForFirstStepSwitchOpening(Quote &previousQuote){
   Quote switchQuote;
   switchQuote.tradeType = previousQuote.tradeType == BUY ? SELL : BUY;
   switchQuote.tradeNo   = 1;
   switchQuote.packType  = previousQuote.packType == REGULAR ? SWITCH1 : SWITCH2;
   switchQuote.packNo    = previousQuote.packNo;
   
   QuoteGroup quoteGroup(symbol);
   if(!quoteGroup.isQuoteExist(switchQuote)){
   
      int switchTradeNo = 1;
      if(switchQuote.packType == SWITCH1 && mapLotEnabled){
         switchTradeNo += quoteGroup.getLastTradeNo(previousQuote);
      }
      
      int cmd = switchQuote.tradeType == BUY ? OP_BUY : OP_SELL;
      int magic = switchQuote.tradeType == BUY ? SWITCH_BUY_MAGIC_NUMBER : SWITCH_SELL_MAGIC_NUMBER;
      double lot = lotSwitches[switchTradeNo - 1];
      string comment = QuoteEncodeDecode().encodeQuote(switchQuote.tradeType, switchTradeNo, switchQuote.packType, switchQuote.packNo);
      color clr = switchQuote.tradeType == BUY ? switch1BuyColor : switch1SellColor;
      order.placeOrder(cmd, magic, lot, comment, clr);
   }
}

void MainStrategy::checkForOtherStepsOpening(Quote &q){
   QuoteGroup quoteGroup(symbol);
   double lastStepOpenPrice = quoteGroup.getOpenPriceLastTicket(q);
   int lastTradeNo = quoteGroup.getLastTradeNo(q);
   double difference = getDifferenceByStepAndPackType(lastTradeNo, q.packType)*point;
   
   if(q.tradeType == BUY && Ask <= lastStepOpenPrice - difference){
      int magic = BUY_MAGIC_NUMBER;
      double lot = lots[lastTradeNo];
      color clr = regularBuyColor;
      if(q.packType == SWITCH1){
         magic = SWITCH_BUY_MAGIC_NUMBER;
         lot = lotSwitches[lastTradeNo];
         clr = switch1BuyColor;
      }
      order.placeOrder(OP_BUY, magic, lot, QuoteEncodeDecode().encodeQuote(BUY, lastTradeNo + 1, q.packType, q.packNo), clr);
   }
   
   if(q.tradeType == SELL && Bid >= lastStepOpenPrice + difference){
      int magic = SELL_MAGIC_NUMBER;
      double lot = lots[lastTradeNo];
      color clr = regularSellColor;
      if(q.packType == SWITCH1){
         magic = SWITCH_SELL_MAGIC_NUMBER;
         lot = lotSwitches[lastTradeNo];
         clr = switch1SellColor;
      }
      order.placeOrder(OP_SELL, magic, lot, QuoteEncodeDecode().encodeQuote(SELL, lastTradeNo + 1, q.packType, q.packNo), clr);
   }
}

//////////////////////////////////////////////////////////////////////////////////
///////////////////////////////CLOSING///////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
void MainStrategy::checkForClosingAll(){
   for(int packType = PACK_TYPES_TOTAL - 1; packType >= 0; packType--){
      checkForClosing(packType);
   }
}

void MainStrategy::checkForTPClosingAll(){
   for(int packType = PACK_TYPES_TOTAL - 1; packType >= 0; packType--){
      checkForTPClosing(packType);
   }
}

void MainStrategy::checkForClosing(int packType){
   QuoteGroup quoteGroup(symbol);
   quoteGroup.gatherExsitedPacksByPackType(packType);
   int total = quoteGroup.quoteSize;
   
   for(int i = 0; i < total; i++){
      Quote q = quoteGroup.quote[i];
      if(quoteGroup.hasUpperPackType(q)){
         continue;
      }
      quoteClosing(q);
   }
}

void MainStrategy::checkForTPClosing(int packType){
   QuoteGroup quotes(symbol);
   quotes.gatherAllQoutesByPackType(packType);
   int total = quotes.quoteSize;
   
   for(int i = 0; i < total; i++){
      Quote q = quotes.quote[i];
      if(quotes.hasUpperPackType(q)){
         continue;
      }
      
      if(quotes.getLastTradeNo(q) != q.tradeNo){
         continue;
      }
      
      quoteTPClosing(q);
   }
}

void MainStrategy::quoteClosing(Quote &q){
   double targetProfit = pack1Tp;
   
   switch(q.packType){  
      case 1 : targetProfit = pack2Tp;break;
      case 2 : targetProfit = pack3Tp;
   }
   
   double profit = getProfitOfWholePackNo(q);
   if(profit >= targetProfit){
      Print("close packNo = " + (string)q.packNo + " profit = " + (string)profit + ", targetProfit = " + (string)targetProfit);
      closeWholePackNo(q);
   }
   
}
void MainStrategy::quoteTPClosing(Quote &q){
   double targetProfit = tps[q.tradeNo - 1];
   double profit = getProfitOfWholePackNo(q);
      
   if(profit >= targetProfit){
      Print("close packNo = " + (string)q.packNo + " by tp, profit = " + (string)profit + ", targetProfit = " + (string)targetProfit);
      closeWholePackNo(q);
   }
}

void MainStrategy::closeWholePackNo(Quote &q){
   int tradeType = q.tradeType;
   for(int packType = q.packType; packType >= 0; packType--){
      order.close(tradeType, ALL_TRADES, packType, q.packNo);
      if(tradeType == BUY){
         tradeType = SELL;
      }else{
         tradeType = BUY;
      }
   }
}

double MainStrategy::getProfitOfWholePackNo(Quote &q){
   double profit = 0;
   int tradeType = q.tradeType;
   
   for(int packType = q.packType; packType >= 0; packType--){
      profit += order.getProfit(tradeType, ALL_TRADES, packType, q.packNo);
      if(tradeType == BUY){
         tradeType = SELL;
      }else{
         tradeType = BUY;
      }
   }
   
   return profit;
}
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////SIGNALS/////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
bool MainStrategy::getSwitchSignal(Quote &q){
   return getSwitch1Signal(q) || getSwitch2Signal(q) || getSwitch3Signal(q);
}

bool MainStrategy::getSwitch3Signal(Quote &q){
   bool preConditions[8];
   preConditions[0] = stdDevSwitch3.getEnabled(); 
   preConditions[1] = dmiSwitch3.getEnabled(); 
   preConditions[2] = spcSwitch3.getEnabled(); 
   preConditions[3] = rsiSwitch3.getEnabled(); 
   preConditions[4] = switchFirstStepEnabled3; 
   preConditions[5] = fpsSwitch3.getEnabled(); 
   preConditions[6] = buysellarrowscalperSwitch3.getEnabled();
   preConditions[7] = priceBorderSwitch3.getEnabled();
   
   bool signals[8];
   signals[0] = stdDevSwitch3.getSignal() == BOTH;
   signals[1] = dmiSwitch3.getSignalByDMIColor() != q.tradeType;
   signals[2] = spcSwitch3.getSignalByLimit() == BOTH;
   signals[3] = rsiSwitch3.getSignal() != q.tradeType;
   double priceDiff = (QuoteGroup(symbol).getOpenPriceFirstTicket(q) - order.getCurrentPrice())/point;
   priceDiff = (q.tradeType == BUY ? priceDiff : -1*priceDiff);
   signals[4] = priceDiff >= switchFirstStepByPip3;
   signals[5] = fpsSwitch3.getSignal() != q.tradeType;
   signals[6] = buysellarrowscalperSwitch3.getSignal() != q.tradeType;
   signals[7] = priceBorderSwitch3.getSignal() != q.tradeType;

   return switchResult(3, preConditions, signals, q.getCode());
}

bool MainStrategy::getSwitch2Signal(Quote &q){
   bool preConditions[8];
   preConditions[0] = stdDevSwitch2.getEnabled(); 
   preConditions[1] = dmiSwitch2.getEnabled(); 
   preConditions[2] = spcSwitch2.getEnabled(); 
   preConditions[3] = rsiSwitch2.getEnabled(); 
   preConditions[4] = switchFirstStepEnabled2; 
   preConditions[5] = fpsSwitch2.getEnabled(); 
   preConditions[6] = buysellarrowscalperSwitch2.getEnabled();
   preConditions[7] = priceBorderSwitch2.getEnabled();
   
   bool signals[8];
   signals[0] = stdDevSwitch2.getSignal() == BOTH;
   signals[1] = dmiSwitch2.getSignalByDMIColor() != q.tradeType;
   signals[2] = spcSwitch2.getSignalByLimit();
   signals[3] = rsiSwitch2.getSignal() != q.tradeType;
   double priceDiff = (QuoteGroup(symbol).getOpenPriceFirstTicket(q) - order.getCurrentPrice())/point;
   priceDiff = (q.tradeType == BUY ? priceDiff : -1*priceDiff);
   signals[4] = priceDiff >= switchFirstStepByPip2;
   signals[5] = fpsSwitch2.getSignal() != q.tradeType;
   signals[6] = buysellarrowscalperSwitch2.getSignal() != q.tradeType;
   signals[7] = priceBorderSwitch2.getSignal() != q.tradeType;

   return switchResult(2, preConditions, signals, q.getCode());
}

bool MainStrategy::getSwitch1Signal(Quote &q){
   bool preConditions[8];
   preConditions[0] = stdDevSwitch1.getEnabled(); 
   preConditions[1] = dmiSwitch1.getEnabled(); 
   preConditions[2] = spcSwitch1.getEnabled(); 
   preConditions[3] = rsiSwitch1.getEnabled();
   preConditions[4] = switchFirstStepEnabled1; 
   preConditions[5] = fpsSwitch1.getEnabled(); 
   preConditions[6] = buysellarrowscalperSwitch1.getEnabled();
   preConditions[7] = priceBorderSwitch1.getEnabled();
   
   bool signals[8];
   signals[0] = stdDevSwitch1.getSignal() == BOTH;
   signals[1] = dmiSwitch1.getSignalByDMIColor() != q.tradeType;
   signals[2] = spcSwitch1.getSignalByLimit();
   signals[3] = rsiSwitch1.getSignal() != q.tradeType;
   double priceDiff = (QuoteGroup(symbol).getOpenPriceFirstTicket(q) - order.getCurrentPrice())/point;
   priceDiff = (q.tradeType == BUY ? priceDiff : -1*priceDiff);
   signals[4] = priceDiff >= switchFirstStepByPip1;
   signals[5] = fpsSwitch1.getSignal() != q.tradeType;
   signals[6] = buysellarrowscalperSwitch1.getSignal() != q.tradeType;
   signals[7] = priceBorderSwitch1.getSignal() != q.tradeType;

   return switchResult(1, preConditions, signals, q.getCode());
}

bool switchResult(int switchNo, bool &preConditions[], bool &signals[], string code){
   bool result = false;
   bool flag = false;
   for(int i = 0;i < 8;i++){
      if(preConditions[i]){
         if(!signals[i]){
            switch(i){
               case 0 : Print(code + "stdDev does not accept for switch" + (string)switchNo);break;
               case 1 : Print(code + "DMI does not accept for switch" + (string)switchNo);break;
               case 2 : Print(code + "Dip does not accept for switch" + (string)switchNo);break;
               case 3 : Print(code + "RSI does not accept for switch" + (string)switchNo);break;
               case 4 : Print(code + "firstStep does not accept for switch" + (string)switchNo);break;
               case 5 : Print(code + "ForexProfitSupreme does not accept for switch" + (string)switchNo);break;
               case 6 : Print(code + "BuyerSeller does not accept for switch" + (string)switchNo);break;
               case 7 : Print(code + "PriceBorder does not accept for switch" + (string)switchNo);break;
            }
         }
         if(!flag){
            result = signals[i];
         }else{
            result = result && signals[i];
         }
         flag = true;
      }
   }
   return result;
   
}

TRADE_TYPE getRegularSignal(){ 

   bool preConditions[7];
   preConditions[0] = dmiSignal.getEnabled(); 
   preConditions[1] = dmiSignal.getOverEnabled(); 
   preConditions[2] = spcSignal.getEnabled(); 
   preConditions[3] = rsiSignal.getEnabled();
   preConditions[4] = fpsSignal.getEnabled();
   preConditions[5] = buysellarrowscalperSignal.getEnabled(); 
   preConditions[6] = priceBorderSignal.getEnabled();
   
   TRADE_TYPE signals[7];
   signals[0] = dmiSignal.getSignalByDMIColor();
   signals[1] = dmiSignal.getSignalByDMIOver();
   signals[2] = spcSignal.getSignal();
   signals[3] = rsiSignal.getSignal();
   signals[4] = fpsSignal.getSignal();
   signals[5] = buysellarrowscalperSignal.getSignal(); 
   signals[6] = priceBorderSignal.getSignal();
   
   TRADE_TYPE result = NONE;
   bool flag = false;
   for(int i = 0;i < 7;i++){
      if(preConditions[i]){
         if(signals[i] == NONE){
            switch(i){
               case 0 : Print("dmi does not accept for signal");break;
               case 1 : Print("dmiOver does not accept for signal");break;
               case 2 : Print("Dip does not accept for signal");break;
               case 3 : Print("RSI does not accept for signal");break;
               case 4 : Print("ForexProfitSupreme does not accept for signal");break;
               case 5 : Print("BuyerSeller does not accept for signal");break;
               case 6 : Print("PriceBorder does not accept for signal");break;
            }
            return NONE;
         }
         if(!flag){
            result = signals[i];
         }else{
            if(signals[i] == BOTH && result == NONE){
               result = BOTH;
               continue;
            }
            
            if(result == BOTH){
               result = signals[i];
            }else if((signals[i] == SELL && result == BUY) || (signals[i] == BUY && result == SELL)){
               switch(i){
                  case 0 : Print("dmi = " + (signals[i] == SELL ? "SELL" : "BUY"));break;
                  case 1 : Print("dmiOver = " + (signals[i] == SELL ? "SELL" : "BUY"));break;
                  case 2 : Print("Dip " + (signals[i] == SELL ? "SELL" : "BUY"));break;
                  case 3 : Print("RSI = " + (signals[i] == SELL ? "SELL" : "BUY"));break;
                  case 4 : Print("ForexProfitSupreme = " + (signals[i] == SELL ? "SELL" : "BUY"));break;
                  case 5 : Print("BuyerSeller = " + (signals[i] == SELL ? "SELL" : "BUY"));break;
                  case 6 : Print("PriceBorder does not match");break;
               }
               return NONE;
            }
         }
         flag = true;
      }
   }
   return result;
}

// OTHERS
/////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
int getDifferenceByStepAndPackType(int tradeNo, int packType){
   switch(packType){
      case SWITCH1:
         return differences1[tradeNo];
   }
   return differences[tradeNo];
}

void MainStrategy::showBalanceDetails(){
   int balance = (int)AccountBalance();
   if(currentBalance != balance){
      lastBalance = (int)currentBalance;
      currentBalance = (int)balance;  
   }
   
   labels.LabelTextChange(chart_id, "lastBalance", "lastBalance = " + (string)lastBalance);
   labels.LabelTextChange(chart_id, "currentBalance", "currentBalance = " + (string)currentBalance);
   
   double reBuy = 0;
   double reSell = 0;
   double sw1Buy = 0;
   double sw1Sell = 0;
   double sw2Buy = 0;
   double sw2Sell = 0;
   
   QuoteGroup quoteGroup(symbol);
   quoteGroup.gatherUniquePacks();
   int total = quoteGroup.quoteSize;
   
   
   for(int i = 0; i < total; i++){
      Quote q = quoteGroup.quote[i];
      double profit = order.getProfit(q.tradeType, ALL_TRADES, q.packType, q.packNo);
      switch(q.packType){
         case REGULAR :
               if(q.tradeType == BUY){
                  reBuy += profit;
               }else{
                  reSell += profit;
               }
            break;
         case SWITCH1 :
               if(q.tradeType == BUY){
                  sw1Buy += profit;
               }else{
                  sw1Sell += profit;
               }
            break;
         case SWITCH2 :
               if(q.tradeType == BUY){
                  sw2Buy += profit;
               }else{
                  sw2Sell += profit;
               }
            break;
      }
   }
   
   labels.LabelTextChange(chart_id, "reBuy", "reBuy = " + (string)reBuy);
   labels.LabelTextChange(chart_id, "reSell", "reSell = " + (string)reSell);
   labels.LabelTextChange(chart_id, "sw1Buy", "sw1Buy = " + (string)sw1Buy);
   labels.LabelTextChange(chart_id, "sw1Sell", "sw1Sell = " + (string)sw1Sell);
   labels.LabelTextChange(chart_id, "sw2Buy", "sw2Buy = " + (string)sw2Buy);
   labels.LabelTextChange(chart_id, "sw2Sell", "sw2Sell = " + (string)sw2Sell);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////SETTERS////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

MainStrategy::MainStrategy(){}
MainStrategy::~MainStrategy(){}

void MainStrategy::setLots(double &a[]){
   for(int i = 0; i < 10; i++){
      lots[i] = a[i];
   }
}
void MainStrategy::setTps(double &a[]){
   for(int i = 0; i < 10; i++){
      tps[i] = a[i];
   }
}
void MainStrategy::setLotSwitches(double &a[]){
   for(int i = 0; i < 10; i++){
      lotSwitches[i] = a[i];
   }
}
void MainStrategy::setMapLots(double &a[]){
   for(int i = 0; i < 10; i++){
      mapLots[i] = a[i];
   }
}
void MainStrategy::setDifferences(int &a[]){
   for(int i = 0; i < 10; i++){
      differences[i] = a[i];
   }
}
void MainStrategy::setDifferences1(int &a[]){
   for(int i = 0; i < 10; i++){
      differences1[i] = a[i];
   }
}

void MainStrategy::setDmiSignal(DMI &right){
   dmiSignal.copy(right);
}

void MainStrategy::setDmiSwitch1(DMI &right){
   dmiSwitch1.copy(right);
}
void MainStrategy::setDmiSwitch2(DMI &right){
   dmiSwitch2.copy(right);
}
void MainStrategy::setDmiSwitch3(DMI &right){
   dmiSwitch3.copy(right);
}
   
void MainStrategy::setSpcSignal(StarProfitChannel &right){
   spcSignal.copy(right);
}
void MainStrategy::setSpcSwitch1(StarProfitChannel &right){
   spcSwitch1.copy(right);
}
void MainStrategy::setSpcSwitch2(StarProfitChannel &right){
   spcSwitch2.copy(right);
}
void MainStrategy::setSpcSwitch3(StarProfitChannel &right){
   spcSwitch3.copy(right);
}

void MainStrategy::setRsiSignal(RSI &right){
   rsiSignal.copy(right);
}
void MainStrategy::setRsiSwitch1(RSI &right){
   rsiSwitch1.copy(right);
}
void MainStrategy::setRsiSwitch2(RSI &right){
   rsiSwitch2.copy(right);
}
void MainStrategy::setRsiSwitch3(RSI &right){
   rsiSwitch3.copy(right);
}

void MainStrategy::setFpsSignal(ForexProfitSupreme &right){
   fpsSignal.copy(right);
}
void MainStrategy::setFpsSwitch1(ForexProfitSupreme &right){
   fpsSwitch1.copy(right);
}
void MainStrategy::setFpsSwitch2(ForexProfitSupreme &right){
   fpsSwitch2.copy(right);
}
void MainStrategy::setFpsSwitch3(ForexProfitSupreme &right){
   fpsSwitch3.copy(right);
}

void MainStrategy::setBuysellarrowscalperSignal(Buysellarrowscalper &right){
   buysellarrowscalperSignal.copy(right);
}
void MainStrategy::setBuysellarrowscalperSwitch1(Buysellarrowscalper &right){
   buysellarrowscalperSwitch1.copy(right);
}
void MainStrategy::setBuysellarrowscalperSwitch2(Buysellarrowscalper &right){
   buysellarrowscalperSwitch2.copy(right);
}
void MainStrategy::setBuysellarrowscalperSwitch3(Buysellarrowscalper &right){
   buysellarrowscalperSwitch3.copy(right);
}

void MainStrategy::setPriceBorderSignal(PriceBorder &right){
   priceBorderSignal.copy(right);
}
void MainStrategy::setPriceBorderSwitch1(PriceBorder &right){
   priceBorderSwitch1.copy(right);
}
void MainStrategy::setPriceBorderSwitch2(PriceBorder &right){
   priceBorderSwitch2.copy(right);
}
void MainStrategy::setPriceBorderSwitch3(PriceBorder &right){
   priceBorderSwitch3.copy(right);
}

void MainStrategy::setStdDevSwitch1(StdDev &right){
   stdDevSwitch1.copy(right);
}
void MainStrategy::setStdDevSwitch2(StdDev &right){
   stdDevSwitch2.copy(right);
}
void MainStrategy::setStdDevSwitch3(StdDev &right){
   stdDevSwitch3.copy(right);
}

void MainStrategy::setLabels(Label &right){
   labels = right;
}

void MainStrategy::setOrder(Order &right){
   order.copy(right);
}