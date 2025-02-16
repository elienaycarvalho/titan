{.$define STD_JSON_FROM_LGENERICS}
{.$define STD_JSON_FROM_JSONTOLS}

{$ifndef STD_JSON_FROM_LGENERICS}
  {$ifndef STD_JSON_FROM_JSONTOLS}
    {$define STD_JSON_FROM_FPJSON}
  {$endif}
{$endif}

unit std.json;

{$mode objfpc}{$h+}{$j-}
{$modeswitch TypeHelpers}

interface

uses
  SysUtils,  
  {$ifdef STD_JSON_FROM_LGENERICS}lgjson,{$endif}
  {$ifdef STD_JSON_FROM_JSONTOLS}jsontools,{$endif}
  {$ifdef STD_JSON_FROM_FPJSON}fpjson, jsonparser,{$endif}
  Classes;

type
  TJsonStdKind = (jsNull, jsBoolean, jsNumber, jsString, jsArray, jsObject);

  {$ifdef STD_JSON_FROM_LGENERICS}
  TJson = lgjson.TJsonNode;
  TJsonPrototype = type helper for TJson
    public
      function Dump : TJson;
    //////////////////////////////
    public
      function Push : TJson; overload;
      function Push(const Value : boolean) : TJson; overload;
      function Push(const Value : double) : TJson; overload;
      function Push(const Value : string) : TJson; overload;
      function Push(const ArgKind : TJsonStdKind) : TJson; overload;

      function Prop(const Key : string) : TJson; overload;
      function Prop(const Key : string; const Value : boolean) : TJson; overload;
      function Prop(const Key : string; const Value : double) : TJson; overload;
      function Prop(const Key : string; const Value : string) : TJson; overload;
      function Prop(const Key : string; const ArgKind : TJsonStdKind) : TJson; overload;
    private
      function GetSubscribe(const Argument : string) : TJson;    
    public  
      property Subscribe [const Argument : string] : TJson read GetSubscribe; default;
  end;
  TJsonBuilder = class
    private
      JsonWriter: TJsonStrWriter;      
    public
      constructor Create;
      destructor Destroy; override;
      procedure Dump;
    public
      function InitObject : TJsonBuilder;
      function InitArray : TJsonBuilder;
      function Key(const Argument : string) : TJsonBuilder;
      function Null: TJsonBuilder;
      function Bool(const Argument : boolean) : TJsonBuilder;
      function Number(const Argument : double) : TJsonBuilder;
      function Str(const Argument : string) : TJsonBuilder;
      function TermArray : TJsonBuilder;
      function TermObject : TJsonBuilder;
  end;
  {$endif}

  {$ifdef STD_JSON_FROM_JSONTOLS}
  TJson = jsontools.TJsonNode;    
  TJsonPrototype = type helper for TJson
    public
      constructor Create;
      constructor Create(const Argument : string);
      function Dump : TJson;      
    public
      function Push : TJson; overload;
      function Push(const Value : boolean) : TJson; overload;
      function Push(const Value : double) : TJson; overload;
      function Push(const Value : string) : TJson; overload;
      function Push(const ArgKind : TJsonStdKind) : TJson; overload;

      function Prop(const Key : string) : TJson; overload;
      function Prop(const Key : string; const Value : boolean) : TJson; overload;
      function Prop(const Key : string; const Value : double) : TJson; overload;
      function Prop(const Key : string; const Value : string) : TJson; overload;
      function Prop(const Key : string; const ArgKind : TJsonStdKind) : TJson; overload;
  end;
  TJsonBuilder = class
    private
      JsonWriter: TJson;
      Cursor : TJson;
      NextKey : string;
      Containers : string;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Dump;
    public
      function InitObject : TJsonBuilder;
      function InitArray : TJsonBuilder;
      function Key(const Argument : string) : TJsonBuilder;
      function Null: TJsonBuilder;
      function Bool(const Argument : boolean) : TJsonBuilder;
      function Number(const Argument : double) : TJsonBuilder;
      function Str(const Argument : string) : TJsonBuilder;
      function TermArray : TJsonBuilder;
      function TermObject : TJsonBuilder;
  end;
  {$endif}

  {$ifdef STD_JSON_FROM_FPJSON}
  Warning: {Backend FPJSON not implemented!}
  {$endif}

