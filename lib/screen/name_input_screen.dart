
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spinning_wheel/screen/spin_screen.dart';

import '../state_provider/names_provider.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NameProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Names")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter name",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      provider.addName(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: provider.names.length,
                itemBuilder: (_, index) => ListTile(
                  title: Text(provider.names[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete , color: Colors.red,),
                    onPressed: () => provider.removeName(index),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: provider.names.length < 2
                  ? null
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SpinScreen(),
                  ),
                );
              },
              child: const Text("Go to Spin Wheel"),
            )
          ],
        ),
      ),
    );
  }
}