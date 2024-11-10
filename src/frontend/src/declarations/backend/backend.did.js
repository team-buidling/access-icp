export const idlFactory = ({ IDL }) => {
  const UserData = IDL.Record({
    'id' : IDL.Nat,
    'principal' : IDL.Principal,
    'birthDate' : IDL.Text,
    'email' : IDL.Text,
    'wallet' : IDL.Nat,
    'lastName' : IDL.Text,
    'firstName' : IDL.Text,
  });
  const HttpHeader = IDL.Record({ 'value' : IDL.Text, 'name' : IDL.Text });
  const HttpResponsePayload = IDL.Record({
    'status' : IDL.Nat,
    'body' : IDL.Vec(IDL.Nat8),
    'headers' : IDL.Vec(HttpHeader),
  });
  const TransformArgs = IDL.Record({
    'context' : IDL.Vec(IDL.Nat8),
    'response' : HttpResponsePayload,
  });
  const HttpHeader__1 = IDL.Record({ 'value' : IDL.Text, 'name' : IDL.Text });
  const CanisterHttpResponsePayload = IDL.Record({
    'status' : IDL.Nat,
    'body' : IDL.Vec(IDL.Nat8),
    'headers' : IDL.Vec(HttpHeader__1),
  });
  const Main = IDL.Service({
    'deductWallet' : IDL.Func([IDL.Text, IDL.Nat], [IDL.Bool], []),
    'getAllAcocunts' : IDL.Func([], [IDL.Vec(UserData)], []),
    'initiateUserData' : IDL.Func([IDL.Text], [UserData], []),
    'replenishWallet' : IDL.Func([IDL.Text, IDL.Nat], [IDL.Bool], []),
    'transform' : IDL.Func(
        [TransformArgs],
        [CanisterHttpResponsePayload],
        ['query'],
      ),
  });
  return Main;
};
export const init = ({ IDL }) => { return []; };
