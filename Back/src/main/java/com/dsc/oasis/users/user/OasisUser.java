package com.dsc.oasis.users.user;

import javax.persistence.*;

@Entity
@Table
public class OasisUser {
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private Long id;

    private String email;
    private String password;
    private String token;
    private Double lat;
    private Double lon;

    public OasisUser() {

    }

    public OasisUser(Long id, String email, String password, String token, Double lat, Double lon) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.token = token;
        this.lat = lat;
        this.lon = lon;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Double getLat() {
        return lat;
    }

    public void setLat(Double lat) {
        this.lat = lat;
    }

    public Double getLon() {
        return lon;
    }

    public void setLon(Double lon) {
        this.lon = lon;
    }
}