implementation

{$ifdef STD_JSON_FROM_LGENERICS}

{lgenerics}
function TJsonPrototype.Push : TJson;
var
  Local : TJVariant;
begin
  if not IsArray then AsArray;
  Local := TJVariant.Null;
  Add(Local);  
  Result := Self;
end;

{lgenerics}
function TJsonPrototype.Push(const Value : boolean) : TJson;
var
  Local : TJVariant;
begin
  if not IsArray then AsArray;
  Local := Value;
  Add(Local);  
  Result := Self;
end;

{lgenerics}
function TJsonPrototype.Push(const Value : double) : TJson;
var
  Local : TJVariant;
begin
  if not IsArray then AsArray;
  Local := Value;
  Add(Local);
  Result := Self;
end;

{lgenerics}
function TJsonPrototype.Push(const Value : string) : TJson;
var
  Local : TJVariant;
begin
  if not IsArray then AsArray;
  Local := Value;
  Add(Local);  
  Result := Self;
end;

{lgenerics}
function TJsonPrototype.Push(const ArgKind : TJsonStdKind) : TJson;
begin
  if not IsArray then AsArray;
  if ArgKind = jsArray then begin
    Result := AddNode(jvkArray);
  end 
  else if ArgKind = jsObject then begin
    Result := AddNode(jvkObject);
  end
  else begin
    Writeln('Error');
  end;
end;


{lgenerics}
function TJsonPrototype.Prop(const Key : string) : TJson;
begin
  if not IsObject then AsObject;
  AddNode(Key, jvkNull);  
  Result := Self;
end;

{lgenerics}
function TJsonPrototype.Prop(const Key : string; const Value : boolean) : TJson;
var
  Node : TJson;
begin
  if not IsObject then AsObject;
  if Value then 
    Node := AddNode(Key, jvkTrue)
  else
    Node := AddNode(Key, jvkFalse);
  Result := Self;
end;

{lgenerics}
function TJsonPrototype.Prop(const Key : string; const Value : double) : TJson;
begin
  if not IsObject then AsObject;
  Add(Key, Value);
  Result := Self;
end;

{lgenerics}
function TJsonPrototype.Prop(const Key : string; const Value : string) : TJson;
begin
  if not IsObject then AsObject;
  Add(Key, Value);
  Result := Self;
end;

{lgenerics}
function TJsonPrototype.Prop(const Key : string; const ArgKind : TJsonStdKind) : TJson;
begin
  if not IsObject then AsObject;
  if ArgKind = jsArray then begin
    Result := AddNode(Key, jvkArray);
  end 
  else if ArgKind = jsObject then begin
    Result := AddNode(Key, jvkObject);
  end
  else begin
    Writeln('Error');
  end;
end;

{lgenerics}
function TJsonPrototype.Dump : TJson;
begin
  System.Writeln(FormatJson);
end;

{lgenerics}
function TJsonPrototype.GetSubscribe(const Argument : string) : TJson;
var
  s : string;
begin
  s := Argument.Trim;
  if s.StartsWith('/') then begin
    if s = '/' then
      Result := Self
    else
      Result := FindPath(TJsonPtr.From(Argument))
	end 
	else if S.StartsWith('$') then begin
		if S = '$' then 
			Result := Self
		else
			Result := FindPath(S);
  end else begin
    FindOrAdd(Argument, Result);
  end;
end;

{lgenerics}
constructor TJsonBuilder.Create;
begin
  inherited Create;
  JsonWriter := TJsonStrWriter.Create;
end;

{lgenerics}
destructor TJsonBuilder.Destroy;
begin
  JsonWriter.Destroy;
  inherited Destroy;
end;

{lgenerics}
procedure TJsonBuilder.Dump;
begin
  System.Writeln(JsonWriter.JsonString);
end;

{lgenerics}
function TJsonBuilder.InitObject : TJsonBuilder;
begin
  JsonWriter.BeginObject;
  Result := Self;
end;

