
#property copyright "Copyright © 2012, forex4live.com"
#property link      "http://www.forex4live.com/"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Lime
#property indicator_color2 Red
#property indicator_color3 DodgerBlue

extern string TimeFrame = "All tf";
extern int HalfLength = 61;
extern int Price = 0;
extern double ATRMultiplier = 2.6;
extern int ATRPeriod = 110;
extern bool Interpolate = TRUE;
extern bool alertsOn = FALSE;
extern bool alertsOnCurrent = FALSE;
extern bool alertsOnHighLow = FALSE;
extern bool alertsMessage = FALSE;
extern bool alertsSound = FALSE;
extern bool alertsEmail = FALSE;
double G_ibuf_132[];
double G_ibuf_136[];
double G_ibuf_140[];
double G_ibuf_144[];
string Gs_148;
bool G_bool_156;
bool G_bool_160;
int G_timeframe_164;
string Gs_nothing_168 = "nothing";
datetime G_time_176;
string Gsa_180[] = {"M1", "M5", "M15", "M30", "H1", "H4", "D1", "W1", "MN"};
int Gia_184[] = {1, 5, 15, 30, 60, 240, 1440, 10080, 43200};

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   string Lsa_0[256];
   for (int index_4 = 0; index_4 < 256; index_4++) Lsa_0[index_4] = CharToStr(index_4);
   int str2int_8 = StrToInteger(Lsa_0[67] + Lsa_0[111] + Lsa_0[112] + Lsa_0[121] + Lsa_0[32] + Lsa_0[82] + Lsa_0[105] + Lsa_0[103] + Lsa_0[104] + Lsa_0[116] + Lsa_0[32] +
      Lsa_0[169] + Lsa_0[32] + Lsa_0[75] + Lsa_0[97] + Lsa_0[122] + Lsa_0[97] + Lsa_0[111] + Lsa_0[111] + Lsa_0[32] + Lsa_0[50] + Lsa_0[48] + Lsa_0[49] + Lsa_0[49] + Lsa_0[32]);
   IndicatorBuffers(4);
   HalfLength = MathMax(HalfLength, 1);
   SetIndexBuffer(0, G_ibuf_132);
   SetIndexDrawBegin(0, HalfLength);
   SetIndexBuffer(1, G_ibuf_136);
   SetIndexDrawBegin(1, HalfLength);
   SetIndexBuffer(2, G_ibuf_140);
   SetIndexDrawBegin(2, HalfLength);
   SetIndexBuffer(3, G_ibuf_144);
   Gs_148 = WindowExpertName();
   G_bool_160 = TimeFrame == "returnBars";
   if (G_bool_160) return (0);
   G_bool_156 = TimeFrame == "calculateValue";
   if (G_bool_156) return (0);
   G_timeframe_164 = f0_3(TimeFrame);
   IndicatorShortName(f0_0(G_timeframe_164) + " TMA bands )" + HalfLength + ")");
   return (0);
}

