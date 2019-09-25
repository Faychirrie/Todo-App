import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/res/bloc/services.dart';
import 'package:todo/res/bloc/bloc_provider.dart';

class FlightListBloc implements BlocBase {
  StreamController<QuerySnapshot> dealsController =
      StreamController<QuerySnapshot>();

  StreamSink<QuerySnapshot> get dealsSink => dealsController.sink;

  Stream<QuerySnapshot> get dealsStream => dealsController.stream;

  FlightListBloc(FirebaseService firebaseService) {
    firebaseService.getDeals().listen((event) {
      dealsSink.add(event);
    });
  }

  @override
  void dispose() {
    dealsController.close();
  }
}
