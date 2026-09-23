package com.evcharging.controller;

import com.evcharging.dao.OwnerDAO;
import com.evcharging.model.StationOwner;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/owner/register")
public class OwnerRegisterServlet extends HttpServlet {
    private final OwnerDAO ownerDAO = new OwnerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/owner/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String businessName = request.getParameter("businessName");
        String address = request.getParameter("address");

        if (name == null || email == null || password == null || phone == null ||
            name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() || phone.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All required fields must be filled.");
            request.getRequestDispatcher("/owner/register.jsp").forward(request, response);
            return;
        }

        if (ownerDAO.isEmailRegistered(email.trim())) {
            request.setAttribute("errorMessage", "Email is already registered. Please log in.");
            request.getRequestDispatcher("/owner/register.jsp").forward(request, response);
            return;
        }

        StationOwner owner = new StationOwner();
        owner.setName(name.trim());
        owner.setEmail(email.trim());
        owner.setPassword(password.trim());
        owner.setPhone(phone.trim());
        owner.setBusinessName(businessName != null ? businessName.trim() : "");
        owner.setAddress(address != null ? address.trim() : "");

        boolean success = ownerDAO.register(owner);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/owner/login?registered=true");
        } else {
            request.setAttribute("errorMessage", "Registration failed. Please try again.");
            request.getRequestDispatcher("/owner/register.jsp").forward(request, response);
        }
    }
}