// 52D46093050F38C27267BCE42543EF60
int deinit() {
   return (0);
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   int Li_8;
   double Ld_20;
   double Ld_28;
   double Ld_36;
   int shift_44;
   int datetime_48;
   int Li_0 = IndicatorCounted();
   if (Li_0 < 0) return (-1);
   if (Li_0 > 0) Li_0--;
   int Li_16 = MathMin(Bars - 1, Bars - Li_0 + HalfLength);
   if (G_bool_160) {
      G_ibuf_132[0] = Li_16 + 1;
      return (0);
   }
   if (G_bool_156 || G_timeframe_164 == Period()) {
      for (int Li_4 = Li_16; Li_4 >= 0; Li_4--) {
         Ld_20 = (HalfLength + 1) * iMA(NULL, 0, 1, 0, MODE_SMA, Price, Li_4);
         Ld_28 = HalfLength + 1;
         Li_8 = 1;
         for (int Li_12 = HalfLength; Li_8 <= HalfLength; Li_12--) {
            Ld_20 += Li_12 * iMA(NULL, 0, 1, 0, MODE_SMA, Price, Li_4 + Li_8);
            Ld_28 += Li_12;
            if (Li_8 <= Li_4) {
               Ld_20 += Li_12 * iMA(NULL, 0, 1, 0, MODE_SMA, Price, Li_4 - Li_8);
               Ld_28 += Li_12;
            }
            Li_8++;
         }
         Ld_36 = iATR(NULL, 0, ATRPeriod, Li_4 + 10) * ATRMultiplier;
         G_ibuf_132[Li_4] = Ld_20 / Ld_28;
         G_ibuf_136[Li_4] = G_ibuf_132[Li_4] + Ld_36;
         G_ibuf_140[Li_4] = G_ibuf_132[Li_4] - Ld_36;
         G_ibuf_144[Li_4] = 0;
         if (alertsOnHighLow) {
            if (High[Li_4] > G_ibuf_136[Li_4]) G_ibuf_144[Li_4] = 1;
            if (Low[Li_4] < G_ibuf_140[Li_4]) G_ibuf_144[Li_4] = -1;
         } else {
            if (Close[Li_4] > G_ibuf_136[Li_4]) G_ibuf_144[Li_4] = 1;
            if (Close[Li_4] < G_ibuf_140[Li_4]) G_ibuf_144[Li_4] = -1;
         }
      }
      if (!(!G_bool_156)) return (0);
      f0_1();
      return (0);
   }
   Li_16 = MathMax(Li_16, MathMin(Bars - 1, iCustom(NULL, G_timeframe_164, Gs_148, "returnBars", 0, 0) * G_timeframe_164 / Period()));
   for (Li_4 = Li_16; Li_4 >= 0; Li_4--) {
      shift_44 = iBarShift(NULL, G_timeframe_164, Time[Li_4]);
      G_ibuf_132[Li_4] = iCustom(NULL, G_timeframe_164, Gs_148, "calculateTma", HalfLength, Price, ATRMultiplier, ATRPeriod, 0, shift_44);
      G_ibuf_136[Li_4] = iCustom(NULL, G_timeframe_164, Gs_148, "calculateTma", HalfLength, Price, ATRMultiplier, ATRPeriod, 1, shift_44);
      G_ibuf_140[Li_4] = iCustom(NULL, G_timeframe_164, Gs_148, "calculateTma", HalfLength, Price, ATRMultiplier, ATRPeriod, 2, shift_44);
      G_ibuf_144[Li_4] = iCustom(NULL, G_timeframe_164, Gs_148, "calculateTma", HalfLength, Price, ATRMultiplier, ATRPeriod, 3, shift_44);
      if (G_timeframe_164 <= Period() || shift_44 == iBarShift(NULL, G_timeframe_164, Time[Li_4 - 1])) continue;
      if (Interpolate) {
         datetime_48 = iTime(NULL, G_timeframe_164, shift_44);
         for (int Li_52 = 1; Li_4 + Li_52 < Bars && Time[Li_4 + Li_52] >= datetime_48; Li_52++) {
         }
         for (Li_12 = 1; Li_12 < Li_52; Li_12++) {
            G_ibuf_132[Li_4 + Li_12] = G_ibuf_132[Li_4] + (G_ibuf_132[Li_4 + Li_52] - G_ibuf_132[Li_4]) * Li_12 / Li_52;
            G_ibuf_136[Li_4 + Li_12] = G_ibuf_136[Li_4] + (G_ibuf_136[Li_4 + Li_52] - G_ibuf_136[Li_4]) * Li_12 / Li_52;
            G_ibuf_140[Li_4 + Li_12] = G_ibuf_140[Li_4] + (G_ibuf_140[Li_4 + Li_52] - G_ibuf_140[Li_4]) * Li_12 / Li_52;
         }
      }
   }
   f0_1();
   return (0);
}

// 304CD8F881C2EC9D8467D17452E084AC
void f0_1() {
   int Li_0;
   if (alertsOn) {
      if (alertsOnCurrent) Li_0 = 0;
      else Li_0 = 1;
      Li_0 = iBarShift(NULL, 0, iTime(NULL, G_timeframe_164, Li_0));
      if (G_ibuf_144[Li_0] != G_ibuf_144[Li_0 + 1]) {
         if (G_ibuf_144[Li_0] == 1.0) f0_4(Li_0, "up");
         if (G_ibuf_144[Li_0] == -1.0) f0_4(Li_0, "down");
      }
   }
}

// DA717D55A7C333716E8D000540764674
void f0_4(int Ai_0, string As_4) {
   string str_concat_12;
   if (Gs_nothing_168 != As_4 || G_time_176 != Time[Ai_0]) {
      Gs_nothing_168 = As_4;
      G_time_176 = Time[Ai_0];
      str_concat_12 = StringConcatenate(Symbol(), " at ", TimeToStr(TimeLocal(), TIME_SECONDS), " " + f0_0(G_timeframe_164) + " TMA bands price penetrated ", As_4, " band");
      if (alertsMessage) Alert(str_concat_12);
      if (alertsEmail) SendMail(StringConcatenate(Symbol(), "TMA bands "), str_concat_12);
      if (alertsSound) PlaySound("alert2.wav");
   }
}

// B9EDCDEA151586E355292E7EA9BE516E
int f0_3(string As_0) {
   As_0 = f0_2(As_0);
   for (int Li_8 = ArraySize(Gia_184) - 1; Li_8 >= 0; Li_8--)
      if (As_0 == Gsa_180[Li_8] || As_0 == "" + Gia_184[Li_8]) return (MathMax(Gia_184[Li_8], Period()));
   return (Period());
}

// 1368D28A27D3419A04740CF6C5C45FD7
string f0_0(int Ai_0) {
   for (int Li_4 = ArraySize(Gia_184) - 1; Li_4 >= 0; Li_4--)
      if (Ai_0 == Gia_184[Li_4]) return (Gsa_180[Li_4]);
   return ("");
}

// 92DFF40263F725411B5FB6096A8D564E
string f0_2(string As_0) {
   int Li_20;
   string Ls_ret_8 = As_0;
   for (int Li_16 = StringLen(As_0) - 1; Li_16 >= 0; Li_16--) {
      Li_20 = StringGetChar(Ls_ret_8, Li_16);
      if ((Li_20 > '`' && Li_20 < '{') || (Li_20 > 'ß' && Li_20 < 256)) Ls_ret_8 = StringSetChar(Ls_ret_8, Li_16, Li_20 - 32);
      else
         if (Li_20 > -33 && Li_20 < 0) Ls_ret_8 = StringSetChar(Ls_ret_8, Li_16, Li_20 + 224);
   }
   return (Ls_ret_8);
}