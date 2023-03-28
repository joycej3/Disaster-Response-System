package com.example.restservice;

import java.io.Serializable;

import lombok.Data;

@Data
public class Decision implements Serializable {

	public Decision(int ambulances, int paramedics, int firefighters, int fireengines, int police) {
        this.ambulances = ambulances;
        this.paramedics = paramedics;
        this.firefighters = firefighters;
        this.fireengines = fireengines;
        this.police = police;
    }

    public Decision(){

    }
    private int ambulances;
    private int paramedics;
    private int firefighters;
    private int fireengines;
    private int police;

}