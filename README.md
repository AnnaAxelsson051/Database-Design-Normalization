# edu-crud-jdbc

erDiagram
Student ||--|{ StudentSchool : accepts
    School ||--|{ StudentSchool : enrolls
   Student {
        int   StudentId
        string   FirstName
        string   LastName
    }

    School {
        int   SchooltId
        string   Name
        string   City
    }
    StudentSchool {
        int   StudentId
        int   SchoolId
    }
