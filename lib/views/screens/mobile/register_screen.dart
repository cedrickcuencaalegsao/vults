import 'package:flutter/material.dart';

class RegisterFirstScreen extends StatefulWidget {
  const RegisterFirstScreen({super.key});

  @override
  RegisterFirstScreenState createState() => RegisterFirstScreenState();
}

class RegisterFirstScreenState extends State<RegisterFirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register First Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterSecondScreen()),
            );
          },
          child: Text('Go to Register Second Screen'),
        ),
      ),
    );
  }
}

class RegisterSecondScreen extends StatefulWidget {
  const RegisterSecondScreen({super.key});

  @override
  RegisterSecondScreenState createState() => RegisterSecondScreenState();
}

class RegisterSecondScreenState extends State<RegisterSecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register Second Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterThirdScreen()),
            );
          },
          child: Text('Go to Register Third Screen'),
        ),
      ),
    );
  }
}

class RegisterThirdScreen extends StatefulWidget {
  const RegisterThirdScreen({super.key});

  @override
  RegisterThirdScreenState createState() => RegisterThirdScreenState();
}

class RegisterThirdScreenState extends State<RegisterThirdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register Third Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: Text('Go to Register Third Screen'),
        ),
      ),
    );
  }
}
