import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/model/models.dart';
import 'package:task_manager/respository/repository.dart';

enum TaskSort{titleAsce,isCom}
abstract class TaskEvent extends Equatable{
 const TaskEvent();
  @override
  List<Object?> get prop=>[];
}
class TaskLoad extends TaskEvent{
  const TaskLoad();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class TaskAdd extends TaskEvent{
  final String title;
  final String description;
  const TaskAdd(this.title,this.description);
  @override
  List<Object?> get props =>[title,description];

}
class TaskSorted extends TaskEvent{
  final TaskSort sort;
  const TaskSorted(this.sort);
  @override
  List<Object?> get props=>[sort];
}
class TaskQueryChanged extends TaskEvent {
  final String query;
  const TaskQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

 class TaskState extends Equatable{
  final List<todoData> visible;
  final List<todoData> all;
  final bool loading;
  final String? error;
  final TaskSort sort;
  final String query;
  const TaskState({
    this.all=const[],
    this.visible=const[],
    this.error,
    this.loading=false,
    this.sort=TaskSort.titleAsce,
    this.query=''
});
  TaskState copyWith({
    List<todoData>?all,
    List<todoData>?visible,
    bool? loading,
    String? error,
    TaskSort? sort,
    String?query
}) {
    return TaskState(
        all: all ?? this.all,
        visible: visible ?? this.visible,
        loading: loading ?? this.loading,
        error: error ?? this.error,
        sort: sort ?? this.sort,
      query: query ?? this.query,
    );
  }
  @override
  List<Object?> get props=>[all, visible, loading, error, sort,query];
 }

 class TaskBloc extends Bloc<TaskEvent,TaskState>{
  final TodoRepository repo;
  TaskBloc(this.repo) : super(const TaskState()){
    on<TaskLoad>(onLoad);
    on<TaskAdd>(onAdd);
    on<TaskSorted>(onSort);
    on<TaskQueryChanged>(onQuery);
  }

   Future<void> onLoad(TaskLoad event, Emitter<TaskState>emit)async{
    emit(state.copyWith(loading: true,error: null));
    try {
      final list = await repo.taskList();
    emit ( state.copyWith(
        all: list,
        visible: list,
        loading: false,
        error: null,
      ));
    }
    catch(e){
      emit(state.copyWith(loading: false,error: e.toString()));

    }
   }
  Future<void> onAdd(TaskAdd event, Emitter<TaskState> emit) async {
    try{
     final created = await repo.addTask(title: event.title, description: event.description);
     final all = [created, ...state.all];
     emit(state.copyWith(all: all, visible: apply(all, state.sort, state.query)));
    }catch (e){
      emit(state.copyWith(error: e.toString()));
    }

  }

  Future<void> onSort(TaskSorted event, Emitter<TaskState> emit) async {

    emit(state.copyWith(
      sort: event.sort,
      visible: apply(state.all, event.sort, state.query),
    ));
  }

List<todoData> apply(List<todoData> input, TaskSort sort, String query) {
  final q = query.toLowerCase();
  final filtered = q.isEmpty ? List<todoData>.from(input) : input.where((t) => t.title.toLowerCase().contains(q)).toList();
  switch (sort) {
    case TaskSort.titleAsce:
      filtered.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      break;
    case TaskSort.isCom:
      filtered.sort((a, b) => a.isCompleted == b.isCompleted
          ? a.title.toLowerCase().compareTo(b.title.toLowerCase())
          : (a.isCompleted ? -1 : 1));
      break;
  }
  return filtered;
}
void onQuery(TaskQueryChanged event, Emitter<TaskState> emit) {
  emit(state.copyWith(
    query: event.query,
    visible: apply(state.all, state.sort, event.query),
  ));
}
}