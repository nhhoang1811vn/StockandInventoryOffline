import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecases/expenses/expense_usercases.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/storage.dart';
import '../../base/base_state.dart';

part 'report_cubit.freezed.dart';
part 'report_state.dart';

@injectable
class ReportCubit extends Cubit<ReportState> {
  final Storage storage;
  final ExpenseUseCases expenseUseCase;
  ReportCubit({
    required this.storage,
    required this.expenseUseCase
  }) : super(ReportState.initial(state: InitialState()));

}
