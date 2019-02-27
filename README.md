# Codable - Class vs Struct


## Class that conforms to Codable
The class needs to provide implementations of `init(from decoder: Decoder)` and `encode(to encoder: Encoder)`
```
class EmployeeManagedObject: Codable {
    var name: String
    var isFullTime: Bool
    var hireDate: NSDate

    enum CodingKeys: String, CodingKey {
        case name, isFullTime, hireDate
    }

    init(name: String, isFullTime: Bool = true, hireDate: NSDate = NSDate()) {
        self.name = name
        self.isFullTime = isFullTime
        self.hireDate = hireDate
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        isFullTime = try values.decode(Bool.self, forKey: .isFullTime)
        hireDate = try values.decode(Date.self, forKey: .hireDate) as NSDate
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(isFullTime, forKey: .isFullTime)
        try container.encode(hireDate as Date, forKey: .hireDate)
    }
}
```
## Struct that conforms to Codable
Implementations of `init(from decoder: Decoder)` and `encode(to encoder: Encoder)` are synthesized as long as its properties are Codable. Types like String, Int, Double, Date, Bool, Data, and URL conforms to Codable
```
struct Employee: Codable {
    var name: String
    var isFullTime: Bool
    var hireDate: Date
}

// Array of Employee managed objects
let employeeManagedObjects = [EmployeeManagedObject(name: "John Snow")]

// Array of Employee structs
let employeeStructs = employeeManagedObjects.map { Employee(name: $0.name, isFullTime: $0.isFullTime, hireDate: $0.hireDate as Date) }
```

## Encoding
`JSONEncoder` encodes the data into a JSON Objects

`encode` function returns a JSON-encoded representation or employeeManagedObjects

```
let encoder = JSONEncoder()


//Encoding managed objects
if let data = try? encoder.encode(employeeManagedObjects) {
    print(data as NSData)
    print(String(data: data, encoding: .utf8) ?? "")
}

//Encoding structs
if let data = try? encoder.encode(employeeStructs) {
    print(data as NSData)
    print(String(data: data, encoding: .utf8) ?? "")
}

```

## Result
Spoiler alert. The two are exactly the same ☺️
### Encoded EmployeeManagedObject
Bytes `print(data as NSData)`
```
<5b7b226e 616d6522 3a224a6f 686e2053 6e6f7722 2c226973 46756c6c 54696d65 223a7472 75652c22 68697265 44617465 223a3537 32393232 3139302e 35373535 39353937 7d5d>
```
JSON String `print(String(data: data, encoding: .utf8) ?? "")`
```
[{"name":"John Snow","isFullTime":true,"hireDate":572922190.57559597}]
```


### Encoded Employee
Bytes `print(data as NSData)`
```
<5b7b226e 616d6522 3a224a6f 686e2053 6e6f7722 2c226973 46756c6c 54696d65 223a7472 75652c22 68697265 44617465 223a3537 32393232 3139302e 35373535 39353937 7d5d>
```
JSON String `print(String(data: data, encoding: .utf8) ?? "")`
```
[{"name":"John Snow","isFullTime":true,"hireDate":572922190.57559597}]
```

### Inspecting the bytes
Let's take the first few bytes (`5b7b226e 616d6522`) and convert them into characters

|Hex UTF8 bytes | Character |
|---------------|-----------|
|5b  | [|
|7b | {|
|22 | "|
|6e | n|
|61 | a|
|6d | m|
|65 | e|
|22 | "|
