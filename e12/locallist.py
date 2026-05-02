def schedule(nodes, delay, pred, succ):
    cycle = 1
    ready = [n for n in nodes if not pred[n]]
    active, start, done = [], {}, set()
    print(f"{'Cycle':<15} | {'Ready':<15} | {'Active':<15} | {'Action':<15}")
    while ready or active:
        action = ""
        if ready:
            ready.sort()
            op = ready.pop(0)
            start[op] = cycle
            active.append((op, cycle))
            action = f"start {op}"
        print(f"{cycle:<15} | {str(ready):<15} | {str([a[0] for a in active]):<15} | {action:<15}")
        cycle += 1
        new_active = []
        for op, s in active:
            if s + delay[op] <= cycle:
                done.add(op)
                for c in succ.get(op, []):
                    if all(p in done for p in pred[c]) and c not in ready and c not in [a[0] for a in active] and c not in done:
                        ready.append(c)
            else:
                new_active.append((op, s))
        active = new_active
    print(f"{cycle:<15} | {str(ready):<15} | {str([a[0] for a in active]):<15} |")
    print("Total cycles:", cycle - 1)
    return start

nodes = ['A','B','C','D','E','F','G']
delay = {'A':3,'B':3,'C':3,'D':2,'E':2,'F':1,'G':3}
succ = {'A':['D'],'B':['D'],'C':['E'],'D':['E','F'],'E':['F'],'F':['G'],'G':[]}
pred = {'A':[],'B':[],'C':[],'D':['A','B'],'E':['C','D'],'F':['E','D'],'G':['F']}
final = schedule(nodes, delay, pred, succ)
print(final)