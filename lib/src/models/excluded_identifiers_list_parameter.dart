import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:solid_lints/src/models/excluded_identifier_parameter.dart';

/// A data model class that represents the exclude input
/// parameters.
class ExcludedIdentifiersListParameter {
  /// A list of identifiers (classes, methods, functions) that should be
  /// excluded from the lint.
  final List<ExcludedIdentifierParameter> exclude;

  /// A common parameter key for analysis_options.yaml
  static const String excludeParameterName = 'exclude';

  /// Constructor for [ExcludedIdentifiersListParameter] model
  ExcludedIdentifiersListParameter({
    required this.exclude,
  });

  /// Method for creating from json data
  factory ExcludedIdentifiersListParameter.fromJson({
    required Iterable<dynamic> excludeList,
  }) {
    final exclude = <ExcludedIdentifierParameter>[];

    for (final item in excludeList) {
      if (item is Map) {
        exclude.add(ExcludedIdentifierParameter.fromJson(item));
      }
    }
    return ExcludedIdentifiersListParameter(
      exclude: exclude,
    );
  }

  /// Returns whether the target node should be ignored during analysis.
  bool shouldIgnore(Declaration node) {
    final methodName = node.declaredElement?.name;

    final excludedItem =
        exclude.firstWhereOrNull((e) => e.methodName == methodName);

    if (excludedItem == null) return false;

    final className = excludedItem.className;

    if (className == null || node is! MethodDeclaration) {
      return true;
    } else {
      final classDeclaration = node.thisOrAncestorOfType<ClassDeclaration>();

      return classDeclaration != null &&
          classDeclaration.name.toString() == className;
    }
  }
}
