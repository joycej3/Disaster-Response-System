package com.example.restservice;

import java.util.ArrayList;
import java.util.List;

import com.example.restservice.ConvexHull.Point;
public class Shoelace {
    
    final static double degreesToMeters = 119.139;

    // Returns the area of a polygon defined by the given list of points
    public static double calculateArea(ArrayList<Point> points) {
        double area = 0.0;
        //ArrayList<Point> cartesianPoints = convertCartesian(points);

        int j = points.size() - 1;
        for (int i = 0; i < points.size(); i++) {
            Point p1 = points.get(i);
            Point p2 = points.get(j);
            area += (p2.lat*degreesToMeters + p1.lat*degreesToMeters) * (p2.lon*degreesToMeters - p1.lon*degreesToMeters);
            j = i;
        }
        return Math.abs(area / 2.0);
    }
}