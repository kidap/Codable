import Foundation

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

struct Employee: Codable {
    var name: String
    var isFullTime: Bool
    var hireDate: Date
}

// Array of Employee managed objects
let employeeManagedObjects = [EmployeeManagedObject(name: "John Snow")]

// Array of Employee structs
let employeeStructs = employeeManagedObjects.map { Employee(name: $0.name, isFullTime: $0.isFullTime, hireDate: $0.hireDate as Date) }


let encoder = JSONEncoder()


//Encoding managed objects
if let data = try? encoder.encode(employeeManagedObjects) {
    print(String(data: data, encoding: .utf8) ?? "")
}

//Encoding structs
if let data = try? encoder.encode(employeeStructs) {
    print(String(data: data, encoding: .utf8) ?? "")
}
