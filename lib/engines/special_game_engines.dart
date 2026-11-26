import 'package:flutter/material.dart';

class CodeLineEngine extends StatelessWidget {
  final List<String> lines;
  final String answer;
  final ValueChanged<bool> onAnswered;

  const CodeLineEngine({
    super.key,
    required this.lines,
    required this.answer,
    required this.onAnswered,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(14),
                  backgroundColor: const Color(0xFF101322),
                  foregroundColor: const Color(0xFFB9F3FF),
                  side: const BorderSide(color: Color(0xFF343651)),
                ),
                onPressed: () => onAnswered(line == answer),
                child:
                    Text(line, style: const TextStyle(fontFamily: 'monospace')),
              ),
            ),
          ),
        ],
      );
}

class OrderingEngine extends StatefulWidget {
  final List<String> correctOrder;
  final ValueChanged<bool> onCompleted;

  const OrderingEngine({
    super.key,
    required this.correctOrder,
    required this.onCompleted,
  });

  @override
  State<OrderingEngine> createState() => _OrderingEngineState();
}

class _OrderingEngineState extends State<OrderingEngine> {
  late List<String> items;

  @override
  void initState() {
    super.initState();
    items = List.of(widget.correctOrder)..shuffle();
    if (items.length > 1 &&
        List.generate(items.length, (index) => index)
            .every((index) => items[index] == widget.correctOrder[index])) {
      items = [items.last, ...items.take(items.length - 1)];
    }
  }

  void move(int index, int offset) {
    final nextIndex = index + offset;
    if (nextIndex < 0 || nextIndex >= items.length) return;
    setState(() {
      final item = items.removeAt(index);
      items.insert(nextIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...items.indexed.map((entry) {
            final index = entry.$1;
            final item = entry.$2;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF24233F),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF343651)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: const Color(0xFF7139C5),
                    child: Text('${index + 1}',
                        style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(item,
                        style: const TextStyle(
                            color: Colors.white, fontFamily: 'monospace')),
                  ),
                  IconButton(
                    tooltip: 'Move up',
                    visualDensity: VisualDensity.compact,
                    onPressed: index == 0 ? null : () => move(index, -1),
                    icon: const Icon(Icons.keyboard_arrow_up),
                  ),
                  IconButton(
                    tooltip: 'Move down',
                    visualDensity: VisualDensity.compact,
                    onPressed:
                        index == items.length - 1 ? null : () => move(index, 1),
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => widget.onCompleted(_sameOrder()),
            icon: const Icon(Icons.check),
            label: const Text('Check sequence'),
          ),
        ],
      );

  bool _sameOrder() {
    for (var index = 0; index < items.length; index++) {
      if (items[index] != widget.correctOrder[index]) return false;
    }
    return true;
  }
}

class LogicGateEngine extends StatefulWidget {
  final List<String> gates;
  final String answer;
  final ValueChanged<bool> onAnswered;

  const LogicGateEngine({
    super.key,
    required this.gates,
    required this.answer,
    required this.onAnswered,
  });

  @override
  State<LogicGateEngine> createState() => _LogicGateEngineState();
}

class _LogicGateEngineState extends State<LogicGateEngine> {
  bool inputA = true;
  bool inputB = false;
  String? selectedGate;

  bool get output {
    switch (selectedGate) {
      case 'AND':
        return inputA && inputB;
      case 'OR':
        return inputA || inputB;
      case 'XOR':
        return inputA != inputB;
      case 'NOT':
        return !inputA;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Expanded(child: Text('Input A')),
                    Switch(
                      value: inputA,
                      onChanged: (value) => setState(() => inputA = value),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Expanded(child: Text('Input B')),
                    Switch(
                      value: inputB,
                      onChanged: (value) => setState(() => inputB = value),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            children: widget.gates.map((gate) {
              return ChoiceChip(
                label: Text(gate),
                selected: selectedGate == gate,
                onSelected: (_) => setState(() => selectedGate = gate),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: output ? const Color(0xFF123536) : const Color(0xFF24233F),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: output
                      ? const Color(0xFF22D3EE)
                      : const Color(0xFF454363)),
            ),
            child: Text(
              'LIVE OUTPUT   ${output ? 1 : 0}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xFF22D3EE),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: selectedGate == null
                ? null
                : () => widget.onAnswered(selectedGate == widget.answer),
            child: const Text('Lock in gate'),
          ),
        ],
      );
}

class SortingEngine extends StatefulWidget {
  final List<int> values;
  final ValueChanged<bool> onCompleted;

  const SortingEngine({
    super.key,
    required this.values,
    required this.onCompleted,
  });

  @override
  State<SortingEngine> createState() => _SortingEngineState();
}

class _SortingEngineState extends State<SortingEngine> {
  late List<int> values;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    values = List.of(widget.values);
  }

  void tapBar(int index) {
    setState(() {
      if (selectedIndex == null) {
        selectedIndex = index;
      } else {
        final selected = selectedIndex!;
        if ((selected - index).abs() == 1) {
          final value = values[selected];
          values[selected] = values[index];
          values[index] = value;
        }
        selectedIndex = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(
            height: 190,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: values.indexed.map((entry) {
                final index = entry.$1;
                final value = entry.$2;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () => tapBar(index),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('$value',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            height: value * 16.0,
                            decoration: BoxDecoration(
                              color: selectedIndex == index
                                  ? const Color(0xFFFBBF24)
                                  : const Color(0xFFA855F7),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Select two adjacent bars to swap them.',
              style: TextStyle(color: Color(0xFFA6A6BD))),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => widget.onCompleted(_isSorted()),
            icon: const Icon(Icons.emoji_events_outlined),
            label: const Text('Check sorted order'),
          ),
        ],
      );

  bool _isSorted() {
    for (var index = 1; index < values.length; index++) {
      if (values[index - 1] > values[index]) return false;
    }
    return true;
  }
}

class StackEngine extends StatefulWidget {
  final List<int> pushValues;
  final int expectedTop;
  final ValueChanged<bool> onCompleted;

  const StackEngine({
    super.key,
    required this.pushValues,
    required this.expectedTop,
    required this.onCompleted,
  });

  @override
  State<StackEngine> createState() => _StackEngineState();
}

class _StackEngineState extends State<StackEngine> {
  final List<int> stack = [];

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 170,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF101322),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFA855F7)),
            ),
            child: stack.isEmpty
                ? const Center(
                    child: Text('STACK EMPTY',
                        style: TextStyle(color: Color(0xFFA6A6BD))))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: stack
                        .map((value) => Container(
                              width: 120,
                              margin: const EdgeInsets.only(top: 5),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7139C5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('$value',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white)),
                            ))
                        .toList(),
                  ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              ...widget.pushValues.map((value) => OutlinedButton(
                    onPressed: () => setState(() => stack.add(value)),
                    child: Text('Push $value'),
                  )),
              OutlinedButton(
                onPressed: stack.isEmpty
                    ? null
                    : () => setState(() {
                          stack.removeLast();
                        }),
                child: const Text('Pop'),
              ),
            ],
          ),
          FilledButton(
            onPressed: () => widget.onCompleted(
                stack.isNotEmpty && stack.last == widget.expectedTop),
            child: const Text('Check top value'),
          ),
        ],
      );
}
