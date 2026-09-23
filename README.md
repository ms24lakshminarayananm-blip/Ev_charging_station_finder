# EV Charging Station Finder System

A comprehensive, full-featured **3rd-Year CSE Software Engineering College Project** built using Java Servlets, JSP, JDBC, MySQL, and Apache Tomcat 9.

---

## 1. Software Requirements

- **Operating System:** Windows 10 / 11 (or Linux / macOS)
- **Java Development Kit (JDK):** JDK 8, 11, 17, 21, or 24 (ensure `JAVA_HOME` is configured)
- **Web Server:** Apache Tomcat 9 (`javax.servlet.*` specification)
- **Database:** MySQL Server 8.0+ (or MariaDB / XAMPP MySQL)
- **IDE / Code Editor:** Visual Studio Code (with "Community Server Connectors" or "Tomcat for Java" extension) or Eclipse for Enterprise Java / IntelliJ IDEA

---

## 2. Project Directory Structure

```text
27_SE/
├── database.sql                     # Full MySQL schema, 10 tables, and demo seed data
├── evcharging.war                   # Pre-compiled deployable Web Application Archive
├── build.bat                        # 1-click Windows compilation & WAR build script
├── README.md                        # Project documentation & run guide
├── TEST_CASES.md                    # Software testing test cases
├── docs/
│   ├── diagrams.md                  # All 10 Software Engineering diagrams (Mermaid format)
│   └── diagrams/                    # Individual Mermaid (.mmd) diagram files
└── src/
    └── main/
        ├── java/
        │   └── com/
        │       └── evcharging/
        │           ├── controller/  # All Servlets (Login, Booking, Payment, Station, etc.)
        │           ├── dao/         # Data Access Objects using PreparedStatement
        │           ├── model/       # Java Beans / Entity Models
        │           └── util/        # DBConnection.java (central connection provider)
        └── webapp/
            ├── css/style.css        # Responsive EV-green themed styling
            ├── js/main.js           # Client-side dynamic calculators & validation
            ├── includes/            # Common header, navbar & footer
            ├── index.jsp            # Landing homepage with featured stations
            ├── login.jsp            # User login page
            ├── register.jsp         # User registration page
            ├── user/                # EV User portal (dashboard, search, booking, payment)
            ├── owner/               # Station Owner portal (dashboard, add station, bays)
            ├── admin/               # Administrator console (approval, users, reviews)
            └── WEB-INF/
                ├── web.xml          # Servlet mappings & deployment descriptor
                ├── classes/         # Compiled bytecode (.class files)
                └── lib/             # Required JARs (servlet-api, mysql-connector-j)
```

---

## 3. MySQL Database Setup

1. Make sure your local **MySQL Server** is running (via MySQL Windows Service or XAMPP Control Panel).
2. Open MySQL Command Line Client, MySQL Workbench, or phpMyAdmin:
   ```bash
   mysql -u root -p
   ```
3. Enter your MySQL password when prompted.

---

## 4. How to Execute `database.sql`

Run the following command in PowerShell or Command Prompt from the project directory:

```powershell
mysql -u root -p < database.sql
```

Alternatively, open MySQL Workbench or phpMyAdmin:
1. Open the file `database.sql`.
2. Execute the entire script.
3. It will automatically create the database `ev_charging_db` and insert sample demo records.

---

## 5. How to Configure Database Password

