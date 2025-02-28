class FibonacciUtils {
  static List<int> generateFibonacci(int count) {
    List<int> sequence = [0, 1];
    for (int i = 2; i < count; i++) {
      sequence.add(sequence[i - 1] + sequence[i - 2]);
    }
    return sequence;
  }
}
