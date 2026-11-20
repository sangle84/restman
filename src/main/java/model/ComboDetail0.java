package model;

import java.io.Serializable;

public class ComboDetail0 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int quantity;
    private Dish0 dish;

    public ComboDetail0() {
    }

    public ComboDetail0(int id, int quantity, Dish0 dish) {
        this.id = id;
        this.quantity = quantity;
        this.dish = dish;
    }

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

    public Dish0 getDish() {
        return dish;
    }

    public void setDish(Dish0 dish) {
        this.dish = dish;
    }
}
