# Software Engineering Diagrams: EV Charging Station Finder System

This document contains standard Software Engineering diagrams formatted in GitHub-compatible **Mermaid** syntax for a 3rd-year CSE project report and presentation.

---

## 1. Use Case Diagram

```mermaid
graph TD
    User["👤 EV User"]
    Owner["🏢 Station Owner"]
    Admin["🛡️ System Admin"]

    subgraph "EV Charging Station Finder System"
        UC1((Register / Login))
        UC2((Search & Filter Stations))
        UC3((View Station & Slot Details))
        UC4((Book Charging Slot))
        UC5((Join Waiting List))
        UC6((Simulated Payment & Apply Coupon))
        UC7((Cancel Booking))
        UC8((Give Rating & Review))

        UC9((Add Charging Station))
        UC10((Update Station & Pricing))
        UC11((Monitor Live Slot Status))
        UC12((View Station Bookings))

        UC13((Approve / Reject Station))
        UC14((Manage Users & Owners))
        UC15((Manage / Delete Reviews))
        UC16((View Dashboard Analytics))
    end

    User --> UC1
    User --> UC2
    User --> UC3
    User --> UC4
    User --> UC5
    User --> UC6
    User --> UC7
    User --> UC8

    Owner --> UC1
    Owner --> UC9
    Owner --> UC10
    Owner --> UC11
    Owner --> UC12

    Admin --> UC1
    Admin --> UC13
    Admin --> UC14
    Admin --> UC15
    Admin --> UC16
```

---

## 2. Data Flow Diagram (DFD Level 0 - Context Level)

```mermaid
graph LR
    User["EV User"]
    Owner["Station Owner"]
    Admin["System Administrator"]
    System[("0.0<br/>EV Charging Station<br/>Finder System")]

    User -- "Search queries, slot bookings, coupon codes, simulated payment, reviews" --> System
    System -- "Station listings, slot availability, booking receipt, confirmation" --> User

    Owner -- "Station specs, bay configurations, tariffs, slot status" --> System
    System -- "Booking notifications, reservation logs, revenue summary" --> Owner

    Admin -- "Station approval/rejection decisions, moderation commands" --> System
    System -- "System analytics, pending stations, user logs, moderation reports" --> Admin
```

---

## 3. Data Flow Diagram (DFD Level 1)

```mermaid
graph TD
    User["EV User"]
    Owner["Station Owner"]
    Admin["System Admin"]

    P1["1.0 Authentication & User Profiling"]
    P2["2.0 Station Discovery & Filtering"]
    P3["3.0 Slot Reservation & Waiting Queue"]
    P4["4.0 Payment Simulation & Coupon Engine"]
    P5["5.0 Station Governance & Approval"]
    P6["6.0 Reviews & Ratings Moderation"]

    D1[("D1: Users & Owners")]
    D2[("D2: Stations & Slots")]
    D3[("D3: Bookings & WaitingList")]
    D4[("D4: Payments & Coupons")]
    D5[("D5: Reviews")]

    User --> P1
    Owner --> P1
    Admin --> P1
    P1 <--> D1

    User --> P2
    D2 --> P2
    P2 --> User

    User --> P3
    P3 <--> D2
    P3 <--> D3
    P3 --> P4

    P4 <--> D4
    P4 --> D3
    P4 --> User

    Owner --> P5
    Admin --> P5
    P5 <--> D2

    User --> P6
    Admin --> P6
    P6 <--> D5
```

---

## 4. Data Flow Diagram (DFD Level 2 - Reservation & Payment Subsystem)

```mermaid
graph TD
    User["EV User"]
    P31["3.1 Validate Slot Availability"]
    P32["3.2 Queue in Waiting List"]
    P41["4.1 Validate Promo Coupon"]
    P42["4.2 Process Simulated Payment"]
    P43["4.3 Issue Booking Confirmation"]

    D2[("D2: Charging Slots")]
    D3[("D3: Bookings")]
    D3W[("D3W: Waiting List")]
    D4C[("D4C: Coupons")]
    D4P[("D4P: Payments")]

    User -- "Select Station, Date, Time, Slot" --> P31
    P31 -- "Check status & conflict" --> D2
    P31 -- "Check existing reservations" --> D3

    P31 -- "Slot Occupied" --> P32
    P32 -- "Store queued request" --> D3W
    P32 -- "Queue Acknowledgement" --> User

    P31 -- "Slot Available" --> P41
    User -- "Enter Promo Code" --> P41
    P41 -- "Verify code & compute discount" --> D4C

    P41 -- "Net Payable Amount" --> P42
    User -- "Select UPI / Card / Wallet" --> P42
    P42 -- "Generate Fake TXN ID" --> D4P
    P42 -- "Record BOOKED status" --> D3

    P42 --> P43
    P43 -- "Booking ID & Receipt" --> User
```

