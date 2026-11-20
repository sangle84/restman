package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Combo0 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private String image;
    private float price;
    private String description;
    private List<ComboDetail0> dsComboDetail;

    public Combo0() {
        this.dsComboDetail = new ArrayList<>();
    }

    public Combo0(int id, String name, String image, float price, String description) {
        this.id = id;
        this.name = name;
        this.image = image;
        this.price = price;
        this.description = description;
        this.dsComboDetail = new ArrayList<>();
    }

    public Combo0(int id, String name, String image, float price, String description, List<ComboDetail0> dsComboDetail) {
        this.id = id;
        this.name = name;
        this.image = image;
        this.price = price;
        this.description = description;
        this.dsComboDetail = (dsComboDetail != null) ? dsComboDetail : new ArrayList<>();
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

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<ComboDetail0> getDsComboDetail() {
        return dsComboDetail;
    }

    public void setDsComboDetail(List<ComboDetail0> dsComboDetail) {
        this.dsComboDetail = dsComboDetail;
    }

    /**
     * Thêm chi tiết món vào dsComboDetail, nếu trùng dish.getId() thì cộng dồn quantity
     */
    public void addComboDetail(ComboDetail0 cd) {
        if (cd == null || cd.getDish() == null) {
            return;
        }
        if (this.dsComboDetail == null) {
            this.dsComboDetail = new ArrayList<>();
        }

        boolean found = false;
        for (ComboDetail0 existingDetail : this.dsComboDetail) {
            if (existingDetail.getDish() != null && existingDetail.getDish().getId() == cd.getDish().getId()) {
                existingDetail.setQuantity(existingDetail.getQuantity() + cd.getQuantity());
                found = true;
                break;
            }
        }

        if (!found) {
            this.dsComboDetail.add(cd);
        }
    }

    /**
     * Xóa chi tiết món có dish.getId() == dishId
     */
    public void removeComboDetail(int dishId) {
        if (this.dsComboDetail == null) {
            return;
        }
        this.dsComboDetail.removeIf(cd -> cd.getDish() != null && cd.getDish().getId() == dishId);
    }
}
