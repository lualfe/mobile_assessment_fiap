import 'package:mobile_project/models/measurement.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MeasurementDAO {
  Future<Database> getDatabase() async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), 'measurements_database.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE measurements(id INTEGER PRIMARY KEY, bodyPart TEXT, value REAL, updatedAt INTEGER);");
    }, version: 1);

    return db;
  }

  Future<List<Measurement>> readCurrentMeasurements() async {
    Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('measurements',
        columns: ['id', 'bodyPart', 'value', 'MAX(updatedAt) as updatedAt'],
        groupBy: "bodyPart");

    List<Measurement> result = List.generate(maps.length, (i) {
      return Measurement(maps[i]['id'], maps[i]['bodyPart'], maps[i]['value'],
          maps[i]['updatedAt']);
    });

    return result;
  }

  Future<int> insertMeasurement(Measurement measurement) async {
    Database db = await getDatabase();
    return db.insert('measurements', measurement.toMap());
  }

  Future<List<Measurement>> readMeasurementsFromPart(String part) async {
    Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('measurements',
        where: "bodyPart = ?", whereArgs: [part], orderBy: "updatedAt asc");

    List<Measurement> result = List.generate(maps.length, (i) {
      return Measurement(maps[i]['id'], maps[i]['bodyPart'], maps[i]['value'],
          maps[i]['updatedAt']);
    });

    return result;
  }
}
