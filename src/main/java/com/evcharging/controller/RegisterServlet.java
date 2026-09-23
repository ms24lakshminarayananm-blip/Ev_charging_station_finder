package com.evcharging.controller;

import com.evcharging.dao.UserDAO;
import com.evcharging.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String vehicleNumber = request.getParameter("vehicleNumber");
        String vehicleModel = request.getParameter("vehicleModel");

        if (name == null || email == null || password == null || phone == null ||
            name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() || phone.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All required fields must be filled.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.isEmailRegistered(email.trim())) {
            request.setAttribute("errorMessage", "Email is already registered. Please log in.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setName(name.trim());
        user.setEmail(email.trim());
        user.setPassword(password.trim());
        user.setPhone(phone.trim());
        user.setVehicleNumber(vehicleNumber != null ? vehicleNumber.trim() : "");
        user.setVehicleModel(vehicleModel != null ? vehicleModel.trim() : "");

        boolean success = userDAO.register(user);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/login?registered=true");
        } else {
            request.setAttribute("errorMessage", "Registration failed. Please check your details and try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
