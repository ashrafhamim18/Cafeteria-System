package com.dao;

import com.model.User;
import java.sql.*;
import java.util.*;

public class UserDAO {
	
	public User validate(String username, String password) throws Exception {
	    User user = null;

	    String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {
	        
	        stmt.setString(1, username);
	        stmt.setString(2, password);
	        
	        try (ResultSet rs = stmt.executeQuery()) {
	            if (rs.next()) {
	                user = new User();
	                user.setId(rs.getInt("id"));
	                user.setFullName(rs.getString("full_name"));
	                user.setUsername(rs.getString("username"));
	                user.setEmail(rs.getString("email"));
	                user.setPassword(rs.getString("password"));
	                user.setRole(rs.getString("role"));
	            }
	        }
	    }
	    return user;
	}


    public List<User> searchAndFilter(String kw, String flt) throws Exception {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1");
        if (!kw.isEmpty()) sql.append(" AND full_name LIKE ?");
        if (!flt.isEmpty()) sql.append(" AND role = ?");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql.toString())) {
            int i = 1;
            if (!kw.isEmpty()) st.setString(i++, "%" + kw + "%");
            if (!flt.isEmpty()) st.setString(i++, flt);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    User x = new User();
                    x.setId(rs.getInt("id"));
                    x.setUsername(rs.getString("username"));
                    x.setPassword(rs.getString("password"));
                    x.setFullName(rs.getString("full_name"));
                    x.setEmail(rs.getString("email"));
                    x.setRole(rs.getString("role"));
                    list.add(x);
                }
            }
        }
        return list;
    }

    public void add(User u) throws Exception {
        String sql = "INSERT INTO users(full_name,username,email,password,role) VALUES(?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1,u.getFullName());
            st.setString(2,u.getUsername());
            st.setString(3,u.getEmail());
            st.setString(4,u.getPassword());
            st.setString(5,u.getRole());
            st.executeUpdate();
        }
    }

    public void update(User u) throws Exception {
        String sql = "UPDATE users SET full_name=?,username=?,email=?,password=?,role=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1,u.getFullName());
            st.setString(2,u.getUsername());
            st.setString(3,u.getEmail());
            st.setString(4,u.getPassword());
            st.setString(5,u.getRole());
            st.setInt(6,u.getId());
            st.executeUpdate();
        }
    }

    public void delete(int id) throws Exception {
        String sql = "DELETE FROM users WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1,id);
            st.executeUpdate();
        }
    }
    
    public boolean checkUsernameExists(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
        	PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, username);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (username, password, email, full_name, role) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, user.getUsername());
            st.setString(2, user.getPassword());
            st.setString(3, user.getEmail());
            st.setString(4, user.getFullName());
            st.setString(5, user.getRole());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
