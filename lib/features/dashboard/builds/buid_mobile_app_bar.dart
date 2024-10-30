import 'package:finance_tracker/currents/current_account.dart';
import 'package:finance_tracker/database/models/users.dart';
import 'package:flutter/material.dart';

PreferredSize buildAppBar(CurrentAccount accountProvider, Users user) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(60),
    child: AppBar(
      backgroundColor: Colors.teal,
      leading: const CircleAvatar(
        backgroundImage: AssetImage('assets/icons/nexus.jpeg'),
      ),
      title: const Padding(
        padding: EdgeInsets.only(left: 50.0),
        child: Text(
          'Nexus Finance Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      actions: [
        FutureBuilder(
          future: accountProvider.getImage(user.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasError) {
              return const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              );
            } else if (snapshot.hasData) {
              return CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                backgroundImage: MemoryImage(snapshot.data!),
              );
            } else {
              return const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person),
              );
            }
          },
        ),
      ],
    ),
  );
}
