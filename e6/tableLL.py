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
    
    table = {(nt, t): None for nt in nonterminals for t in terminals}

    for A, rules in productions.items():
        for rule in rules:
            symbols = rule.split()

            # epsilon production
            if symbols[0] == 'e':
                for t in follow[A]:
                    table[(A, t)] = rule

            # terminal start
            elif symbols[0] in terminals:
                table[(A, symbols[0])] = rule

            # nonterminal start
            else:
                for t in first[symbols[0]]:
                    if table[(A, t)] is None:   # 👈 IMPORTANT
                        table[(A, t)] = rule

    return table

# ------------------------ String Parsing ------------------------
def parse_string(ll1_table, terminals,start_symbol='E'):
    """Parse a string using the LL(1) table."""
    print("String parsing")

    string = "num + num"
    tokens = string.split(" ") + ['$']

    stack = ['$', 'E']
    i = 0
    n = len(tokens)

    while stack:
        element = tokens[i]
        top = stack.pop()

        print("Stack:", stack, " | Input:", element)

        # Case 1: Terminal match
        if top == element:
            i += 1

        # Case 2: Epsilon → do nothing
        elif top == 'e':
            continue

        # Case 3: Terminal mismatch
        elif top in terminals:
            print("Rejected")
            break

        # Case 4: Non-terminal expansion
        else:
            production = ll1_table.get((top, element))

            if not production:
                print("Rejected")
                break

            # Do NOT push epsilon
            if production != 'e':
                rhs = production.split(" ")
                for symbol in reversed(rhs):
                    stack.append(symbol)

    else:
        if not stack:
            print("\nAccepted")
        else:
            print("\nRejected")

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
    parse_string(ll1_table, terminals)

if __name__ == "__main__":
    main()