{lgenerics}
function TJsonBuilder.InitArray : TJsonBuilder;
begin
  JsonWriter.BeginArray;
  Result := Self;
end;

{lgenerics}
function TJsonBuilder.Key(const Argument : string) : TJsonBuilder;
begin
  JsonWriter.AddName(Argument);
  Result := Self;
end;

{lgenerics}
function TJsonBuilder.Null: TJsonBuilder;
begin
  JsonWriter.AddNull;
  Result := Self;
end;

{lgenerics}
function TJsonBuilder.Bool(const Argument : boolean) : TJsonBuilder;
begin
  if Argument then begin
    JsonWriter.AddTrue;
  end else begin
    JsonWriter.AddFalse;
  end;
  Result := Self;
end;

{lgenerics}
function TJsonBuilder.Number(const Argument : double) : TJsonBuilder;
begin
  JsonWriter.Add(Argument);
  Result := Self;
end;

{lgenerics}
function TJsonBuilder.Str(const Argument : string) : TJsonBuilder;
begin
  JsonWriter.Add(Argument);
  Result := Self;
end;

{lgenerics}
function TJsonBuilder.TermArray : TJsonBuilder;
begin
  JsonWriter.EndArray;
  Result := Self;
end;

{lgenerics}
function TJsonBuilder.TermObject : TJsonBuilder;
begin
  JsonWriter.EndObject;
  Result := Self;
end;

{$endif}

{$ifdef STD_JSON_FROM_JSONTOLS}
{jsontools}
constructor TJsonPrototype.Create;
begin
  inherited Create;
end;

{jsontools}
constructor TJsonPrototype.Create(const Argument : string);
begin
  inherited Create;
  Self.Value := Argument;
end;

{jsontools}
function TJsonPrototype.Dump : TJson;
begin
  System.Writeln(Self.Value);
  Result := Self;
end;

{jsontools}
function TJsonPrototype.Push : TJson; overload;
begin
  if Kind <> nkArray then AsArray;
  Add.AsNull;
  Result := Self;
end;

{jsontools}
function TJsonPrototype.Push(const Value : boolean) : TJson; overload;
begin
  if Kind <> nkArray then AsArray;
  Add.AsBoolean := Value;
  Result := Self;
end;

{jsontools}
function TJsonPrototype.Push(const Value : double) : TJson; overload;
begin
  if Kind <> nkArray then AsArray;
  Add.AsNumber := Value;
  Result := Self;
end;

{jsontools}
function TJsonPrototype.Push(const Value : string) : TJson; overload;
begin
  if Kind <> nkArray then AsArray;
  Add.AsString := Value;
  Result := Self;
end;

{jsontools}
function TJsonPrototype.Push(const ArgKind : TJsonStdKind) : TJson; overload;
begin
  if Kind <> nkArray then AsArray;
  Result := Add;
  if ArgKind = jsArray then begin
    Result.AsArray;
  end else if ArgKind = jsObject then begin
    Result.AsObject;
  end;
  Result := Self;
end;

{jsontools}
function TJsonPrototype.Prop(const Key : string) : TJson;
var
  Node : TJson;
begin
  if Kind <> nkObject then AsObject;
  Node := Force(Key);
  Node.Name := Key;
  Node.AsNull;
  Result := Self;
end;

{jsontools}
function TJsonPrototype.Prop(const Key : string; const Value : boolean) : TJson;
var
  Node : TJson;
begin
  if Kind <> nkObject then AsObject;
  Node := Force(Key);
  Node.Name := Key;
  Node.AsBoolean := Value;
  Result := Self;
end;

{jsontools}
function TJsonPrototype.Prop(const Key : string; const Value : double) : TJson;
var
  Node : TJson;
begin
  if Kind <> nkObject then AsObject;
  Node := Force(Key);
  Node.Name := Key;
  Node.AsNumber := Value;
  Result := Self;
end;

{jsontools}
function TJsonPrototype.Prop(const Key : string; const Value : string) : TJson;
var
  Node : TJson;
begin
  if Kind <> nkObject then AsObject;
  Node := Force(Key);
  Node.Name := Key;
  Node.AsString := Value;
  Result := Self;
end;

