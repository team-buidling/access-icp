import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface CanisterHttpResponsePayload {
  'status' : bigint,
  'body' : Uint8Array | number[],
  'headers' : Array<HttpHeader__1>,
}
export interface HttpHeader { 'value' : string, 'name' : string }
export interface HttpHeader__1 { 'value' : string, 'name' : string }
export interface HttpResponsePayload {
  'status' : bigint,
  'body' : Uint8Array | number[],
  'headers' : Array<HttpHeader>,
}
export interface Main {
  'deductWallet' : ActorMethod<[string, bigint], boolean>,
  'getAllAcocunts' : ActorMethod<[], Array<UserData>>,
  'initiateUserData' : ActorMethod<[string], UserData>,
  'replenishWallet' : ActorMethod<[string, bigint], boolean>,
  'transform' : ActorMethod<[TransformArgs], CanisterHttpResponsePayload>,
}
export interface TransformArgs {
  'context' : Uint8Array | number[],
  'response' : HttpResponsePayload,
}
export interface UserData {
  'id' : bigint,
  'principal' : Principal,
  'birthDate' : string,
  'email' : string,
  'wallet' : bigint,
  'lastName' : string,
  'firstName' : string,
}
export interface _SERVICE extends Main {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
