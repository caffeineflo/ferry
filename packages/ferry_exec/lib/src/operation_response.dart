import 'package:meta/meta.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:gql_link/gql_link.dart';
import 'package:collection/collection.dart';

import 'package:ferry_exec/src/operation_request.dart';

enum DataSource {
  /// A placeholder response source which can be used when waiting for another source
  None,

  /// Data originated from the client's [Link]
  Link,

  /// Data originated from the [Cache]
  Cache,

  /// Data originated from a user-provided [OperationRequest.optimisticResponse]
  Optimistic,
}

enum ResponseState {
  /// Before the response has been requested.
  Idle,

  /// When the response was successfully fetched.
  Succeeded,

  /// When the response failed to fetch.
  Failed,
}

/// Encapsulates a GraphQL operation's response, with typed
/// input and responses, and errors.
@immutable
class OperationResponse<TData, TVars> {
  /// The event that resulted in this response
  final OperationRequest<TData, TVars> operationRequest;

  /// The origin of the response.
  final DataSource dataSource;

  /// The typed data of this response.
  final TData? data;

  /// Extension data returned with the response
  final dynamic extensions;

  /// The list of errors in this response.
  final List<GraphQLError>? graphqlErrors;

  /// Any error returned by [Link]
  final LinkException? linkException;

  /// The current state of the response
  final ResponseState state;

  /// If this response is loading.
  bool get loading => state == ResponseState.Idle;

  /// If this response has any error.
  bool get hasErrors =>
      linkException != null ||
      (graphqlErrors != null && graphqlErrors!.isNotEmpty);

  /// Instantiates a GraphQL response.
  const OperationResponse({
    required this.operationRequest,
    this.dataSource = DataSource.None,
    this.data,
    this.extensions,
    this.graphqlErrors,
    this.linkException,
    this.state = ResponseState.Idle,
  });

  List<Object?> _getChildren() => [
        operationRequest,
        dataSource,
        data,
        extensions,
        graphqlErrors,
        linkException,
        state,
      ];

  @override
  bool operator ==(Object o) =>
      o is OperationResponse &&
      const DeepCollectionEquality().equals(
        o._getChildren(),
        _getChildren(),
      );

  @override
  int get hashCode => const DeepCollectionEquality().hash(
        _getChildren(),
      );
}
