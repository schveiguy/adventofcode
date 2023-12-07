import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;
import std.range;
import std.array;


struct Item {
    long orig;
    long[] worries;
}

struct Monkyyy {
    Item[] items;
    int divisibleby;
    char op;
    string operand;
    long inspections;
    int trueMonkyyy;
    int falseMonkyyy;
}

void main(string[] args)
{
    if(args.length < 3) {
        writeln("usage: monkyyy inputfile whichpart");
        writeln("whichpart = part1 or part2");
        return;
    }
    auto input = readText(args[1]).strip.split('\n');
    bool part1 = args[2] == "part1";
    Monkyyy[] monkyyys;
    foreach(ln; input)
    {
        auto inst = ln.strip.split(':');
        if(inst.length == 0)
            continue;
        if(inst[0].startsWith("Monkey"))
        {
            monkyyys.length += 1;
        }
        else
        {
            auto m = &monkyyys[$-1];
            final switch(inst[0])
            {
            case "Starting items":
                m.items = inst[1].split(',').map!(v => Item(v.strip.to!long)).array;
                break;
            case "Operation":
                inst[1].strip.formattedRead("new = old %c %s", &m.op, &m.operand);
                break;
            case "Test":
                inst[1].strip.formattedRead("divisible by %s", &m.divisibleby);
                break;
            case "If true":
                inst[1].strip.formattedRead("throw to monkey %s", &m.trueMonkyyy);
                break;
            case "If false":
                inst[1].strip.formattedRead("throw to monkey %s", &m.falseMonkyyy);
                break;
            }
        }
    }

    // populate the worries
    foreach(ref m; monkyyys)
    {
        foreach(ref it; m.items)
        {
            it.worries.length = monkyyys.length;
            it.worries[] = it.orig;
        }
    }

    // run the simulation 20 rounds for part1, 10000 rounds for part 2
    auto rounds = part1 ? 20 : 10000;
    foreach(i; 0 .. rounds)
    {
        foreach(midx, ref m; monkyyys)
        {
            foreach(ref it; m.items)
            {
                if(part1)
                {
                    // run the algorithm on just the original value, use the divide by 3 rule.
                    long operand = m.operand == "old" ? it.orig : m.operand.to!long;
                    it.orig = (m.op == '*' ? it.orig * operand : it.orig + operand) / 3;
                    monkyyys[it.orig % m.divisibleby == 0 ? m.trueMonkyyy : m.falseMonkyyy].items ~= it;
                }
                else
                {
                    // no divide by 3 rule, must keep truncating according to the divisibleby of the given monkyyy.
                    foreach(j, ref w; it.worries)
                    {
                        long operand = m.operand == "old" ? w : m.operand.to!long;
                        w = (m.op == '*' ? w * operand : w + operand) % monkyyys[j].divisibleby;
                    }
                    monkyyys[it.worries[midx] == 0 ? m.trueMonkyyy : m.falseMonkyyy].items ~= it;
                }
            }
            m.inspections += m.items.length;
            m.items = null;
        }
        /*if([1, 20, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000].canFind(i+1))
        {
            writeln(monkyyys.map!(m => m.inspections));
        }*/
    }

    monkyyys.sort!((m1, m2) => m1.inspections > m2.inspections);
    writefln("%s: %s", part1 ? "part1" : "part2", monkyyys[0].inspections * monkyyys[1].inspections);
}
