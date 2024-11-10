import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Types "Types";

actor class User(_principal : Principal, _id : Nat, _firstName : Text, _lastName : Text, _email : Text, _birthDate : Text, balance : Nat) {
    var principal = _principal;
    var id : Nat = _id;
    var firstName : Text = _firstName;
    var lastName : Text = _lastName;
    var email : Text = _email;
    var birthDate : Text = _birthDate;
    var userWallet : Nat = balance;

    public query func getName() : async Text {
        return firstName # " " # lastName;
    };

    public query func getPrincipal() : async Text {
        return Principal.toText(principal);
    };

    public query func getUserData() : async Types.UserData {
        {
            principal;
            id;
            firstName;
            lastName;
            email;
            birthDate;
            wallet = userWallet;
        };
    };

    public query func getBalance() : async Nat {
        return userWallet;
    };

    public func replenishWallet(price : Nat) : async Bool {
        userWallet += price;
        return true;
    };

    public func deductWallet(price : Nat) : async Bool {
        if (price > userWallet) {
            return false;
        };

        userWallet -= price;

        return true;
    };
};
