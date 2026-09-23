# Test Cases: EV Charging Station Finder System

This document contains the functional software test specifications for the **EV Charging Station Finder System** college project.

---

## Test Suite Summary

| Suite ID | Module / Feature | Total Test Cases |
| :--- | :--- | :--- |
| **TC-REG** | EV User & Station Owner Registration | 3 |
| **TC-LOG** | Authentication & Session Management | 3 |
| **TC-SCH** | Station Search & Filter | 3 |
| **TC-BKG** | Slot Availability Check & Booking | 3 |
| **TC-WTL** | Waiting List Management | 2 |
| **TC-PAY** | Simulated Payment Processing | 2 |
| **TC-CPN** | Coupon Code Validation & Calculation | 3 |
| **TC-CAN** | Reservation Cancellation | 2 |
| **TC-OWN** | Station Owner Registration & Bay Setup | 2 |
| **TC-ADM** | Admin Station Verification & Moderation | 3 |

---

## 1. Registration (`TC-REG`)

### TC-REG-01: Successful EV User Registration
- **Precondition:** User is on `/register.jsp`.
- **Test Steps:**
  1. Fill in Name: `Ananya Rao`.
  2. Enter unique Email: `ananya@test.com`.
  3. Enter Password: `password123`.
  4. Enter Phone: `9876501234`.
  5. Enter Vehicle Number: `KA-05-EV-4421` and Model: `Tata Tiago EV`.
  6. Click "Register Account".
- **Expected Result:** Application inserts record into `users` table, redirects to `/login?registered=true`, and displays success alert.

### TC-REG-02: User Registration with Existing Email
- **Precondition:** User is on `/register.jsp`.
- **Test Steps:**
  1. Enter existing email: `user@gmail.com`.
  2. Fill other required fields.
  3. Click "Register Account".
- **Expected Result:** Registration rejected with user-friendly error message: "Email is already registered. Please log in."

### TC-REG-03: Empty Field Validation
- **Precondition:** User is on `/register.jsp`.
- **Test Steps:**
  1. Leave Name and Email blank.
  2. Click "Register Account".
- **Expected Result:** HTML5 form validation / server validation prevents form submission.

---

## 2. Authentication (`TC-LOG`)

### TC-LOG-01: Successful User Login
- **Precondition:** User account exists in database (`user@gmail.com` / `user123`).
- **Test Steps:**
  1. Navigate to `/login.jsp`.
  2. Enter email `user@gmail.com` and password `user123`.
  3. Click "Sign In".
- **Expected Result:** User session created, redirects to `/user/dashboard`, navbar displays role badge "User: Demo EV User".

### TC-LOG-02: Invalid Password Attempt
- **Precondition:** User is on `/login.jsp`.
- **Test Steps:**
  1. Enter email `user@gmail.com` and wrong password `wrongpass`.
  2. Click "Sign In".
- **Expected Result:** Re-renders `/login.jsp` with error: "Invalid email or password. Please try again."

### TC-LOG-03: User Logout
- **Precondition:** User is actively logged in.
- **Test Steps:**
  1. Click "Logout" button in navigation bar.
- **Expected Result:** Session is invalidated, redirects to `/login.jsp?logout=true`. Direct URL access to `/user/dashboard` redirects to login.

---

## 3. Station Search & Filter (`TC-SCH`)

### TC-SCH-01: Public Station Search by City
- **Precondition:** Approved stations exist in `stations` table.
- **Test Steps:**
  1. Navigate to `/search-stations`.
  2. Enter `Bengaluru` in city/query search field.
  3. Click "Filter Stations".
- **Expected Result:** Only stations located in Bengaluru with status `APPROVED` are displayed in the results grid.

### TC-SCH-02: Filter Stations by Connector Type
- **Precondition:** Multiple stations with varied connector types exist.
- **Test Steps:**
  1. Select `CCS2` from charger type dropdown.
  2. Click "Filter Stations".
- **Expected Result:** Displays only stations equipped with CCS2 Fast DC connectors.

### TC-SCH-03: Filter by Maximum Price Threshold
- **Precondition:** User is on `/search-stations`.
- **Test Steps:**
  1. Enter `17.00` in "Max Price (₹/unit)" field.
  2. Click "Filter Stations".
- **Expected Result:** Displays stations whose `price_per_unit` is less than or equal to ₹17.00.

---

## 4. Slot Availability & Booking (`TC-BKG`)

### TC-BKG-01: Successful Booking of Available Slot
- **Precondition:** EV User is logged in. Station has available slots for the selected date and time.
- **Test Steps:**
  1. Open station details and click "Book Charging Slot".
  2. Select Date (today or future date), Time `10:00 AM`, Slot `Slot A1`, Duration `1 Hour`.
  3. Submit booking form.
- **Expected Result:** Checks availability, verifies no conflict in `bookings` table, and forwards user to `/payment` checkout summary.

### TC-BKG-02: Slot Unavailable Conflict Check
- **Precondition:** Slot A4 is already booked for date `2026-09-24` at `10:00 AM`.
- **Test Steps:**
  1. Choose Slot A4 for `2026-09-24` at `10:00 AM`.
  2. Click "Proceed to Payment".
- **Expected Result:** System flags conflict, displays "Slot Unavailable!", and presents "Join Waiting List" prompt.

---

## 5. Waiting List (`TC-WTL`)

### TC-WTL-01: Joining Waiting List when Slot is Occupied
- **Precondition:** User encountered "Slot Unavailable" message for a desired station and slot.
- **Test Steps:**
  1. Click the "Join Waiting List" button on `/user/book-slot.jsp`.
