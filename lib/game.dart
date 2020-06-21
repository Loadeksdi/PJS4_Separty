import 'dart:async';


final StreamController<int> pinSc = new StreamController();
final Stream<int> pinStream = pinSc.stream.asBroadcastStream();
final StreamController<List<String>> idsSc = new StreamController();
final Stream<List<String>> idsStream = idsSc.stream.asBroadcastStream();
int pin;
List <String> userIds = ['','','',''];
String question;


