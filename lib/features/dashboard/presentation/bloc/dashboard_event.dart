import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboardDataEvent extends DashboardEvent {}

class SelectCategoryEvent extends DashboardEvent {
  final String category;

  const SelectCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}
