import 'package:equatable/equatable.dart';

abstract class UtellySearchEvent extends Equatable {
  const UtellySearchEvent();
}

class TextChanged extends UtellySearchEvent {
  final String text;

  const TextChanged({this.text});

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'TextChanged { text: $text }';
}
