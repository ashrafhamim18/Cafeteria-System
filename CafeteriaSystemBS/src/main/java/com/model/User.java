package com.model;

public class User {
    private int id;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String role;
    
    public User() {}

    public User(String username, String password, String email, String fullName, String role) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullName = fullName;
        this.role = role;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String u) { this.username = u; }

    public String getPassword() { return password; }
    public void setPassword(String p) { this.password = p; }

    public String getFullName() { return fullName; }
    public void setFullName(String f) { this.fullName = f; }

    public String getEmail() { return email; }
    public void setEmail(String e) { this.email = e; }

    public String getRole() { return role; }
    public void setRole(String r) { this.role = r; }
}
