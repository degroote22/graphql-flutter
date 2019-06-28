import 'package:flutter/widgets.dart';

import 'package:graphql/client.dart';
import 'package:graphql/internal.dart';
import 'package:graphql/src/core/query_options.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:graphql_flutter/src/widgets/graphql_provider.dart';
import 'package:rxdart/rxdart.dart';

// typedef RefetchCallback = bool Function({
// FetchPolicy fetchPolicy,
// });
typedef dynamic FetchMore(FetchMoreOptions options);

typedef QueryBuilderFetchMore = Widget Function(
  List<QueryResult> result, {
  RefetchCallback refetch,
  FetchMore fetchMore,
});

/// Builds a [Query] widget based on the a given set of [QueryOptions]
/// that streams [QueryResult]s into the [QueryBuilder].
typedef dynamic Transformer(List<QueryResult> results);

class QueryFetchMore<T> extends StatefulWidget {
  const QueryFetchMore({
    final Key key,
    @required this.options,
    @required this.builder,
  }) : super(key: key);

  final QueryOptions options;
  final QueryBuilderFetchMore builder;

  @override
  QueryFetchMoreState createState() => QueryFetchMoreState();
}

Stream<List<QueryResult>> merge(List<Stream<QueryResult>> streams) {
  var s = CombineLatestStream.list(streams).asBroadcastStream();
  return s;
}

class QueryFetchMoreState extends State<QueryFetchMore> {
  List<ObservableQuery> observableQueries = [];
  Stream<List<QueryResult>> combinedStream;
  WatchQueryOptions makeOptions(QueryOptions options) {
    FetchPolicy fetchPolicy = options.fetchPolicy;

    if (fetchPolicy == FetchPolicy.cacheFirst) {
      fetchPolicy = FetchPolicy.cacheAndNetwork;
    }

    // TODO: if it is cached we may get trouble

    return WatchQueryOptions(
      document: options.document,
      variables: options.variables,
      fetchPolicy: fetchPolicy,
      errorPolicy: options.errorPolicy,
      pollInterval: options.pollInterval,
      fetchResults: true,
      context: options.context,
      optimisticResult: options.optimisticResult,
    );
  }

  void _initQuery() {
    final GraphQLClient client = GraphQLProvider.of(context).value;
    assert(client != null);
    observableQueries.forEach((observableQuery) {
      observableQuery.close();
    });
    observableQueries = [client.watchQuery(makeOptions(widget.options))];
    _updateCombinedStream();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initQuery();
  }

  @override
  void didUpdateWidget(QueryFetchMore oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!observableQueries[0].options.areEqualTo(makeOptions(widget.options))) {
      _initQuery();
    }
  }

  @override
  void dispose() {
    observableQueries.forEach((observableQuery) {
      observableQuery.close();
    });
    super.dispose();
  }

  void _fetchMore(FetchMoreOptions fetchMoreOptions) {
    final GraphQLClient client = GraphQLProvider.of(context).value;

    QueryOptions combinedOptions;

    if (fetchMoreOptions.document != null) {
      // use query as is
      combinedOptions = QueryOptions(
        document: fetchMoreOptions.document,
        variables: {
          ...makeOptions(widget.options).variables,
          ...fetchMoreOptions.variables
        },
        context: makeOptions(widget.options).context,
      );
    } else {
      /// combine the QueryOptions and FetchMoreOptions
      combinedOptions = QueryOptions(
        document: makeOptions(widget.options).document,
        variables: {
          ...makeOptions(widget.options).variables,
          ...fetchMoreOptions.variables
        },
        context: makeOptions(widget.options).context,
      );
    }
    observableQueries.add(client.watchQuery(makeOptions(combinedOptions)));
    _updateCombinedStream();
  }

  void _updateCombinedStream() {
    final GraphQLClient client = GraphQLProvider.of(context).value;
    combinedStream = merge(observableQueries.map((x) => x.stream).toList());
    combinedStream.listen((d) {}); // TODO: why do we need this?
    setState(() {});
    client.queryManager.rebroadcastQueries();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QueryResult>>(
      initialData: [QueryResult(loading: true)],
      stream: combinedStream,
      builder: (
        BuildContext buildContext,
        AsyncSnapshot<List<QueryResult>> snapshot,
      ) {
        final bool length_difference =
            observableQueries.length != snapshot.data.length;

        return widget?.builder(
          length_difference
              ? [...snapshot.data, QueryResult(loading: true)]
              : snapshot.data,
          refetch: ({fetchPolicy}) {
            var refetched = false;
            observableQueries.forEach((observableQuery) {
              refetched = refetched ||
                  observableQuery.refetch(fetchPolicy: fetchPolicy);
            });
            return refetched;
          },
          fetchMore: _fetchMore,
        );
      },
    );
  }
}
