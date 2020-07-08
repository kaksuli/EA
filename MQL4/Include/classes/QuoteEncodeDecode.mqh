#property copyright "sulaiman kadkhodaei"
#property link      "mspk7492@gmail.com"
#property version   "1.00"
#property strict

class QuoteEncodeDecode{
private:
      static string getSubString(string text, string begin, string end);
public:
      QuoteEncodeDecode();
      ~QuoteEncodeDecode();
      static int getTradeType(string comment);
      static int getTradeNo(string comment);
      static int getPackType(string comment);
      static int getPackNo(string comment);
      static string encodeQuote(int tradeType, int tradeNo, int packType, int packNo);
};
QuoteEncodeDecode::QuoteEncodeDecode(){}
QuoteEncodeDecode::~QuoteEncodeDecode(){}

int QuoteEncodeDecode::getTradeType(string comment){
   return StrToInteger(getSubString(comment, "@", "#"));
}
int QuoteEncodeDecode::getTradeNo(string comment){
   return StrToInteger(getSubString(comment, "#", "*"));
}
int QuoteEncodeDecode::getPackType(string comment){
   return StrToInteger(getSubString(comment, "*", "$"));
}
int QuoteEncodeDecode::getPackNo(string comment){
   return StrToInteger(getSubString(comment, "$", "~"));
}

string QuoteEncodeDecode::getSubString(string text, string begin, string end){
   string result[];
   StringSplit(text, StringGetCharacter(begin, 0), result);
   StringSplit(result[1], StringGetCharacter(end, 0), result);
   return result[0];
}

string QuoteEncodeDecode::encodeQuote(int tradeType, int tradeNo, int packType, int packNo){
    return StringConcatenate("@", tradeType, "#", tradeNo, "*", packType, "$", packNo, "~");
}
