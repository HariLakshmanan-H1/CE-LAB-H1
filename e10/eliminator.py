import sys

def normalize(expr):
    expr = expr.strip()
    if '+' in expr and all(op not in expr for op in '-/'):
        return '+'.join(sorted(t.strip() for t in expr.split('+')))
    if '*' in expr and all(op not in expr for op in '+-/'):
        return '*'.join(sorted(f.strip() for f in expr.split('*')))
    return expr

def simplify(expr):
    expr = expr.strip()

    # a * 1 = a
    if '*' in expr:
        parts = [p.strip() for p in expr.split('*') if p.strip() != '1']
        expr = ' * '.join(parts) if len(parts) > 1 else (parts[0] if parts else '1')

    # x + 0 = x
    if '+' in expr:
        parts = [p.strip() for p in expr.split('+') if p.strip() != '0']
        expr = ' + '.join(parts) if len(parts) > 1 else (parts[0] if parts else '0')

    # x - 0 = x
    if expr.endswith('- 0'):
        expr = expr[:-3].strip()

    return expr

def optimize(instr):
    table, out = {}, []
    for line in instr:
        if '=' not in line: 
            continue

        var, expr = map(str.strip, line.split('=', 1))
        expr_s = simplify(expr)
        expr_n = normalize(expr_s)

        if expr_n in table and table[expr_n] != var:
            out.append(f"{var} = {table[expr_n]}")
        else:
            table[expr_n] = var
            out.append(f"{var} = {expr_s}")

    return out

def read_file(fname):
    try:
        with open(fname) as f:
            return [l.strip() for l in f if l.strip() and not l.startswith('#')]
    except Exception as e:
        print(f"Error: {e}")
        return []

# ---- main ----
if len(sys.argv) < 2:
    print("Usage: python script.py <file>")
    sys.exit(1)

instr = read_file(sys.argv[1])
opt = optimize(instr)

print("\nOriginal:")
print("\n".join(instr))

print("\nOptimized:")
print("\n".join(opt))