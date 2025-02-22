# Titan
Titan is a set of unit for Object Pascal, designed to be a standard library beyond RTL and FCL. Inspired by Phobos from the D language, it provides modern, well-structured utilities, data structures, and functionalities to enhance the Free Pascal ecosystem. Titan aims to offer a cohesive and powerful foundation for Pascal development.

Titan aims to be a frontend library that seamlessly integrates multiple other libraries, providing a unified and consistent interface for Free Pascal developers. By abstracting complexities and offering a streamlined API, Titan simplifies the use of various underlying libraries, ensuring better compatibility, maintainability, and ease of development within the Free Pascal ecosystem.

# Units
## std.json - Unified JSON Abstraction for Free Pascal

`std.json` is a unit within the Titan library that provides a unified abstraction for JSON handling in Free Pascal. It seamlessly integrates the functionality of `LGenerics.Json` and `JsonTools`, offering a consistent and easy-to-use interface for JSON parsing, serialization, and manipulation.

### Features
- **Unified API**: Abstracts `LGenerics.Json` and `JsonTools`, allowing developers to work with JSON in a consistent manner. Support for `fpjson` and others libraries is currently under development to further expand compatibility.
- **Simplified Usage**: Provides an easy-to-use interface, reducing the complexity of handling different JSON libraries.
- **Flexible Parsing and Serialization**: Supports reading and writing JSON with minimal effort.
- **Compatibility**: Ensures interoperability between different JSON implementations without requiring changes in user code.

### Documentation
For detailed documentation on `std.json`, please refer to the [JSON Documentation](doc/json.md).

## Contributions
Titan is an open-source project, and contributions are welcome! Feel free to submit issues, suggest improvements, or create pull requests.
