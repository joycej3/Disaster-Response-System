package com.example.restservice;

import org.mockito.internal.matchers.Equals;

public class Emergency {

    public String emergency;
    public String injury;
    public Long time;
    public float latitude;
    public float longitude;
  
    public Emergency(String emergency, String injury, Long time, float latitude, float longitude) {
      this.emergency = emergency;
      this.injury = injury;
      this.time = time;
      this.latitude = latitude;
      this.longitude = longitude;
    }

    public Emergency(){
      
    }

    @Override
    public String toString(){
      return "[emergency: " + this.emergency + ", injury: " + this.injury + ", time: " + this.time + ", latitude: " + this.latitude + ", longitude: " + this.longitude + "]";
    }

    public boolean equals(Object object){
      return true;
    }
  }
  