- **Expected Result:** Insert record into `waiting_list` with status `WAITING`. Redirects to `/waiting-list?joined=true`.

### TC-WTL-02: Remove Entry from Waiting List
- **Precondition:** User has active entries on `/user/waiting-list.jsp`.
- **Test Steps:**
  1. Locate waiting list entry.
  2. Click "Remove".
- **Expected Result:** Record deleted from `waiting_list` table; table updates immediately.

---

## 6. Payment Simulation (`TC-PAY`)

### TC-PAY-01: Simulated UPI Payment Execution
- **Precondition:** User has active booking session on `/user/payment.jsp`.
- **Test Steps:**
  1. Select simulated payment method: `UPI`.
  2. Enter UPI ID: `user@upi`.
  3. Click "Pay & Confirm Reservation".
- **Expected Result:**
  - Creates record in `bookings` table with status `BOOKED`.
  - Creates simulated record in `payments` with unique `TXN-EV-XXXXXX` transaction ID.
  - Redirects to `/booking?action=confirmation` displaying booking number and simulated receipt.

### TC-PAY-02: Card Payment Option Simulation
- **Precondition:** User on `/user/payment.jsp`.
- **Test Steps:**
  1. Select `Credit / Debit Card` tab.
  2. Review prefilled simulated card fields.
  3. Click "Pay & Confirm Reservation".
- **Expected Result:** Generates fake transaction ID, saves payment method as `CARD`, and completes booking.

---

## 7. Coupon Discount Validation (`TC-CPN`)

### TC-CPN-01: Apply Valid Percentage Coupon (`EV10`)
- **Precondition:** Checkout total is ₹100 or higher.
- **Test Steps:**
  1. In coupon code box on `/user/payment.jsp`, enter `EV10`.
  2. Click "Apply Coupon".
- **Expected Result:** System reads `coupons` table, computes 10% discount, subtracts discount from total, and updates "Final Payable Amount".

### TC-CPN-02: Apply Valid Coupon (`SAVE20`)
- **Precondition:** Checkout total is ₹200 or higher.
- **Test Steps:**
  1. Enter `SAVE20` and click "Apply Coupon".
- **Expected Result:** 20% discount is calculated and displayed in green with saved amount.

### TC-CPN-03: Invalid Coupon Code Handling
- **Precondition:** User on `/user/payment.jsp`.
- **Test Steps:**
  1. Enter non-existent coupon `FAKE99`.
  2. Click "Apply Coupon".
- **Expected Result:** Displays user error: "Invalid or expired coupon code." Total amount remains unchanged.

---

## 8. Booking Cancellation (`TC-CAN`)

### TC-CAN-01: User Cancels Active Booking
- **Precondition:** User has a booking with status `BOOKED`.
- **Test Steps:**
  1. Open `/user/bookings.jsp`.
  2. Locate active booking and click "Cancel".
  3. Confirm browser confirmation popup.
- **Expected Result:** Calls `/cancel-booking`, updates status to `CANCELLED` in `bookings` table. Slot becomes freed for other drivers.

### TC-CAN-02: Unauthorized Cancellation Attempt
- **Precondition:** User A is logged in.
- **Test Steps:**
  1. Submit cancellation request with booking ID belonging to User B.
- **Expected Result:** SQL `WHERE user_id = ?` ensures operation fails safely without affecting another user's booking.

---

## 9. Station Owner Management (`TC-OWN`)

### TC-OWN-01: Owner Registers New Charging Station
- **Precondition:** Station Owner logged in at `/owner/login.jsp`.
- **Test Steps:**
  1. Navigate to `/owner/add-station.jsp`.
  2. Enter Station Name: `GreenPulse Hub`, City: `Mysuru`, Rate: `19.00`, Total Slots: `4`.
  3. Click "Submit Station for Admin Approval".
- **Expected Result:**
  - Insert record into `stations` with `approval_status = 'PENDING'`.
  - Automatically initializes 4 slots in `charging_slots` with status `AVAILABLE`.
  - Station does NOT appear in public search until admin approval.

### TC-OWN-02: Toggle Live Bay Status
- **Precondition:** Owner has stations listed on `/owner/live-status.jsp`.
- **Test Steps:**
  1. Select Slot 1 and change status from `AVAILABLE` to `MAINTENANCE`.
  2. Click "Update".
- **Expected Result:** Status in `charging_slots` updates to `MAINTENANCE`. Status badge turns red.

---

## 10. Administrator Moderation (`TC-ADM`)

### TC-ADM-01: Admin Approves Pending Station
- **Precondition:** Station exists with `approval_status = 'PENDING'`.
- **Test Steps:**
  1. Admin logs in at `/admin/login.jsp` with `admin` / `admin123`.
  2. On Admin Dashboard, locate pending station in "Stations Awaiting Approval".
  3. Click "✓ Approve".
- **Expected Result:**
  - `approval_status` updated to `APPROVED` in database.
  - Station appears in public search results on `/search-stations`.

### TC-ADM-02: Admin Rejects Pending Station
- **Precondition:** Pending station exists in table.
- **Test Steps:**
  1. Admin clicks "✕ Reject" on pending station.
- **Expected Result:** `approval_status` updated to `REJECTED`. Station is hidden from public users.

### TC-ADM-03: Delete Inappropriate Review
- **Precondition:** Reviews exist on `/admin/reviews.jsp`.
- **Test Steps:**
  1. Admin reviews customer feedback log.
  2. Clicks "Delete Review" on selected row.
- **Expected Result:** Record deleted from `reviews` table and removed from station's average rating calculation.
