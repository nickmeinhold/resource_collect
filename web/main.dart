// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter_web_ui/ui.dart' as ui;
import 'package:resource_collect/main.dart' as app;
import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firestore.dart';

firebase.App fb;
Firestore firestore;

main() async {
  await ui.webOnlyInitializePlatform();
  firestore = firebase.firestore();
  app.main();
}
