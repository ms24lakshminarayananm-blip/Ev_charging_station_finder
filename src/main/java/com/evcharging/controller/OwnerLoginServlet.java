package com.evcharging.controller;

import com.evcharging.dao.OwnerDAO;
import com.evcharging.model.StationOwner;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/owner/login")
public class OwnerLoginServlet extends HttpServlet {
    private final OwnerDAO ownerDAO = new OwnerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/owner/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email and password are required.");
            request.getRequestDispatcher("/owner/login.jsp").forward(request, response);
            return;
        }

        StationOwner owner = ownerDAO.login(email.trim(), password.trim());
        if (owner != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("owner", owner);
            session.setAttribute("role", "owner");
            response.sendRedirect(request.getContextPath() + "/owner/dashboard");
        } else {
            request.setAttribute("errorMessage", "Invalid owner email or password.");
            request.getRequestDispatcher("/owner/login.jsp").forward(request, response);
        }
    }
}
