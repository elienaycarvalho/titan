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
  Json, A, O, AA, AO, OA, OO : TJson;
begin
  Json := TJson.Create;
  Json
    .Prop('null')
    .Prop('false', false)
    .Prop('true', true)
    .Prop('magic', 142857)
    .Prop('pi', 3.14)
    .Prop('string', 'std.json: A standart unit for json in Free Pascal');
  A := Json.Prop('array', jsArray);    
  A.Push
    .Push(false)
    .Push(true)
    .Push(142857)
    .Push(3.14)
    .Push('std.json: A standart unit for json in Free Pascal');
  AA := A.Push(jsArray);
  AO := A.Push(jsObject);        
    
  O := Json.Prop('object', jsObject);
  O.Prop('hello', 'world')
    .Prop('null')
    .Prop('false', false)
    .Prop('true', true)
    .Prop('magic', 142857)
    .Prop('pi', 3.14)
    .Prop('string', 'std.json: A standart unit for json in Free Pascal');
  OA := O.Prop('array', jsArray);
  OO := O.Prop('object', jsObject);
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
  {console}
  Json := TJson.Create;
  Json.FromFile('source.json');
  Json.Dump;
  Json.Free;
  {string}
  Json := TJson.Create('{"name": "std.json", "backends": ["LGenerics", "JsonTools"]}');
  Str := Json.ToString;
  Writeln(Str);
  Json.Free;
  {strinfigy}
  Writeln;
  Json := TJson.Create('{"name": "std.json", "backends": ["LGenerics", "JsonTools"]}');  
  Writeln('jfPretty flag');
  Writeln(Json.FormatJson);
  Str := Json.Stringify(jfPretty);  //formated json    
  //Writeln(Str);

  Writeln;
  Writeln('jfCompact flag');
  Str := Json.Stringify(jfCompact); // compact json
  Writeln(Str);

  Writeln;
  Writeln('default flag');
  Str := Json.Stringify;            // default is pretty
  Writeln(Str);
  Writeln;
  Json.Free;
end;

begin   
  //CreatingJson;
  //CreatingJsonByString;
  //DoJsonProps;
  //DoJsonBuilder;
  DoJsonInputOutput;
end.