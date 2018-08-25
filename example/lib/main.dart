import 'package:app/generated/AddStarMutation.dart';
import 'package:app/generated/ReadRepositoriesQuery.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import './mutations/addStar.dart' as mutations;
import './queries/readRepositories.dart' as queries;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ValueNotifier<Client> client = ValueNotifier(
      Client(
        endPoint: 'https://api.github.com/graphql',
        cache: InMemoryCache(),
        apiToken: '<YOUR_GITHUB_PERSONAL_ACCESS_TOKEN>',
      ),
    );

    return GraphqlProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Query(
        queries.readRepositories,
        pollInterval: 1,
        builder: ({
          bool loading,
          Map data,
          Exception error,
        }) {
          if (error != null) {
            return Text(error.toString());
          }

          if (loading) {
            return Text('Loading');
          }

          var queryResponse = ReadRepositories(data);

          var repositories = queryResponse.viewer.repositories.nodes
              .fold(() => [], (nodes) => nodes);

          return ListView.builder(
            itemCount: repositories.length,
            itemBuilder: (context, index) {
              final repository = repositories[index];

              return Mutation(
                mutations.addStar,
                builder: (
                  addStar, {
                  bool loading,
                  Map data,
                  Exception error,
                }) {
                  var mutationResponse = AddStar(data);

                  return ListTile(
                    leading: mutationResponse.addStar.fold(() => false,
                            (addStar) => addStar.starrable.viewerHasStarred)
                        ? const Icon(Icons.star, color: Colors.amber)
                        : const Icon(Icons.star_border),
                    title: Text(
                      repository.fold(() => "", (rep) => rep.name),
                      // NOTE: optimistic ui updates are not implemented yet, therefore changes may take upto 1 second to show.
                    ),
                    onTap: () {
                      addStar(addStarVariables(
                          starrableId:
                              repository.fold(() => "", (rep) => rep.id)));
                    },
                  );
                },
                onCompleted: (Map<String, dynamic> data) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Thanks for your star!'),
                        actions: <Widget>[
                          SimpleDialogOption(
                            child: Text('Dismiss'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
