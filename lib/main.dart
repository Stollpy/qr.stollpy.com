import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/bloc/redirection_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'Stollpy QR',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => RedirectionBloc())
        ],
        child: const Scaffold(
          body: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    setState(() {
      _loading = true;
    });

    context.read<RedirectionBloc>().add(InitRedirection());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RedirectionBloc, RedirectionState>(
        listener: (context, state) {
          if (state.errors.isNotEmpty) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.errors.first),
                duration: const Duration(milliseconds: 4000),
                elevation: 5,
              ))
            ;
          } else if (state.isSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text("La redirection à bien été enregistrer"),
                duration: Duration(milliseconds: 4000),
                elevation: 5,
              ))
            ;
          } else if (state.isInit) {
            setState(() {
              _textController.text = state.redirection;
            });
          }

          setState(() {
            _loading = state.isLoading;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Stollpy QR",
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                readOnly: _loading,
                controller: _textController,
                decoration: InputDecoration(
                  labelText: "Entrer une redirection"
                ),
              ),
              const SizedBox(height: 50,),
              ElevatedButton(
                  onPressed: () => context.read<RedirectionBloc>().add(RedirectionChange(redirection: _textController.text)),
                  child: Text("Enregistrer"),
              )
            ],
          ),
        ),
    );
  }
}
