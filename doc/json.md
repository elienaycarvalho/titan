# std.json - Unified JSON Abstraction for Free Pascal

`std.json` is a unit within the Titan library that provides a unified abstraction for JSON handling in Free Pascal. It seamlessly integrates the functionality of `LGenerics.Json` and `JsonTools`, offering a consistent and easy-to-use interface for JSON parsing, serialization, and manipulation. 

## Features
- **Unified API**: Abstracts `LGenerics.Json` and `JsonTools`, allowing developers to work with JSON in a consistent manner. Support for `fpjson` and others libraries is currently under development to further expand compatibility.
- **Simplified Usage**: Provides an easy-to-use interface, reducing the complexity of handling different JSON libraries.
- **Flexible Parsing and Serialization**: Supports reading and writing JSON with minimal effort.
- **Compatibility**: Ensures interoperability between different JSON implementations without requiring changes in user code.

## Usage
The `std.json` unit is part of the Titan library. To use it, include it in your project:

```pascal
uses std.json;
```

### Choosing the backend
- Use the directive `{$define STD_JSON_FROM_LGENERICS}` to use the LGenerics.Json library.
- Use the directive `{$define STD_JSON_FROM_JSONTOOLS}` to use the JsonTools library.
- If none of these directives are defined, the backend used will be FPJson, which is still under development.

### Creating JSON
The most straightforward way to create a JSON:

```pascal
var
  Json : TJson;
begin
  Json := TJson.Create;    
  Json.Free;
end;
```
Creating a JSON from a string and printing the content:

```pascal
var
  Json : TJson;
begin
  Json := TJson.Create('{"name": "std.json", "backends": ["LGenerics", "JsonTools"]}');
  Json.Dump;
  Json.Free;
end;
```

### Creating JsonBuilder

The `JsonBuilder` class offers an easy way to write JSON.

```pascal
var
  Json : TJsonBuilder;
begin
  Json := TJsonBuilder.Create;
  Json.Free;
end;
```



#### Accessing properties

Use o método .Prop para definir 

```pascal
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
  Json.Free;
end;
```

#### Using JsonBuilder
```pascal

end;
```

### Why Use std.json?
By using `std.json`, developers can switch between JSON libraries without modifying their code, ensuring greater flexibility and long-term maintainability. It also simplifies JSON operations by providing a clear and unified API.

