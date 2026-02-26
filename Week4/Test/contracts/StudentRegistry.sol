// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StudentRegistry {
    // Struct
    struct Student {
        string name;
        uint256 age;
        bool present;
    }

    // State variable (array of students)
    Student[] public students;

    // Events
    event StudentAdded(uint256 indexed studentId, string name, uint256 age);
    event AttendanceUpdated(uint256 indexed studentId, bool present);

    //  Add new student
    function addStudent(string memory _name, uint256 _age) public {
        students.push(Student(_name, _age, false));

        emit StudentAdded(students.length - 1, _name, _age);
    }

    // Update attendance
    function updateAttendance(uint256 _studentId, bool _present) public {
        require(_studentId < students.length, "Student does not exist");

        students[_studentId].present = _present;

        emit AttendanceUpdated(_studentId, _present);
    }

    function getStudent(uint256 _studentId) public view returns (string memory, uint256, bool) {
        require(_studentId < students.length, "Student does not exist");

        Student memory s = students[_studentId];
        return (s.name, s.age, s.present);
    }

    function getTotalStudents() public view returns (uint256) {
        return students.length;
    }
}
