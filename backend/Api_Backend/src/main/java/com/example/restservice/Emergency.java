package com.example.restservice;

import org.mockito.internal.matchers.Equals;

public class Emergency {

    public String emergency;
    public String injury;
    public String time;
    public String lat;
    public String lon; 
    public String reportCategory;
  
    public Emergency(String emergency, String injury, String time, String lat, String lon, String reportCategory) {
    }

    public Emergency(){
      
    }

    @Override
    public String toString(){
      return "[emergency: " + this.emergency + ", injury: " + this.injury + ", time: " + this.time + ", latitude: " + this.lat + ", longitude: " + this.lon + "]";
    }

    public boolean equals(Object object){
      return true;
    }
  }
  

