package com.example.restservice;
import com.example.restservice.ConvexHull.Point;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ShoelaceTest {

    @Test
    public void testCalculateArea() {
        // Test with a square of side length 1 degree
        Point[] squarePoints = {
            new Point(0, 0),
            new Point(0, 1),
            new Point(1, 1),
            new Point(1, 0)
        };
        ArrayList<Point> squareList = new ArrayList<>(Arrays.asList(squarePoints));
        double squareArea = Shoelace.calculateArea(squareList);
        assertEquals(12359.18867260853, squareArea, 2000);
        
        // Test with a triangle of side lengths 1 degree, 1 degree, and sqrt(2) degrees
        Point[] trianglePoints = {
            new Point(0, 0),
            new Point(0, 1),
            new Point(1, 1)
        };
        ArrayList<Point> triangleList = new ArrayList<>(Arrays.asList(trianglePoints));
        double triangleArea = Shoelace.calculateArea(triangleList);
        assertEquals(6180.765504027931, triangleArea, 1000);
    }

        @Test
    public void testCalculateArea_KnownSquareInKilometers() {
        ArrayList<Point> points = new ArrayList<Point>();
        points.add(new Point(53.3498, -6.2603)); // Dublin
        points.add(new Point(53.3498, -6.2703)); // Dublin
        points.add(new Point(53.3398, -6.2703)); // Dublin
        points.add(new Point(53.3398, -6.2603)); // Dublin
        double expectedArea = 1.0345; // square kilometers
        double actualArea = Shoelace.calculateArea(points);
        assertEquals(expectedArea, actualArea, 100);
    }
    


}
