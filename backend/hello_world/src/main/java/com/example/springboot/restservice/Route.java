package com.example.springboot.restservice;

import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.core.Response;
import java.util.Arrays;

public class Route {
    public static void main(String[] args) {

    }

    public static Response getRoute(double[] start, double[] end) {
        Client client = ClientBuilder.newClient();

        String coords = "[" + Arrays.toString(start) + "," + Arrays.toString(end) + "]";
        String json = "{\"coordinates\":" + coords + ",\"options\":{\"avoid_features\":[\"tollways\",\"highways\"]}}";
        Entity<String> payload = Entity.json(json);

        Response response = client.target("https://api.openrouteservice.org/v2/directions/driving-car/geojson")
                .request()
                .header("Authorization", "5b3ce3597851110001cf6248ebfbb0e7fdc54d72b5e1fad9d8bb352a")
                .header("Accept", "application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8")
                .header("Content-Type", "application/json; charset=utf-8")
                .post(payload);
        return response;
    }
}
