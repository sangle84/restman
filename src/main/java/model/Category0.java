package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Category0 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private List<Dish0> dsDish;

    public Category0() {
        this.dsDish = new ArrayList<>();
    }

    public Category0(int id, String name) {
        this.id = id;
        this.name = name;
        this.dsDish = new ArrayList<>();
    }

    public Category0(int id, String name, List<Dish0> dsDish) {
        this.id = id;
        this.name = name;
        this.dsDish = (dsDish != null) ? dsDish : new ArrayList<>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Dish0> getDsDish() {
        return dsDish;
    }

    public void setDsDish(List<Dish0> dsDish) {
        this.dsDish = dsDish;
    }
}
