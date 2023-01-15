# edu-crud-jdbc

## Beskrivning

>I kursen Utveckling mot databaser på IT-Högskolan skulle vi efter kursens slut redovisa våra färdigheter i SQL, Normalisering samt Java mot en relationsdatabas. Detta är min redovisning från denna kurs. Parallellt med kursen på IT-Högskolan läste jag även av eget fördjupningsintresse kursen “Mastering SQL (Using MySql, Java and Go) på Udemy.

### Under kursen på IT-Högskolan lärde jag mig 

#### Databaser
>Design av relationsdatabaser. SQL-syntax för att ta fram, sätta ihop och organisera bland data. 
> - **DDL**: Skapa och ändra tables 
> - **DML**: Uppdatera och eliminera tables 
> - **DQL**: Välja ut specifik data 
> - **DCL**: Ändra och upphäva användares rättigheter i databasen 
> - **TCL**: Hantera transaktioner
 
>Skapa SQL scripts. ACID. Vikten av konsistens och hur man med hjälp av Normalisering (1NF-3NF)  skyddar konsistensen genom att eliminera anomalier och på så vis undvika redundant data.
#### Utveckling mot relationsdatabaser med Java
>Skapa och förstå javaapplikationer som nyttjar relationsdatabaser. 
> - Bädda in SQL i javakod och göra förfrågningar mot databas 
> - Skapa CRUD-applikationer 
> - Skapa Springbootapplikationer för att komma åt JPA. 
> - Använda Jdbc Interfaces: Konstruera javakod med Driver Manager, Driver, Connection, Statement, Prepare statement och Result set. 
> - JUnit: Som ett alternativt sätt att köra kod. Unit test Lifecycle. Test, BeforeEach, AfterEach, AfterAll, AfterEach.
#### Mermaid och Lucidchart
>Konstruera Entity-Relationship Diagram som illustrerar relationer i databasen och konstruera flödesscheman.
#### Vi/Vim, Gradle och Bash 
>Snabbt göra små förändringar i filer via terminalen med Vi. Skapa javaprojekt med Gradle köra och testa dessa med bashkommandon samt Dependency Management: Låna mjukvara till styrfil från gradle/maven repository. Snabbt hantera filer med Bash. 
#### Docker
>Hur man kan få tillgång till en utvecklingsmiljö utan att behöva installera en faktisk databas 
> - arbeta med ett Relationship Database Management system som MySQL eller en dokumentdatabas (MongoDB) och ha många databaser igång samtidigt.
> - Importera kommaseparerat data till en extern maskin och köra sql scripts i en extern maskin. 
> - Docker lifecycle: Run, create/rm, start/stop, pause/unpause
#### Markdown och git
>Dokumentering av projekt med ett tidsbestämt språk och version control. 

####  Entity Relationship Diagram

```mermaid
erDiagram
    Student ||--o{ Phone : has
    Student }|--o| Grade : has
    Student ||--o{ StudentSchool : attends
    School ||--o{ StudentSchool : enrolls
    Student ||--o{ StudentHobby : has
    Hobby ||--o{ StudentHobby : involves

  Student {
        int StudentId
        string Name
        int GradeId
    }
      Phone {
        int PhoneId
        int StudentId
        tinyint IsHome 
        tinyint IsJob
        tinyint IsMobile
        string number
    }
       School {
        int SchoolId
        string name
        string City
    }
        StudentSchool {
        int StudentId
        int SchoolId
    }
      Hobby {
        int HobbyId
        string name
    }
    StudentHobby {
        int StudentId
        int HobbyId
    }
     Grade {
        int GradeId
        string name
    }
```
