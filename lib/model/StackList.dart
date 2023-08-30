import 'dart:collection';

class StackList<T>{
  final _stack = Queue<T>();

  void push(T value){
    _stack.addLast(value);
  }

  T pop(){
    T value = _stack.last;
    _stack.removeLast();
    return value;
  }

  bool canPop(){
    return _stack.isNotEmpty;
  }

  T top(){
    return _stack.last;
  }

  int length(){
    return _stack.length;
  }

  void clear(){
    _stack.clear();
  }

}