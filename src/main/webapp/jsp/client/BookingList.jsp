<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
            <% if (session.getAttribute("clientID")==null) { response.sendRedirect("SignIn.jsp"); return; } %>

                <jsp:include page="Header.jsp" />

                <section class="section" style="padding-top: 100px; min-height: 80vh;">
                    <div class="container">
                        <div class="section-title" data-aos="fade-up">
                            <span class="description-title">My Bookings</span>
                            <h2>My Bookings</h2>
                        </div>

                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                ${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <div class="card shadow-sm">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Booking ID</th>
                                                <th>Package</th>
                                                <th>Category</th>
                                                <th>Date</th>
                                                <th>Time</th>
                                                <th>Location</th>
                                                <th>Total (RM)</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="booking" items="${bookings}">
                                                <c:set var="payment" value="${paymentMap[booking.bookingId]}" />
                                                <tr>
                                                    <td><strong>#${booking.bookingId}</strong></td>
                                                    <td>${booking.packageName}</td>
                                                    <td>
                                                        <span
                                                            class="badge ${booking.packageCateg == 'Indoor' ? 'bg-success' : 'bg-primary'}">
                                                            ${booking.packageCateg}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty booking.bookDate}">
                                                                <fmt:parseDate value="${booking.bookDate}"
                                                                    pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                                                <fmt:formatDate value="${parsedDate}"
                                                                    pattern="dd MMM yyyy" />
                                                            </c:when>
                                                            <c:otherwise>${booking.bookDate}</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty booking.bookStartTime}">
                                                                <fmt:formatDate value="${booking.bookStartTime}"
                                                                    pattern="hh:mm a" /> -
                                                                <fmt:formatDate value="${booking.bookEndTime}"
                                                                    pattern="hh:mm a" />
                                                            </c:when>
                                                            <c:otherwise>${booking.bookTime}</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${booking.bookLocation}</td>
                                                    <td>
                                                        <fmt:formatNumber value="${booking.totalPrice}"
                                                            pattern="#,##0.00" />
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${booking.bookStatus == 'Confirmed'}">
                                                                <span
                                                                    class="badge bg-success">${booking.bookStatus}</span>
                                                            </c:when>
                                                            <c:when test="${booking.bookStatus == 'Pending'}">
                                                                <span
                                                                    class="badge bg-warning text-dark">${booking.bookStatus}</span>
                                                            </c:when>
                                                            <c:when test="${booking.bookStatus == 'Waiting Approval'}">
                                                                <span class="badge bg-info">${booking.bookStatus}</span>
                                                            </c:when>
                                                            <c:when test="${booking.bookStatus == 'Completed'}">
                                                                <span
                                                                    class="badge bg-secondary">${booking.bookStatus}</span>
                                                            </c:when>
                                                            <c:when test="${booking.bookStatus == 'Cancelled'}">
                                                                <span
                                                                    class="badge bg-danger">${booking.bookStatus}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    class="badge bg-secondary">${booking.bookStatus}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/ClientPaymentController?bookingId=${booking.bookingId}"
                                                            class="btn btn-sm btn-outline-success" title="Payment">
                                                            <i class="bi bi-credit-card"></i>
                                                        </a>
                                                        <c:if
                                                            test="${not empty payment && (not empty payment.depoRef || not empty payment.fullRef)}">
                                                            <a href="${pageContext.request.contextPath}/ClientPaymentController?action=invoice&bookingId=${booking.bookingId}"
                                                                class="btn btn-sm btn-outline-secondary"
                                                                title="View Invoice">
                                                                <i class="bi bi-receipt"></i>
                                                            </a>
                                                        </c:if>
                                                        <c:if
                                                            test="${booking.bookStatus == 'Confirmed' || booking.bookStatus == 'Completed'}">
                                                            <a href="${pageContext.request.contextPath}/BookingController?action=photos&bookingId=${booking.bookingId}"
                                                                class="btn btn-sm btn-outline-info" title="View Photos">
                                                                <i class="bi bi-images"></i>
                                                            </a>
                                                        </c:if>
                                                        <c:if test="${booking.bookStatus == 'Pending'}">
                                                            <button class="btn btn-sm btn-outline-danger"
                                                                onclick="cancelBooking(${booking.bookingId})"
                                                                title="Cancel">
                                                                <i class="bi bi-x-circle"></i>
                                                            </button>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>

                                            <c:if test="${empty bookings}">
                                                <tr>
                                                    <td colspan="9" class="text-center py-5">
                                                        <i class="bi bi-calendar-x"
                                                            style="font-size: 3rem; color: #ccc;"></i>
                                                        <p class="mt-3 text-muted">No bookings yet.</p>
                                                        <a href="${pageContext.request.contextPath}/packages"
                                                            class="btn btn-primary">
                                                            Browse Packages
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 text-center">
                            <a href="${pageContext.request.contextPath}/BookingController?action=indoor"
                                class="btn btn-success me-2">
                                <i class="bi bi-house"></i> Book Indoor
                            </a>
                            <a href="${pageContext.request.contextPath}/BookingController?action=outdoor"
                                class="btn btn-primary">
                                <i class="bi bi-tree"></i> Book Outdoor
                            </a>
                        </div>
                    </div>
                </section>

                <!-- Cancel Confirmation Modal -->
                <div class="modal fade" id="cancelModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header bg-danger text-white">
                                <h5 class="modal-title">Cancel Booking</h5>
                                <button type="button" class="btn-close btn-close-white"
                                    data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <p>Are you sure you want to cancel this booking?</p>
                                <p class="text-muted">This action cannot be undone.</p>
                            </div>
                            <div class="modal-footer">
                                <form action="${pageContext.request.contextPath}/BookingController" method="post">
                                    <input type="hidden" name="action" value="cancel">
                                    <input type="hidden" name="bookingId" id="cancelBookingId">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No, Keep
                                        it</button>
                                    <button type="submit" class="btn btn-danger">Yes, Cancel Booking</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    function cancelBooking(bookingId) {
                        document.getElementById('cancelBookingId').value = bookingId;
                        new bootstrap.Modal(document.getElementById('cancelModal')).show();
                    }
                </script>

                <jsp:include page="Footer.jsp" />