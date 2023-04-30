import 'package:flutter/material.dart';
import 'package:pimpmynurse/utils/kv_store.dart';

class Welcome {
  static void welcome(context) {
    String welcomed = 'welcomed';
    if (KVStore.localStorage.getBool(welcomed) == null ||
        !KVStore.localStorage.getBool(welcomed)!) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                insetPadding:
                    const EdgeInsets.symmetric(horizontal: 1.0, vertical: 25.0),
                contentPadding:
                    const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                title: const Center(child: Text('Welcome')),
                content: const RawScrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text('''
Welcome to Pimp My Nurse, an app designed to make the lives of nurses easier and more efficient.

This application goal is to provide you with a user-friendly interface and helpful tools that will simplify your tasks, save you time, and ultimately improve patient care.

We hope it will make a positive impact on your work and your patients' lives.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

For more information: https://github.com/fydrah/pimpmynurse/blob/main/LICENSE

Report issues at https://github.com/fydrah/pimpmynurse/issues
New features and tools ideas are welcome too.

Enjoy!

Copyright (C) 2023 @fydrah
                                '''),
                  ),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close')),
                ],
              )).then((_) {
        KVStore.localStorage.setBool(welcomed, true);
      });
    }
  }
}
