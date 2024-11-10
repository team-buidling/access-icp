import Float "mo:base/Float";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Int "mo:base/Int";
//import Types "Types";

module TransactionTypes {
    //STATICS
    public let dayInNanoSecounds : Int = 86400000000000;
    public let SATOSHI_TO_BTC_RATE : Float = 100000000;

    //FUNCTIONS
    public func getTimeElapsed(baseTime : DateTime, receivedTime : DateTime) : Int {
        return baseTime - receivedTime;
    };

    public func didADayPassSince(baseTime : DateTime, receivedTime : DateTime) : Bool {
        var difference = getTimeElapsed(baseTime, receivedTime);
        difference >= dayInNanoSecounds;
    };

    public func daysPassedSince(baseTime : DateTime, receivedTime : DateTime) : Int {
        var difference = getTimeElapsed(baseTime, receivedTime);
        Int.div(difference, dayInNanoSecounds);
    };

    public func findAmountForCurrency(amounts : [Amount], currency : Currency) : Float {
        for (amount in amounts.vals()) {
            if (amount.currency == currency) {
                return amount.amount;
            };
        };
        return 0.0;
    };

    // COMMON TRANSACTION  TYPES
    public type Amount = {
        amount : Float;
        currency : Currency;
    };

    public type Currency = {
        #bitcoin;
        #satoshi;
        #proofOfConcept;
    };

    public type Reciever = {
        amounts : [Amount];
        percentage : Float;
        benificiary : Text;
    };

    public type Status = {
        #confirmed;
        #pending;
        #rejected;
    };

    public type TransactionType = {
        #BTC;
        #POC;
    };

    public type DateTime = Time.Time;

    //TRANSACTION DETAILS

    public type CommonTransactionDetails = {
        transactionId : Text;
        amounts : [Amount];
        receivers : [Reciever];
        receivingEntityId : Nat;
        receivingEntityName : Text;
        status : Status;
        receivedTime : DateTime;

    };

    public type BitcoinTransactionDetails = {
        commonTransactionDetails : CommonTransactionDetails;
        sourceBtcAddress : Text;
        receivingAddress : Text;
    };

    public type POCTransactionDetails = {
        commonTransactionDetails : CommonTransactionDetails;
    };

    public type TransactionTypeShared = {
        #BTC : BitcoinTransactionDetails;
        #POC : POCTransactionDetails;
    };

    public type BtcTransactionConfiramtionDetails = {
        rating : [Text];
    };
};