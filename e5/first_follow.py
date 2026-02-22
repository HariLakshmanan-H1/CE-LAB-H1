from collections import OrderedDict
import json

# ------------------------ Grammar Reading ------------------------
def read_grammar_from_file(filename):
    """Read grammar from a file and return productions as an OrderedDict."""
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

# ------------------------ FIRST Computation ------------------------
def compute_first(productions, terminals, nonterminals):
    """Compute FIRST sets for all grammar symbols."""
    first = OrderedDict()

    # Terminals: FIRST(terminal) = {terminal}
    for terminal in terminals:
        first[terminal] = [terminal]

    # Nonterminals: initialize empty
    for nt in nonterminals:
        first[nt] = []

    # Iterative computation
    while True:
        changed = False
        for lhs in nonterminals:
            current_first = set(first[lhs])
            for production in productions[lhs]:
                symbols = production.split()
                first_symbol = symbols[0]
                # Add FIRST of the first symbol
                current_first.update(first[first_symbol])
            if current_first != set(first[lhs]):
                first[lhs] = list(current_first)
                changed = True
        if not changed:
            break

    # Remove nonterminals from FIRST sets (keep only terminals)
    for lhs in nonterminals:
        first[lhs] = [sym for sym in first[lhs] if sym not in nonterminals]

    return first

# ------------------------ FOLLOW Computation ------------------------
def compute_follow(productions, first, nonterminals, start_symbol):
    """Compute FOLLOW sets for all nonterminals."""
    follow = OrderedDict()
    for nt in nonterminals:
        follow[nt] = []
    follow[start_symbol].append('$')  # Start symbol

    while True:
        changed = False
        for lhs in nonterminals:
            for prod_lhs in nonterminals:
                for production in productions[prod_lhs]:
                    symbols = production.split()
                    for i, symbol in enumerate(symbols):
                        if symbol not in nonterminals:
                            continue
                        current_follow = set(follow[symbol])

                        # Case 1: symbol followed by another symbol
                        if i + 1 < len(symbols):
                            next_symbol = symbols[i + 1]
                            next_first = set(first[next_symbol])
                            if 'e' in next_first:  # Epsilon can vanish
                                next_first.remove('e')
                                # Check if rest can vanish
                                rest_can_vanish = True
                                for s in symbols[i + 2:]:
                                    if 'e' not in first[s]:
                                        rest_can_vanish = False
                                        break
                                if rest_can_vanish:
                                    next_first.update(follow[prod_lhs])
                            current_follow.update(next_first)

                        # Case 2: symbol at the end → add FOLLOW of LHS
                        else:
                            current_follow.update(follow[prod_lhs])

                        if current_follow != set(follow[symbol]):
                            follow[symbol] = list(current_follow)
                            changed = True
        if not changed:
            break

    # Cleanup: remove any nonterminals from FOLLOW sets
    for nt in nonterminals:
        follow[nt] = [sym for sym in follow[nt] if sym not in nonterminals]

    return follow

# ------------------------ Main ------------------------
def main():
    # Terminals and concise nonterminals
    terminals = ["+", "-", "e", "*", "/", "(", ")", "num", "name"]
    nonterminals = ["E", "E'", "T", "T'", "F"]

    # Read grammar
    productions = read_grammar_from_file("grammar.txt")
    print("Productions:")
    print(json.dumps(productions, indent=4))

    # Compute FIRST sets
    first = compute_first(productions, terminals, nonterminals)
    print("\nFIRST sets:")
    for nt in nonterminals:
        print(f"{nt}: {first[nt]}")

    # Compute FOLLOW sets
    follow = compute_follow(productions, first, nonterminals, start_symbol=nonterminals[0])
    print("\nFOLLOW sets:")
    for nt in nonterminals:
        print(f"{nt}: {follow[nt]}")

if __name__ == "__main__":
    main()