---

## 5. Class Diagram

```mermaid
classDiagram
    class DBConnection {
        -String DB_URL
        -String DB_USER
        -String DB_PASSWORD
        +getConnection() Connection
        +closeConnection(Connection conn)
    }

    class User {
        -int id
        -String name
        -String email
        -String password
        -String phone
        -String vehicleNumber
        -String vehicleModel
        -String status
        +getId() int
        +getName() String
    }

    class StationOwner {
        -int id
        -String name
        -String email
        -String password
        -String phone
        -String businessName
        -String address
        -String status
    }

    class Station {
        -int id
        -int ownerId
        -String name
        -String address
        -String city
        -String chargerTypes
        -String powerRating
        -BigDecimal pricePerUnit
        -int totalSlots
        -String approvalStatus
    }

    class ChargingSlot {
        -int id
        -int stationId
        -String slotNumber
        -String chargerType
        -String powerOutput
        -String status
    }

    class Booking {
        -int id
        -String bookingNumber
        -int userId
        -int stationId
        -int slotId
        -Date bookingDate
        -String startTime
        -String endTime
        -BigDecimal totalAmount
        -BigDecimal discountAmount
        -BigDecimal finalAmount
        -String status
    }

    class Payment {
        -int id
        -int bookingId
        -int userId
        -String transactionId
        -String paymentMethod
        -BigDecimal amount
        -String paymentStatus
    }

    class Coupon {
        -int id
        -String code
        -int discountPercentage
        -BigDecimal maxDiscount
        -BigDecimal minAmount
        -boolean active
    }

    class Review {
        -int id
        -int stationId
        -int userId
        -int rating
        -String reviewText
    }

    StationOwner "1" --> "*" Station : owns
    Station "1" --> "*" ChargingSlot : contains
    User "1" --> "*" Booking : reserves
    Station "1" --> "*" Booking : hosted_at
    ChargingSlot "1" --> "*" Booking : allocated_to
    Booking "1" --> "1" Payment : paid_by
    User "1" --> "*" Review : writes
    Station "1" --> "*" Review : reviewed_in
```

---

## 6. Sequence Diagram (Slot Reservation & Simulated Payment)

```mermaid
sequenceDiagram
    autonumber
    actor Driver as EV User
    participant View as JSP (book-slot / payment)
    participant BServlet as BookingServlet
    participant PServlet as PaymentServlet
    participant BDAO as BookingDAO
    participant CDAO as CouponDAO
    participant PDAO as PaymentDAO
    participant DB as MySQL Database

    Driver->>View: Select Date, Time & Slot
    View->>BServlet: POST /booking (stationId, slotId, date, time)
    BServlet->>BDAO: isSlotAvailable(slotId, date, time)
    BDAO->>DB: SELECT id FROM bookings WHERE slot_id=? AND date=?
    DB-->>BDAO: No conflicting booking
    BDAO-->>BServlet: Slot is AVAILABLE
    BServlet->>Driver: Forward to /payment.jsp (Original Amount)

    Driver->>View: Enter Coupon "EV10" & Click Apply
    View->>CDAO: getByCode("EV10")
    CDAO->>DB: SELECT * FROM coupons WHERE code='EV10'
    DB-->>CDAO: 10% Discount Valid
    View->>Driver: Display Discount & Net Final Amount

    Driver->>PServlet: POST /payment (method="UPI")
    PServlet->>BDAO: createBooking(booking)
    BDAO->>DB: INSERT INTO bookings ... status='BOOKED'
    DB-->>BDAO: Generated bookingId
    PServlet->>PDAO: createPayment(fakeTxnId, amount, "UPI")
    PDAO->>DB: INSERT INTO payments ... status='SUCCESS'
    DB-->>PDAO: Payment Saved
    PServlet-->>Driver: Redirect to /booking-confirmation (Show Booking & Txn ID)
```

---

## 7. Activity Diagram (Slot Booking & Waiting List Process)

