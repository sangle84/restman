package model;

public class Staff0 extends User0 {
    private static final long serialVersionUID = 1L;

    private String position;

    public Staff0() {
        super();
    }

    public Staff0(int id, String username, String password, String name, String email, String phone, String position) {
        super(id, username, password, name, email, phone);
        this.position = position;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }
}
