package com.example.restservice;

import java.io.Serializable;

import lombok.Data;

@Data
public class Disaster implements Serializable{
    private String firstReported;
    private String location;
    private String disasterType;

    public Disaster(){

    }

    public Disaster(String firstReported, String location, String disasterType){
        this.firstReported = firstReported;
        this.location = location;
        this.disasterType = disasterType;
    }
}