Open the file:
[`src/main/java/com/evcharging/util/DBConnection.java`](file:///d:/27_SE/src/main/java/com/evcharging/util/DBConnection.java)

Locate the clearly marked configuration block:

```java
// =========================================================================
// CONFIGURE YOUR MYSQL DATABASE CREDENTIALS HERE
// Change DB_USER and DB_PASSWORD to match your local MySQL configuration.
// =========================================================================
private static final String DB_URL = "jdbc:mysql://localhost:3306/ev_charging_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
private static final String DB_USER = "root";       // <-- CHANGE IF NEEDED
private static final String DB_PASSWORD = "root";   // <-- CHANGE IF NEEDED
// =========================================================================
```

If you change the password in `DBConnection.java`, recompile the project using `build.bat` or the command:
```powershell
javac -cp "src/main/webapp/WEB-INF/lib/*" -d "src/main/webapp/WEB-INF/classes" (Get-ChildItem -Path "src/main/java" -Recurse -Filter *.java).FullName
```

---

## 6. How to Configure & Deploy on Apache Tomcat 9

### Option A: Deploying via `evcharging.war` (Recommended & Fastest)
1. Copy `evcharging.war` to your Apache Tomcat 9 installation folder:
   ```text
   C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\
   ```
2. Start Tomcat using `bin\startup.bat` or the Tomcat Windows Service.
3. Tomcat will automatically extract `evcharging.war` into an `evcharging/` directory.

### Option B: Deploying Directory Directly
1. In Tomcat's `conf\server.xml`, add the following `<Context>` inside the `<Host name="localhost" ...>` block:
   ```xml
   <Context path="/evcharging" docBase="D:/27_SE/src/main/webapp" reloadable="true" />
   ```
2. Start or restart Tomcat.

---

## 7. How to Run in VS Code

1. Install the following extensions in VS Code:
   - **Extension Pack for Java** (by Microsoft)
   - **Community Server Connectors** or **Tomcat for Java**
2. In VS Code, open the folder: `D:\27_SE`.
3. In the "Servers" panel in VS Code:
   - Click **Add Server** &rarr; Select **Apache Tomcat 9.x**.
   - Browse to your Tomcat 9 directory (e.g. `C:\tools\apache-tomcat-9.0.x`).
   - Right-click Tomcat 9 &rarr; Select **Add Deployment** &rarr; Choose folder `D:\27_SE\src\main\webapp` or file `D:\27_SE\evcharging.war`.
4. Right-click the server &rarr; Click **Start Server**.

---

## 8. How to Open in Browser

Once Tomcat is running, open your web browser and navigate to:

- **Home Page:** [http://localhost:8080/evcharging/](http://localhost:8080/evcharging/)
- **EV User Login:** [http://localhost:8080/evcharging/login.jsp](http://localhost:8080/evcharging/login.jsp)
- **Station Owner Portal:** [http://localhost:8080/evcharging/owner/login.jsp](http://localhost:8080/evcharging/owner/login.jsp)
- **Admin Console:** [http://localhost:8080/evcharging/admin/login.jsp](http://localhost:8080/evcharging/admin/login.jsp)

*(If you deployed directly to `ROOT`, visit `http://localhost:8080/` instead).*

---

## 9. Demo Login Credentials

The project comes pre-seeded with test accounts for all 3 system actors:

| Role | Username / Email | Password | Access Area |
| :--- | :--- | :--- | :--- |
| **System Administrator** | `admin` | `admin123` | [Admin Console](http://localhost:8080/evcharging/admin/login.jsp) |
| **EV Driver / User** | `user@gmail.com` | `user123` | [User Portal](http://localhost:8080/evcharging/login.jsp) |
| **Station Owner** | `owner@gmail.com` | `owner123` | [Owner Portal](http://localhost:8080/evcharging/owner/login.jsp) |

### Demo Coupons for Simulated Payment:
- **`EV10`** &rarr; 10% discount on total charge
- **`SAVE20`** &rarr; 20% discount on total charge

---

## 10. Step-by-Step Demonstration Flow

### Actor 1: EV User Flow
1. Open [http://localhost:8080/evcharging/](http://localhost:8080/evcharging/).
2. Click **Login** &rarr; Log in using `user@gmail.com` / `user123` (or click "Auto-fill Demo Credentials").
3. Click **Find Stations** &rarr; Filter by city (e.g. `Bengaluru`) or connector (`CCS2 Fast DC`).
4. Click **View Details** on *GreenVolt Fast Charging Hub*.
5. Click **Book Slot** &rarr; Choose date, preferred time (e.g. 10:00 AM), slot bay, and duration.
6. Click **Proceed to Payment** &rarr; Enter promo coupon `EV10` &rarr; Click **Apply Coupon** (see 10% discount subtracted!).
7. Select payment option (**UPI**, **Wallet**, or **Card**) &rarr; Click **Pay**.
8. View **Booking Confirmation** with unique Booking Number (`EVBK-...`) and simulated transaction ID (`TXN-EV-...`).
9. Go to **My Bookings** &rarr; View status, or click **Review** to rate 5 stars!

### Actor 2: Station Owner Flow
1. Go to [http://localhost:8080/evcharging/owner/login.jsp](http://localhost:8080/evcharging/owner/login.jsp).
2. Log in using `owner@gmail.com` / `owner123`.
3. Click **Add Station** &rarr; Fill in new station details & rate &rarr; Submit.
4. Station appears with status **PENDING APPROVAL** (not yet visible to EV users).
5. Click **Live Bay Status** &rarr; Toggle slots between `AVAILABLE`, `OCCUPIED`, and `MAINTENANCE`.

### Actor 3: System Administrator Flow
1. Go to [http://localhost:8080/evcharging/admin/login.jsp](http://localhost:8080/evcharging/admin/login.jsp).
2. Log in using `admin` / `admin123`.
3. In the Dashboard under **Stations Awaiting Approval**, locate the newly registered station.
4. Click **✓ Approve**.
5. The station status changes immediately to **APPROVED** &rarr; it now appears in public search for EV Users!
6. View registered users, station owners, all system bookings, and delete unwanted reviews.
"# Ev_charging_station_finder" 
