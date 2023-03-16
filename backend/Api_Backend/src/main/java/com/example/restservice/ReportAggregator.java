package com.example.restservice;


public class ReportAggregator {

    // takes all reports under a disaster ID and aggregates them to pass to ML model
    // maybe create an aggregated report class to pass to ML model
    public static void aggregateReports(){

    }

    private int aggregatePopulation(){
        //take max over all the populations 
        return 0;
    }
    private int aggregateKnownInjury(){
        // take max over all the injuries 
        return 0;
    }

    private int aggregateIncidentType(){
        // take mode over all report values 
        return 0;
    }

    private int aggregateArea(){
        //take all lat long of the reports
        //run convext hull to get list of vertices of bounding polygon of points
        //run shoelace formula with these vertice to get area 
        return 0;
    }

    private string getNeighbourhood(){
        //take all lat long of the reports
        //Find neighbourhood where disaster takes place
        return 0;
    }

    
}
