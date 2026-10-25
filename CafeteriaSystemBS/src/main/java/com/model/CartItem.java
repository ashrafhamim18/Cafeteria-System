package com.model;

public class CartItem {
    private int id;
    private int quantity;
    private Menu menu;

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Menu getMenu() {
        return menu;
    }
    public void setMenu(Menu menu) {
        this.menu = menu;
    }

    public int getMenuId() {
        return menu != null ? menu.getId() : 0;
    }

    public String getName() {
        return menu != null ? menu.getName() : "";
    }

    public double getPrice() {
        return menu != null ? menu.getPrice() : 0.0;
    }
}
