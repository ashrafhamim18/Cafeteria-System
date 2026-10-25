package com.model;

public class Menu {
    private int id;
    private String name;
    private String description;
    private String availability;
    private String category;
    private double price;
    private String image;
    private int stockQuantity;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getAvailability() { return availability; }
    public void setAvailability(String availability) { this.availability = availability; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    
    public int getStockQuantity() {return stockQuantity;}
    public void setStockQuantity(int stockQuantity) {this.stockQuantity = stockQuantity;}
}
