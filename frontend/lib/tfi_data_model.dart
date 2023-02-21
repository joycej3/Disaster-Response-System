class TFIDataModel {
  String? id;
  bool? isDeleted;
  TripUpdate? tripUpdate;  

  TFIDataModel({this.id, this.isDeleted, this.tripUpdate});

  TFIDataModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    isDeleted = json['IsDeleted'];
    tripUpdate = json['TripUpdate'] != null
        ? new TripUpdate.fromJson(json['TripUpdate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['IsDeleted'] = this.isDeleted;
    if (this.tripUpdate != null) {
      data['TripUpdate'] = this.tripUpdate!.toJson();
    }
    return data;
  }
}

class TripUpdate {
  Trip? trip;
  List<StopTimeUpdate>? stopTimeUpdate;

  TripUpdate({this.trip, this.stopTimeUpdate});

  TripUpdate.fromJson(Map<String, dynamic> json) {
    trip = json['Trip'] != null ? new Trip.fromJson(json['Trip']) : null;
    if (json['StopTimeUpdate'] != null) {
      stopTimeUpdate = <StopTimeUpdate>[];
      json['StopTimeUpdate'].forEach((v) {
        stopTimeUpdate!.add(new StopTimeUpdate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trip != null) {
      data['Trip'] = this.trip!.toJson();
    }
    if (this.stopTimeUpdate != null) {
      data['StopTimeUpdate'] =
          this.stopTimeUpdate!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trip {
  String? tripId;
  String? routeId;
  String? startTime;
  String? startDate;
  String? scheduleRelationship;

  Trip(
      {this.tripId,
      this.routeId,
      this.startTime,
      this.startDate,
      this.scheduleRelationship});

  Trip.fromJson(Map<String, dynamic> json) {
    tripId = json['TripId'];
    routeId = json['RouteId'];
    startTime = json['StartTime'];
    startDate = json['StartDate'];
    scheduleRelationship = json['ScheduleRelationship'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TripId'] = this.tripId;
    data['RouteId'] = this.routeId;
    data['StartTime'] = this.startTime;
    data['StartDate'] = this.startDate;
    data['ScheduleRelationship'] = this.scheduleRelationship;
    return data;
  }
}

class StopTimeUpdate {
  int? stopSequence;
  String? stopId;
  Departure? departure;
  String? scheduleRelationship;
  Departure? arrival;

  StopTimeUpdate(
      {this.stopSequence,
      this.stopId,
      this.departure,
      this.scheduleRelationship,
      this.arrival});

  StopTimeUpdate.fromJson(Map<String, dynamic> json) {
    stopSequence = json['StopSequence'];
    stopId = json['StopId'];
    departure = json['Departure'] != null
        ? new Departure.fromJson(json['Departure'])
        : null;
    scheduleRelationship = json['ScheduleRelationship'];
    arrival = json['Arrival'] != null
        ? new Departure.fromJson(json['Arrival'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StopSequence'] = this.stopSequence;
    data['StopId'] = this.stopId;
    if (this.departure != null) {
      data['Departure'] = this.departure!.toJson();
    }
    data['ScheduleRelationship'] = this.scheduleRelationship;
    if (this.arrival != null) {
      data['Arrival'] = this.arrival!.toJson();
    }
    return data;
  }
}

class Departure {
  int? delay;

  Departure({this.delay});

  Departure.fromJson(Map<String, dynamic> json) {
    delay = json['Delay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Delay'] = this.delay;
    return data;
  }
}
