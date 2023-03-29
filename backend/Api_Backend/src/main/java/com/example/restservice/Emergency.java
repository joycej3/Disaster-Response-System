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
      this.emergency = emergency;
      this.injury = injury;
      this.time = time;
      this.lat = lat;
      this.lon = lon;
      this.reportCategory = reportCategory;
    }

    public Emergency(){
      
    }

    @Override
    public String toString(){
      return "[emergency: " + this.emergency + ", injury: " + this.injury + ", time: " + this.time + ", latitude: " + this.lat + ", longitude: " + this.lon + ", report catagory: " + this.reportCategory +  " ]";
    }

    public boolean equals(Object object){
      return true;
    }
  }
  

