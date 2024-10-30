import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final databaseProvider =
    Provider((ref) => Database(client: Supabase.instance.client));

class Database {
  final SupabaseClient client;

  Database({required this.client});

  Future<List<Map<String, dynamic>>> get(String table) async {
    try {
      return await client.from(table).select();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return [];
  }

  Future<void> add(String table, var model) async {
    try {
      if (kDebugMode) {
        print(model.toMap());
      }
      await client.from(table).insert(model.toMap());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> update(String table, var model, String id) async {
    try {
      await client.from(table).update(model.toMap()).eq('id', id);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> delete(String table, String id) async {
    try {
      await client.from(table).delete().eq('id', id);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
