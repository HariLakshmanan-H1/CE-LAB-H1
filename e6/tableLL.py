import json
from collections import OrderedDict

# ------------------------ FIRST & FOLLOW sets ------------------------
first = {
    "E": ['(', "name", "num"],
    "E'": ['+', '-', 'e'],
    "T": ['(', "name", "num"],
    "T'": ['*', '/', 'e'],
    "F": ['(', "name", "num"]
}

follow = {
    "E": ['$', ')'],
    "E'": ['$', ')'],
    "T": ['+', '-', ')', '$'],
    "T'": ['+', '-', ')', '$'],
    "F": ['*', '/', '+', '-', ')', '$']
}

# Special FIRST entries for epsilon productions
epsilon_first = {
    "E'": ['$', ')'],
    "T'": ['$', '+', '-', ')']
}

# ------------------------ Grammar reading ------------------------
def read_grammar_from_file(filename):
    """Read grammar from a file and return productions as a dictionary."""
    productions = OrderedDict()
    with open(filename, 'r') as file:
        for line in file:
            line = line.strip()
            if not line:
                continue
            lhs, rhs = line.split("->")
            lhs = lhs.strip()
            rhs = rhs.strip()
            alternatives = [prod.strip() for prod in rhs.split("|")]
            productions[lhs] = alternatives
    return productions

# ------------------------ LL(1) Table Construction ------------------------
def construct_ll1_table(productions, first, epsilon_first, terminals, nonterminals):
    """Construct LL(1) parsing table using FIRST and epsilon FIRST sets."""
    table = {(nt, t): 'phi' for nt in nonterminals for t in terminals}

    for lhs, productions_list in productions.items():
        for production in productions_list:
            symbols = production.split()
            reversed_symbols = symbols[::-1]  # Stack push order
            first_symbol = symbols[0]

            if first_symbol in terminals:
                table[(lhs, first_symbol)] = ' '.join(reversed_symbols)
            elif first_symbol in nonterminals:
                for terminal in first[first_symbol]:
                    table[(lhs, terminal)] = ' '.join(reversed_symbols)
            else:
                # Epsilon production
                for terminal in epsilon_first[lhs]:
                    table[(lhs, terminal)] = 'e'

    return table

# ------------------------ String Parsing ------------------------
def parse_string(ll1_table, input_string, start_symbol='E'):
    """Parse a string using the LL(1) table."""
    tokens = input_string.split()
    stack = [start_symbol]
    i = 0
    n = len(tokens)

    print("Parsing steps:")
    while i < n:
        current_token = tokens[i]
        top_stack = stack.pop(-1)

        if top_stack == current_token:
            # Terminal matches
            i += 1
        elif top_stack == 'e':
            # Epsilon → skip
            continue
        else:
            # Nonterminal → lookup LL(1) table
            production_to_push = ll1_table.get((top_stack, current_token))
            if not production_to_push:
                print(f"Error: No rule for ({top_stack}, {current_token})")
                return
            for symbol in production_to_push.split():
                stack.append(symbol)

        print(stack)

    if not stack:
        print("\nInput accepted ✅")
    else:
        print("\nInput rejected ❌")

# ------------------------ Main ------------------------
def main():
    # Terminals and nonterminals
    terminals = ['$', '+', '-', '*', '/', '(', ')', "name", "num"]
    nonterminals = ['E', "E'", 'T', "T'", 'F']

    # Read grammar
    productions = read_grammar_from_file("grammar.txt")
    print("Productions:")
    print(json.dumps(productions, indent=4))

    # Construct LL(1) table
    ll1_table = construct_ll1_table(productions, first, epsilon_first, terminals, nonterminals)
    print("\nLL(1) Parsing Table:")
    for key in ll1_table:
        print(f"{key}: {ll1_table[key]}")

    # Example string parsing
    print("\nString parsing for input: 'name'")
    parse_string(ll1_table, "name")

if __name__ == "__main__":
    main()