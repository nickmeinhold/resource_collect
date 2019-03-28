import 'dart:async';

import 'package:angular/core.dart';
import 'package:firebase/firebase.dart';

import '../models/resource.dart';

/// 
@Injectable()
class TodoListService {

  Future<List<Resource>> getResourcesList() async {
    List<Resource> resources = List();
    var snapshot = await firestore().collection("resources").get();
    snapshot.forEach((doc) {
      resources.add(Resource(doc.data()["title"], doc.data()["url"]));
    });
    return resources;
  }
}
