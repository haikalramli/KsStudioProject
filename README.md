# KS.Studio Photography Management System

A comprehensive photography studio management system built with Java EE (Jakarta EE), JSP, and Oracle Database.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Database Setup](#database-setup)
- [Configuration](#configuration)
- [Building the Project](#building-the-project)
- [Deployment](#deployment)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)

## 🔧 Prerequisites

Before you begin, ensure you have the following installed:

| Software | Version | Download Link |
|----------|---------|---------------|
| JDK | 17 or higher | [Oracle JDK](https://www.oracle.com/java/technologies/downloads/) |
| Apache Maven | 3.8+ | [Maven Download](https://maven.apache.org/download.cgi) |
| Apache Tomcat | 10.1+ | [Tomcat Download](https://tomcat.apache.org/download-10.cgi) |
| Oracle Database | 21c XE or higher | [Oracle XE](https://www.oracle.com/database/technologies/xe-downloads.html) |
| IDE (Optional) | - | IntelliJ IDEA, Eclipse, or NetBeans |

## 📁 Project Structure

```
KSStudioFull/
├── pom.xml                          # Maven configuration file
├── README.md                        # This file
├── database/
│   └── KSStudio_Database.sql        # SQL scripts for database setup
├── src/
│   ├── main/
│   │   ├── java/                    # Java source files
│   │   │   ├── controller/          # Client-side controllers
│   │   │   ├── dao/                 # Data Access Objects
│   │   │   ├── filter/              # Servlet filters
│   │   │   ├── model/               # Data models/entities
│   │   │   ├── servlet/             # Photographer servlets
│   │   │   └── util/                # Utility classes
│   │   ├── resources/               # Configuration files
│   │   │   └── application.properties
│   │   └── webapp/                  # Web application files
│   │       ├── WEB-INF/
│   │       │   └── web.xml          # Web application descriptor
│   │       ├── assets/              # CSS, JS, images
│   │       ├── jsp/
│   │       │   ├── client/          # Client portal JSP files
│   │       │   └── photographer/    # Photographer portal JSP files
│   │       └── index.jsp            # Entry point
│   └── test/
│       └── java/                    # Test classes
└── target/                          # Build output (generated)
```

## 🚀 Installation

### Step 1: Clone or Extract the Project

```bash
# If using git
git clone <repository-url>
cd KSStudioFull

# Or extract the ZIP file
unzip KSStudioFull_Maven.zip
cd KSStudioFull
```

### Step 2: Verify Maven Installation

```bash
mvn -version
```

Expected output:
```
Apache Maven 3.x.x
Maven home: /path/to/maven
Java version: 17.x.x
```

### Step 3: Verify Java Installation

```bash
java -version
javac -version
```

## 🗄️ Database Setup

### Step 1: Start Oracle Database

Ensure your Oracle Database is running.

### Step 2: Create Database User

Connect as SYSDBA and run:

```sql
-- Create user
CREATE USER KSSTUDIOADMIN IDENTIFIED BY admin;

-- Grant privileges
GRANT CONNECT, RESOURCE, DBA TO KSSTUDIOADMIN;
GRANT CREATE SESSION TO KSSTUDIOADMIN;
GRANT UNLIMITED TABLESPACE TO KSSTUDIOADMIN;

-- For Oracle 21c XE, connect to FREEPDB1
ALTER SESSION SET CONTAINER = FREEPDB1;
```

### Step 3: Run Database Scripts

```bash
# Connect to Oracle as KSSTUDIOADMIN
sqlplus KSSTUDIOADMIN/admin@//localhost:1521/FREEPDB1

# Run the SQL script
@database/KSStudio_Database.sql
```

Or use SQL Developer to import `database/KSStudio_Database.sql`

## ⚙️ Configuration

### Database Connection

Edit `src/main/java/util/DBConnection.java`:

```java
private static final String URL = "jdbc:oracle:thin:@//localhost:1521/FREEPDB1";
private static final String USERNAME = "KSSTUDIOADMIN";
private static final String PASSWORD = "admin";
```

Or update `src/main/resources/application.properties`:

```properties
db.url=jdbc:oracle:thin:@//localhost:1521/FREEPDB1
db.username=KSSTUDIOADMIN
db.password=admin
```

## 🔨 Building the Project

### Clean and Build

```bash
# Clean previous builds
mvn clean

# Compile the project
mvn compile

# Package as WAR file
mvn package

# Or do all in one command
mvn clean package
```

### Skip Tests (if needed)

```bash
mvn clean package -DskipTests
```

### Build Output

After successful build, find the WAR file at:
```
target/KsStudio.war
```

## 📦 Deployment

### Option 1: Manual Deployment to Tomcat

1. **Copy WAR file to Tomcat:**
   ```bash
   cp target/KsStudio.war $CATALINA_HOME/webapps/
   ```

2. **Start Tomcat:**
   ```bash
   # Windows
   %CATALINA_HOME%\bin\startup.bat
   
   # Linux/Mac
   $CATALINA_HOME/bin/startup.sh
   ```

3. **Access the application:**
   ```
   http://localhost:8080/KsStudio
   ```

### Option 2: Using Maven Cargo Plugin

```bash
# Set CATALINA_HOME environment variable first
export CATALINA_HOME=/path/to/tomcat

# Deploy using Cargo
mvn cargo:deploy
```

### Option 3: IDE Deployment

#### IntelliJ IDEA:
1. Go to `Run` → `Edit Configurations`
2. Add new `Tomcat Server` → `Local`
3. Configure Tomcat installation
4. In `Deployment` tab, add artifact: `KSStudio:war exploded`
5. Click `Run`

#### Eclipse:
1. Right-click project → `Run As` → `Run on Server`
2. Select Tomcat server
3. Click `Finish`

#### NetBeans:
1. Right-click project → `Run`
2. Select server when prompted

## 🖥️ Usage

### Access Points

| Portal | URL | Description |
|--------|-----|-------------|
| Homepage | `http://localhost:8080/KsStudio/` | Public homepage |
| Client Login | `http://localhost:8080/KsStudio/jsp/client/Login.jsp` | Client portal |
| Staff Login | `http://localhost:8080/KsStudio/jsp/photographer/login.jsp` | Staff portal |

### Default Credentials

#### Staff Portal:
| Role | Email | Password |
|------|-------|----------|
| Senior | senior@ksstudio.com | password123 |
| Junior | junior@ksstudio.com | password123 |
| Intern | intern@ksstudio.com | password123 |

#### Client Portal:
Register a new account or use test accounts from database.

## 🛠️ Maven Commands Reference

| Command | Description |
|---------|-------------|
| `mvn clean` | Clean build directory |
| `mvn compile` | Compile source code |
| `mvn test` | Run unit tests |
| `mvn package` | Create WAR file |
| `mvn install` | Install to local repository |
| `mvn clean package` | Clean and build |
| `mvn dependency:tree` | Show dependency tree |
| `mvn dependency:resolve` | Download dependencies |

## 🐛 Troubleshooting

### Issue: Database Connection Failed

**Solution:**
1. Verify Oracle is running:
   ```bash
   lsnrctl status
   ```
2. Check connection string in `DBConnection.java`
3. Ensure user has proper privileges

### Issue: JSTL Tags Not Working

**Solution:**
1. Verify JSTL dependencies in `pom.xml`
2. Ensure correct taglib URI in JSP:
   ```jsp
   <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
   ```

### Issue: ClassNotFoundException for Oracle Driver

**Solution:**
1. Clean and rebuild:
   ```bash
   mvn clean package
   ```
2. Verify Oracle JDBC dependency in `pom.xml`

### Issue: 404 Error on Pages

**Solution:**
1. Check WAR deployment in Tomcat manager
2. Verify context path matches `/KsStudio`
3. Check Tomcat logs: `$CATALINA_HOME/logs/catalina.out`

### Issue: Maven Build Fails

**Solution:**
1. Update Maven:
   ```bash
   mvn wrapper:wrapper
   ```
2. Clear local repository:
   ```bash
   mvn dependency:purge-local-repository
   ```
3. Force update:
   ```bash
   mvn clean package -U
   ```

## 📝 Development Notes

### Adding New Dependencies

Add to `pom.xml`:
```xml
<dependency>
    <groupId>group-id</groupId>
    <artifactId>artifact-id</artifactId>
    <version>version</version>
</dependency>
```

Then run:
```bash
mvn dependency:resolve
```

### Creating New Servlet

1. Create Java class in `src/main/java/servlet/`
2. Annotate with `@WebServlet`
3. Extend `HttpServlet`

### Creating New JSP

1. Add JSP file in `src/main/webapp/jsp/`
2. Include proper taglib declarations
3. Use EL expressions for dynamic content

## 📄 License

This project is for educational purposes.

## 👥 Contributors

- KS.Studio Development Team

## 📞 Support

For issues and questions, please create an issue in the repository.
