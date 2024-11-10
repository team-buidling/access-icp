import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Error "mo:base/Error";
import Cycles "mo:base/ExperimentalCycles";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import Text "mo:base/Text";
import Int "mo:base/Int";
import Bool "mo:base/Bool";
import Principal "mo:base/Principal";

import HttpTypes "commons/HttpTypes";
import JSON "commons/json/JSON";
import Types "Types";
import User "User";
actor class Main() {

    stable var usersArray : [User.User] = [];
    var userBuffer = Buffer.fromArray<User.User>(usersArray);

    public func getAllAcocunts() : async [Types.UserData] {
        let userData = Buffer.Buffer<Types.UserData>(0);
        for (index in usersArray.vals()) {
            let name = await index.getUserData();
            userData.add(name);
        };
        return Buffer.toArray(userData);
    };

    public shared (msg) func initiateUserData(id : Text) : async Types.UserData {

        if (Principal.equal(msg.caller, Principal.fromText("2vxsx-fae"))) {
            throw Error.reject("Login internet identity first!");
        };

        let ic : HttpTypes.IC = actor ("aaaaa-aa");

        let host : Text = "jsonplaceholder.org";
        let url = "https://" # host # "/users?id=" # id;

        let requestHeaders = [
            { name = "Host"; value = host # ":443" },
        ];

        let transformContext : HttpTypes.TransformContext = {
            function = transform;
            context = Blob.fromArray([]);
        };

        let httpRequest : HttpTypes.HttpRequestArgs = {
            url = url;
            max_response_bytes = null;
            headers = requestHeaders;
            body = null;
            method = #get;
            transform = ?transformContext;
        };

        ExperimentalCycles.add(HttpTypes.HTTP_REQUEST_CYCLES_COST);

        let httpResponse : HttpTypes.HttpResponsePayload = await ic.http_request(httpRequest);

        let responseBody : Blob = Blob.fromArray(httpResponse.body);
        let decodedResponse = switch (Text.decodeUtf8(responseBody)) {
            case (null) { throw Error.reject("Transaction Not Found!") };
            case (?decoded_text) { decoded_text };
        };
        await parseUserData(msg.caller, decodedResponse);

    };

    private func parseUserData(userPrincipal : Principal, jsonText : Text) : async Types.UserData {
        let jsonResponse : JSON.JSON = switch (JSON.parse(jsonText)) {
            case (?jsonResponse) { jsonResponse };
            case (null) { throw Error.reject("Not Valid JSON Response") };
        };
        // var rating = Buffer.Buffer<Rate>(0);
        let caller : Principal = userPrincipal;
        var id = 0;
        var firstName = "";
        var lastName = "";
        var email = "";
        var birthDate = "";

        switch (jsonResponse) {
            case (#Object(jsonResponse)) {
                for ((key, value) in jsonResponse.vals()) {
                    if (Text.equal(key, "id")) {
                        // id := #String(value);
                        switch (value) {
                            case (#Number(value)) {
                                id := Int.abs(value);
                            };
                            case (_) {};
                        };
                    };
                    if (Text.equal(key, "firstname")) {
                        switch (value) {
                            case (#String(value)) {
                                firstName := value;
                            };
                            case (_) {};
                        };
                    };
                    if (Text.equal(key, "lastname")) {
                        switch (value) {
                            case (#String(value)) {
                                lastName := value;
                            };
                            case (_) {};
                        };
                    };
                    if (Text.equal(key, "email")) {
                        switch (value) {
                            case (#String(value)) {
                                email := value;
                            };
                            case (_) {};
                        };
                    };
                    if (Text.equal(key, "birthDate")) {
                        switch (value) {
                            case (#String(value)) {
                                birthDate := value;
                            };
                            case (_) {};
                        };
                    };
                };
            };
            case (_) { throw Error.reject("Not Valid JSON Response") };
        };

        if (await checkUserExist(caller)) {
            throw Error.reject("User already exist!");
        };

        let _ = Cycles.add(20_000_000_000);
        let user = await User.User(caller, id, firstName, lastName, email, birthDate, 0);
        let _ = updateUserArray(user);

        {
            id = id;
            firstName = firstName;
            lastName = lastName;
            email = email;
            birthDate = birthDate;
            wallet = 0;
            principal = caller;
        };
    };

    private func updateUserArray(user : User.User) : async () {
        userBuffer.add(user);
        usersArray := Buffer.toArray<User.User>(userBuffer);
    };

    private func checkUserExist(caller : Principal) : async Bool {
        try {
            for (index in usersArray.vals()) {
                if (Text.equal(Principal.toText(caller), await index.getPrincipal())) {
                    return true;
                };
            };
        } catch (_) {};

        return false;
    };

    public func replenishWallet(principal : Text, amount : Nat) : async Bool {
        try {
            for (index in usersArray.vals()) {
                if (Text.equal(principal, await index.getPrincipal())) {
                    if (await index.replenishWallet(amount)) {
                        return true;
                    };
                };
            };
        } catch (_) {};

        return false;
    };

    public func deductWallet(principal : Text, amount : Nat) : async Bool {
        try {
            for (index in usersArray.vals()) {
                if (Text.equal(principal, await index.getPrincipal())) {
                    if (await index.deductWallet(amount)) {
                        return true;
                    };
                };
            };
        } catch (_) {};

        return false;
    };

    public query func transform(raw : HttpTypes.TransformArgs) : async Types.CanisterHttpResponsePayload {
        let transformed : HttpTypes.CanisterHttpResponsePayload = {
            status = raw.response.status;
            body = raw.response.body;
            headers = [
                {
                    name = "Content-Security-Policy";
                    value = "default-src 'self'";
                },
                { name = "Referrer-Policy"; value = "strict-origin" },
                { name = "Permissions-Policy"; value = "geolocation=(self)" },
                {
                    name = "Strict-Transport-Security";
                    value = "max-age=63072000";
                },
                { name = "X-Frame-Options"; value = "DENY" },
                { name = "X-Content-Type-Options"; value = "nosniff" },
            ];
        };
        transformed;
    };
};