{jsontools}
function TJsonPrototype.Prop(const Key : string; const ArgKind : TJsonStdKind) : TJson;
begin
  if ArgKind <> jsObject then AsObject;  
  if ArgKind = jsArray then begin
    Result := Add(Key, nkArray);
  end 
  else if ArgKind = jsObject then begin
    Result := Add(key, nkObject);
  end
  else begin
    Writeln('Error');
  end;
end;

{jsontools}
constructor TJsonBuilder.Create;
begin
  inherited Create;
  JsonWriter := TJson.Create;
  Cursor := nil;
  Containers := '';
end;

{jsontools}
destructor TJsonBuilder.Destroy;
begin
  JsonWriter.Destroy;
  inherited Destroy;
end;

{jsontools}
procedure TJsonBuilder.Dump;
begin
  System.Writeln(JsonWriter.AsJson);
end;

{jsontools}
function TJsonBuilder.InitObject : TJsonBuilder;
var
  Node : TJson;
begin
  if Cursor <> nil then begin
    if Cursor.Kind = nkObject then begin
      Node := Cursor.Force(NextKey);
      Node.Name := NextKey;
    end else begin
      Node := Cursor.Add;      
    end;    
    Cursor := Node;
  end else begin
    Cursor := JsonWriter;    
  end;
  Cursor.AsObject;
  Result := Self;
end;

{jsontools}
function TJsonBuilder.InitArray : TJsonBuilder;
var
  Node : TJson;
begin
  if Cursor <> nil then begin
    if Cursor.Kind = nkObject then begin
      Node := Cursor.Force(NextKey);
      Node.Name := NextKey;
    end else begin
      Node := Cursor.Add;      
    end;    
    Cursor := Node;
  end else begin
    Cursor := JsonWriter;    
  end;
  Cursor.AsArray;
  Result := Self;
end;

{jsontools}
function TJsonBuilder.Key(const Argument : string) : TJsonBuilder;
begin
  NextKey := Argument;
  Result := Self;
end;

{jsontools}
function TJsonBuilder.Null: TJsonBuilder;
var
  Node : TJson;
begin
  if Cursor.Kind = nkObject then begin
    Node := Cursor.Force(NextKey);
    Node.Name := NextKey;
    Node.AsNull;
  end else begin
    Node := Cursor.Add;
    Node.AsNull;
  end;
  Result := Self;
end;

{jsontools}
function TJsonBuilder.Bool(const Argument : boolean) : TJsonBuilder;
var
  Node : TJson;
begin
  if Cursor.Kind = nkObject then begin
    Node := Cursor.Force(NextKey);
    Node.Name := NextKey;
    Node.AsBoolean := Argument;
  end else begin
    Node := Cursor.Add;
    Node.AsBoolean := Argument;
  end;
  Result := Self;
end;

{jsontools}
function TJsonBuilder.Number(const Argument : double) : TJsonBuilder;
var
  Node : TJson;
begin
  if Cursor.Kind = nkObject then begin
    Node := Cursor.Force(NextKey);
    Node.Name := NextKey;
    Node.AsNumber := Argument;
  end else begin
    Node := Cursor.Add;
    Node.AsNumber := Argument;
  end;
  Result := Self;
end;

{jsontools}
function TJsonBuilder.Str(const Argument : string) : TJsonBuilder;
var
  Node : TJson;
begin
  if Cursor.Kind = nkObject then begin
    Node := Cursor.Force(NextKey);
    Node.Name := NextKey;
    Node.AsString := Argument;
  end else begin
    Node := Cursor.Add;
    Node.AsString := Argument;
  end;
  Result := Self;
end;

{jsontools}
function TJsonBuilder.TermArray : TJsonBuilder;
begin  
  Containers := Containers.Substring(0, Containers.Length - 1);
  Writeln(Containers);
  Cursor := Cursor.Parent;
  Result := Self;
end;

{jsontools}
function TJsonBuilder.TermObject : TJsonBuilder;
begin
  Containers := Containers.Substring(0, Containers.Length - 1);
  Writeln(Containers);
  Cursor := Cursor.Parent;
  Result := Self;
end;

{$endif}

end.