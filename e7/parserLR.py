# Terminals and Non-terminals

terminals = ['a', 'b', '$']
non_terminals = ['S', 'A']

# Grammar rules

grammar_rules = {
    1: "S a A",
    2: "A b"
}

# Parsing Table: ACTION + GOTO
# Columns: [a, b, $, S, A]

parsing_table = [
    ['S1','','','',''],
    ['','S2','','',''],
    ['','','accept','',''],
    ['','','','R2','']
]

# Input string (you can read from file)

input_string = ['a', 'b', '$']

# LR Parsing Stack

parse_stack = [0] # stack stores states and symbols alternately
input_pointer = 0
accepted = True

# Parsing Process

try:

    while True:
        current_state = parse_stack[-1]
        current_symbol = input_string[input_pointer]

        # ACTION column
        if current_symbol in terminals:
            action_col = terminals.index(current_symbol)
        else:
            raise Exception(f"Unknown terminal {current_symbol}")

        action = parsing_table[current_state][action_col]

        # ACCEPT
        if action == 'accept':
            break

        # SHIFT
        elif action.startswith('S'):
            next_state = int(action[1:])
            parse_stack.append(current_symbol)
            parse_stack.append(next_state)
            input_pointer += 1

        # REDUCE
        elif action.startswith('R') or action.startswith('r'):
            rule_number = int(action[1:])
            lhs, *rhs_symbols = grammar_rules[rule_number].split()

            # Pop 2 * |RHS| symbols and states
            for _ in range(len(rhs_symbols) * 2):
                parse_stack.pop()

            # Push LHS non-terminal
            parse_stack.append(lhs)

            # GOTO: previous_state x LHS
            previous_state = parse_stack[-2] # state below LHS
            goto_col = len(terminals) + non_terminals. index(lhs)
            goto_state = parsing_table[previous_state][goto_col]
            if goto_state == '' or goto_state == 'phi':
                raise Exception("Parsing Error: invalid GOTO")
            parse_stack.append(int(goto_state))

        else:
            raise Exception("Parsing Error")

except Exception:
    accepted = False

# Output Result

if accepted:
    print("Accepted")
else:
    print("Not Accepted")