// EV Charging Station Finder System - Client-side JavaScript

document.addEventListener("DOMContentLoaded", function () {
    // 1. Set minimum date for booking to today
    var dateInput = document.getElementById("bookingDate");
    if (dateInput) {
        var today = new Date().toISOString().split("T")[0];
        dateInput.min = today;
        if (!dateInput.value) {
            dateInput.value = today;
        }
    }

    // 2. Simulated Payment Method Tab Selector
    var paymentTabs = document.querySelectorAll(".payment-tab");
    var paymentMethodInput = document.getElementById("selectedPaymentMethod");
    var paymentDetailsSection = document.getElementById("paymentMethodDetails");

    if (paymentTabs.length > 0 && paymentMethodInput) {
        paymentTabs.forEach(function (tab) {
            tab.addEventListener("click", function () {
                paymentTabs.forEach(function (t) { t.classList.remove("active"); });
                this.classList.add("active");
                var method = this.getAttribute("data-method");
                paymentMethodInput.value = method;

                if (paymentDetailsSection) {
                    if (method === "UPI") {
                        paymentDetailsSection.innerHTML = `
                            <div class="form-group">
                                <label>UPI ID (Google Pay / PhonePe / Paytm)</label>
                                <input type="text" class="form-control" placeholder="user@upi / mobile@okhdfcbank" value="user@okhdfcbank" required>
                                <small style="color: #64748b;">Simulated UPI verification - no actual deduction.</small>
                            </div>
                        `;
                    } else if (method === "CARD") {
                        paymentDetailsSection.innerHTML = `
                            <div class="form-group">
                                <label>Card Number</label>
                                <input type="text" class="form-control" placeholder="4111 2222 3333 4444" value="4111 2222 3333 4444" maxlength="19" required>
                            </div>
                            <div style="display:flex; gap: 10px;">
                                <div class="form-group" style="flex:1;">
                                    <label>Expiry (MM/YY)</label>
                                    <input type="text" class="form-control" placeholder="12/28" value="12/28" required>
                                </div>
                                <div class="form-group" style="flex:1;">
                                    <label>CVV</label>
                                    <input type="password" class="form-control" placeholder="123" value="123" maxlength="3" required>
                                </div>
                            </div>
                        `;
                    } else if (method === "WALLET") {
                        paymentDetailsSection.innerHTML = `
                            <div class="form-group">
                                <label>Select Wallet</label>
                                <select class="form-control">
                                    <option>Paytm Wallet (Balance: ₹1,200)</option>
                                    <option>Amazon Pay (Balance: ₹850)</option>
                                    <option>Mobikwik (Balance: ₹500)</option>
                                </select>
                            </div>
                        `;
                    }
                }
            });
        });
    }

    // 3. Dynamic Price Calculation on Slot Booking Page
    var hoursSelect = document.getElementById("totalHours");
    var rateElement = document.getElementById("pricePerUnitRate");
    var calculatedTotal = document.getElementById("calculatedBookingTotal");

    if (hoursSelect && rateElement && calculatedTotal) {
        var baseRate = parseFloat(rateElement.getAttribute("data-rate")) || 0;
        function updateCalculatedTotal() {
            var hrs = parseFloat(hoursSelect.value) || 1.0;
            var total = (baseRate * hrs).toFixed(2);
            calculatedTotal.textContent = "₹" + total;
        }
        hoursSelect.addEventListener("change", updateCalculatedTotal);
        updateCalculatedTotal();
    }
});

// Confirmation dialog for cancellations
function confirmCancelBooking() {
    return confirm("Are you sure you want to cancel this booking? This action cannot be undone.");
}

// Confirmation dialog for deleting reviews
function confirmDeleteReview() {
    return confirm("Are you sure you want to delete this review permanently?");
}
