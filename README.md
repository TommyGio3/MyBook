# MyBook
MyBook is a book store chain for the sale of books via web.
The project is about the design and implementation of a web application for the company.

## 🎯 Goal
The main goal of the project is the creation of a web application for the sales and stock management of MyBook with a division of roles between Administrators and Users.

## 💻 Tools and languages 
🔴 Java

🔴 MySQL

🔴 Apache Tomcat

🔴 HTML

🔴 JSP

🔴 JSTL

🔴 Javascript

🔴 CSS

🔴 StarUML

## 📁 Files
The repository is composed by the following folders:

⚪️ **Codice_sorgente**: contains the source code

⚪️ **Databse**: contains the EER diagram and the SQL code of the database

⚪️ **Diagrammi UML**: contains Class diagram, Use Case diagram and Sequence diagrams

⚪️ **Test**: contains a report about the testing

## 🏛️ Design
I chose to apply the MVC (Model View Controller) pattern using beans, controllers, DAO and views.

**Beans** match the model, they are Java classes with an empty constructor (i.e. without arguments). Their properties must be accessible trough get and set methods and shouldn't contain any method for the events handling.

**Controllers** handle events. They are realized trough Java servlets.

**DAO (Data Access Object)** are the classes that interface with the database for the data retrieval and editing. They execute the queries, read them and transform them in java Beans.

**Views** present the interface. They are HTML and JSP pages. In the JSPs, in addition to Javascript and Java, the framework JSTL was used.

#### 🛠️ Utils:

In addition to the classes mentioned above, I created a package called **Utils** that contains two classes (MyBookUtils and SendMail) that have inside some static methods useful fot the program. 

In particular **MyBookUtils** contains the method ***getLastInsertId*** that returns the last id that was inserted in the DB trough a query. The class contains also a second method called ***htmlFilter*** that filters the string for special characters to try to prevent command injection attacks. There is also a third method that called ***generateNewPwd*** that generates a random password of 20 characters.

The **SendMail** class contains the ***sendEmail*** method that defines all the parameters and methods to send an email.

 


