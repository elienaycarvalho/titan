program test_json;

{$mode objfpc}{$h+}{$j-}

uses
  SysUtils,
  Classes,
  std.json;

procedure CreatingJson;
var
  Json : TJson;
begin
  Json := TJson.Create;    
  Json.Free;
end;

procedure CreatingJsonByString;
var
  Json : TJson;
begin
  Json := TJson.Create('{"name": "std.json", "backends": ["LGenerics", "JsonTools"]}');
  Json.Dump;
  Json.Free;
end;

procedure DoJsonProps;
var
  Json, Arr, Obj, AA, AO, OA, OO : TJson;
begin
  Json := TJson.Create;

  Json.Prop('null');
  Json.Prop('false', false);
  Json.Prop('true', true);
  Json.Prop('magic', 142857);
  Json.Prop('pi', 3.14);
  Json.Prop('string', 'std.json: A standart unit for json in Free Pascal');

  Arr := Json.Prop('array', jsArray);    
  Arr.Push;
  Arr.Push(false);
  Arr.Push(true);
  Arr.Push(142857);
  Arr.Push(3.14);
  Arr.Push('std.json: A standart unit for json in Free Pascal');
  AA := Arr.Push(jsArray);
  AO := Arr.Push(jsObject);        
    
  Obj := Json.Prop('object', jsObject);
  Obj.Prop('hello', 'world');
  Obj.Prop('null');
  Obj.Prop('false', false);
  Obj.Prop('true', true);
  Obj.Prop('magic', 142857);
  Obj.Prop('pi', 3.14);
  Obj.Prop('string', 'std.json: A standart unit for json in Free Pascal');

  OA := Obj.Prop('array', jsArray);
  OO := Obj.Prop('object', jsObject);

  Json.Dump;
  Json.Destroy;
end;

procedure DoJsonBuilder;
var
  Json : TJsonBuilder;
begin
  Json := TJsonBuilder.Create;
  Json
    .InitObject      
      .Key('null').Null
      .Key('false').Bool(false)
      .Key('true').Bool(true)        
      .Key('magic').Number(142857)
      .Key('pi').Number(3.14)
      .Key('Hello').Str('World')
      .Key('backends')      
      .InitArray
        .Str('lgenerics')
        .Str('jsontoolsxxx')
      .TermArray      
      .Key('children')
      .InitObject
        .Key('sub').Str('object')
      .TermObject        
    .TermObject
  .Dump;
  Json.Destroy;
end;

procedure DoJsonInputOutput;
var
  Json : TJson;
  Source, Target : TStream;
  Str : string;
begin
  {file}  
  Json := TJson.Create;
  Json.FromFile('source.json');
  Json.ToFile('target.json');  
  Json.Free;
  {stream}
  Source := TFileStream.Create('source.json', fmOpenRead);
  Target := TFileStream.Create('target.json', fmCreate or fmOpenWrite); 
  Json := TJson.Create;
  Json.FromStream(Source);  
  Json.ToStream(Target);
  Json.Free;  
  Target.Free;
  Source.Free;
  {console and string}
  Json := TJson.Create;
  Json.FromFile('source.json');
  Json.Dump;              // to console (formated)
  Str := Json.AsPretty;   // to string (formated)
  Str := Json.AsCompact;  // to string (compact)
  Json.Free;
end;

begin   
  //CreatingJson;
  //CreatingJsonByString;
  DoJsonProps;
  //DoJsonBuilder;
  //DoJsonInputOutput;
end.