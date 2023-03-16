package com.example.restservice;

import java.util.*;
import com.example.restservice.Shoelace;
import java.lang.Math;
public class ConvexHull {
    
    protected static class Point implements Comparable<Point> {
        double lat, lon;
        final double cartesianToMeters = 119139;
        
        public Point(double lat, double lon) {
            this.lat = lat;
            this.lon = lon;
        }
        
        public int compareTo(Point other) {
            if (this.lat < other.lat)
                return -1;
            if (this.lat > other.lat)
                return 1;
            if (this.lon < other.lon)
                return -1;
            if (this.lon > other.lon)
                return 1;
            return 0;
        }
    }
    
    private static double orientation(Point p, Point q, Point r) {
        double val = (q.lon - p.lon) * (r.lat - q.lat) - (q.lat - p.lat) * (r.lon - q.lon);
        if (val == 0)
            return 0;
        return (val > 0) ? 1 : 2;
    }
    
    private static ArrayList<Point> convexHull(Point[] points) {
        int n = points.length;
        ArrayList<Point> hull = new ArrayList<Point>();
        
        // Find the southernmost point
        int min = 0;
        for (int i = 1; i < n; i++) {
            if (points[i].compareTo(points[min]) < 0) {
                min = i;
            }
        }
        final Integer innerMin = Integer.valueOf(min);
        // Sort points by polar angle with respect to min point
        Arrays.sort(points, min + 1, n, new Comparator<Point>() {
            public int compare(Point p, Point q) {
                double o = orientation(points[innerMin], p, q);
                if (o == 0) {
                    return (int)((p.lat + p.lon) - (q.lat + q.lon));
                }
                return (o == 2) ? -1 : 1;
            }
        });
        
        // Add the first two points to the hull
        hull.add(points[min]);
        hull.add(points[(min + 1) % n]);
        
        // Add remaining points to the hull
        for (int i = 2; i < n; i++) {
            Point p = points[i];
            while (hull.size() > 1 && orientation(hull.get(hull.size() - 2), hull.get(hull.size() - 1), p) != 2) {
                hull.remove(hull.size() - 1);
            }
            hull.add(p);
        }
        
        return hull;
    }
    

    protected static Integer Integer(int min) {
        return null;
    }

    
  //testing convex hull and shoelace method with the area of st. stephens green
    public static void main(String[] args) {
        Point[] points = { new Point(37.7850, -122.4089), new Point(37.7766, -122.3958), new Point(37.7801, -122.4016),
                           new Point(37.7749, -122.4312), new Point(37.7933, -122.4157), new Point(37.7869, -122.4111),
                           new Point(37.7885, -122.3985), new Point(37.7949, -122.4081), new Point(37.7983, -122.4192) };
        Point[] stephensGreen = { new Point(53.337676, -6.262387), new Point(53.339700, -6.260585), new Point(53.338521, -6.255650), new Point(53.336395,-6.257495)};
        ArrayList<Point> hull = convexHull(stephensGreen);
        System.out.println("Convex hull:");
        for (Point p : hull) {
            System.out.println("(" + p.lat + ", " + p.lon + ")");
        }
        
        double area  = Shoelace.calculateArea(hull);
        System.out.println(area);

    }
}