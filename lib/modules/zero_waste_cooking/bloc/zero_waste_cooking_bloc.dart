import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saver_bbk_main/api/app_apis.dart';
import 'package:saver_bbk_main/models/protein_plan_model.dart';
part 'zero_waste_cooking_event.dart';
part 'zero_waste_cooking_state.dart';

class ZeroWasteCookingBloc
    extends Bloc<ZeroWasteCookingEvent, ZeroWasteCookingState> {
  ZeroWasteCookingBloc() : super(ZeroWasteCookingInitial()) {
    on<GeneratePortionPlanEvent>(_generatePortionPlanEvent);
  }

  void _generatePortionPlanEvent(
    GeneratePortionPlanEvent event,
    Emitter<ZeroWasteCookingState> emit,
  ) async {
    emit(GeneratingLoadingState(isLoading: true));
    try {
      GenaratedProteinPlanModel genPortionPlan = await AppApis()
          .generateProteinPlan(
            event.whatareyoucooking,
            event.towhomareyoucooking,
            event.numberOfServings,
            event.dietaryPreferences,
            event.ingredients,
          );
      if (genPortionPlan.success == true) {
        emit(GeneratedSuccessState(generatedPortionPlan: genPortionPlan));
      } else {
        emit(GeneratedFailureState(errorMessage: "Failed to generate"));
      }
    } catch (e) {
      emit(GeneratedFailureState(errorMessage: e.toString()));
    }
  }
}