```mermaid
flowchart TD
    Start([Start: Search Station]) --> SelectStation[Select Station from Search Results]
    SelectStation --> ViewDetails[Inspect Station Details & Connector Types]
    ViewDetails --> ChooseSlot[Choose Date, Preferred Time & Slot Bay]
    ChooseSlot --> CheckAvail{Is Selected Slot Available?}

    CheckAvail -- No: Occupied --> ShowUnavailable[Display 'Slot Unavailable' Alert]
    ShowUnavailable --> PromptWait[Prompt 'Join Waiting List']
    PromptWait --> JoinWait[User Joins Waiting List Queue]
    JoinWait --> WaitEnd([End: Added to Waiting List])

    CheckAvail -- Yes: Free --> Checkout[Proceed to Payment Checkout Summary]
    Checkout --> HasCoupon{Apply Promo Coupon?}
    HasCoupon -- Yes --> ValidateCoupon[Validate Coupon Code in DB]
    ValidateCoupon --> ApplyDiscount[Calculate Discount & Update Total]
    HasCoupon -- No --> SelectPayMethod[Select Simulated Payment Method: UPI / Card / Wallet]
    ApplyDiscount --> SelectPayMethod

    SelectPayMethod --> SubmitPay[Click 'Pay' Button]
    SubmitPay --> GenTxn[Generate Fake Transaction ID & Booking Number]
    GenTxn --> SaveRecords[Persist Booking & Payment in MySQL]
    SaveRecords --> ShowConfirm[Display Booking Confirmation Screen]
    ShowConfirm --> SuccessEnd([End: Slot Reserved Successfully])
```

---

## 8. Statechart Diagram (Booking Lifecycle)

```mermaid
stateDiagram-v2
    [*] --> INITIATED: User selects slot & begins checkout
    INITIATED --> PENDING_PAYMENT: Slot locked for checkout
    PENDING_PAYMENT --> BOOKED: Simulated payment completed successfully
    PENDING_PAYMENT --> [*]: Session timeout or abandoned

    BOOKED --> CANCELLED: User initiates booking cancellation
    BOOKED --> COMPLETED: Charging session time expired / car charged

    CANCELLED --> [*]: Slot released back to available pool
    COMPLETED --> [*]: Booking archived in user history
```

---

## 9. Component Diagram (MVC Architecture)

```mermaid
graph TD
    subgraph "View Layer (JSP / CSS / JS)"
        V1["index.jsp / login.jsp / register.jsp"]
        V2["User JSPs (dashboard, search, book, payment)"]
        V3["Owner JSPs (dashboard, add, manage, live-status)"]
        V4["Admin JSPs (dashboard, stations, users, reviews)"]
        V5["style.css & main.js"]
    end

    subgraph "Controller Layer (Java Servlets)"
        C1["Auth Servlets (Login, Register, Logout)"]
        C2["User Servlets (StationSearch, Booking, Payment, Coupon, Review)"]
        C3["Owner Servlets (AddStation, UpdateStation, OwnerPortal)"]
        C4["Admin Servlets (ApproveStation, RejectStation, ManageUsers, ManageReviews)"]
    end

    subgraph "Model Layer (JavaBeans)"
        M1["User, StationOwner, Admin"]
        M2["Station, ChargingSlot, Booking, WaitingList"]
        M3["Payment, Coupon, Review"]
    end

    subgraph "Data Access Layer (JDBC DAOs)"
        D1["UserDAO, OwnerDAO, AdminDAO"]
        D2["StationDAO, SlotDAO, BookingDAO, WaitingListDAO"]
        D3["PaymentDAO, CouponDAO, ReviewDAO"]
        D4["DBConnection Utility"]
    end

    subgraph "Database Layer (MySQL)"
        DB[("ev_charging_db<br/>(10 Relational Tables)")]
    end

    ViewLayer --> ControllerLayer
    ControllerLayer --> ModelLayer
    ControllerLayer --> DataAccessLayer
    DataAccessLayer --> ModelLayer
    DataAccessLayer --> DB
```

---

## 10. Deployment Diagram

```mermaid
graph TD
    subgraph "Client Tier (End User Machine)"
        Browser["Web Browser (Chrome / Edge / Firefox)<br/>HTML5, CSS3, JavaScript"]
    end

    subgraph "Application Tier (Apache Tomcat 9.0 Web Server)"
        Tomcat["Tomcat 9 Web Container (Port 8080)<br/>Java Servlet Engine & JSP Translator"]
        WAR["evcharging.war Web Application<br/>Context: /evcharging"]
        JVM["Java Virtual Machine (JDK 8 / 11 / 17 / 21 / 24)"]
        JDBCDriver["MySQL Connector/J (JDBC Driver)"]
    end

    subgraph "Database Tier (Database Server)"
        MySQL["MySQL Database Server 8.0 (Port 3306)<br/>Database: ev_charging_db"]
    end

    Browser -- "HTTP / HTTPS Requests (Port 8080)" --> Tomcat
    Tomcat --> WAR
    WAR --> JVM
    JVM --> JDBCDriver
    JDBCDriver -- "TCP/IP Connection (Port 3306)<br/>SQL Queries & PreparedStatements" --> MySQL
```
