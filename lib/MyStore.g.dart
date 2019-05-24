// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MyStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$MyStore on MyStoreBase, Store {
  final _$darkThemeAtom = Atom(name: 'MyStoreBase.darkTheme');

  @override
  bool get darkTheme {
    _$darkThemeAtom.reportObserved();
    return super.darkTheme;
  }

  @override
  set darkTheme(bool value) {
    _$darkThemeAtom.context
        .checkIfStateModificationsAreAllowed(_$darkThemeAtom);
    super.darkTheme = value;
    _$darkThemeAtom.reportChanged();
  }

  final _$MyStoreBaseActionController = ActionController(name: 'MyStoreBase');

  @override
  dynamic _setTheme(dynamic _darkTheme) {
    final _$actionInfo = _$MyStoreBaseActionController.startAction();
    try {
      return super._setTheme(_darkTheme);
    } finally {
      _$MyStoreBaseActionController.endAction(_$actionInfo);
    }
  }
}
