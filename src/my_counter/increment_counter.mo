import Nat "mo:base/Nat";
import Text "mo:base/Text";

// Create a simple Counter actor.
actor Counter {
  stable var currentValue : Nat = 0;

  // Increment the counter with the increment function.
  public func increment() : async () {
    currentValue += 1;
  };

  // Read the counter value with a get function.
  public query func get() : async Nat {
    currentValue
  };

  // Write an arbitrary value with a set function.
  public func set(n: Nat) : async () {
    currentValue := n;
  };

  public type HeaderField = (Text, Text);
  public type HttpRequest = {
    url : Text;
    method : Text;
    body : Blob;
    headers : [HeaderField];
  };

  public type HttpResponse = {
    body : Blob;
    headers : [HeaderField];
    streaming_strategy : ?StreamingStrategy;
    status_code : Nat16;
  };

  public type Key = Text;

  public type StreamingCallbackToken = {
    key : Key;
    sha256 : ?[Nat8];
    index : Nat;
    content_encoding : Text;
  };

  public type StreamingCallbackHttpResponse = {
    token : ?StreamingCallbackToken;
    body : [Nat8];
  };

  public type StreamingStrategy = {
    #Callback : {
      token : StreamingCallbackToken;
      callback : shared query StreamingCallbackToken -> async ?StreamingCallbackHttpResponse;
    };
  };

  public shared query func http_request(request: HttpRequest) : async HttpResponse {
      let value: Text = Nat.toText(currentValue);
      let resp = "<html><body><h1>currentValue is " # value # "</h1></body></html>";

      {
          body = Text.encodeUtf8(resp);
          headers = [];
          streaming_strategy = null;
          status_code = 200;
      }
  }
}