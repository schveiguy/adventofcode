import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;
import std.range;
import std.array;
import std.math;

struct monkey
{
    string name;
    long val;
    bool set;
    bool ldep;
    bool rdep;
    string lhs;
    string rhs;
    string op;
    long calc()
    {
        if(!set) final switch(op)
        {
        case "*":
            val = monkeys[lhs].calc * monkeys[rhs].calc;
            break;
        case "/":
            val = monkeys[lhs].calc / monkeys[rhs].calc;
            break;
        case "+":
            val = monkeys[lhs].calc + monkeys[rhs].calc;
            break;
        case "-":
            val = monkeys[lhs].calc - monkeys[rhs].calc;
            break;
        }
        return val;
    }

    void reset()
    {
        if(lhs.length != 0)
        {
            set = false;
        }
        else if(name == "humn")
        {
            ldep = true;
        }
    }

    bool search()
    {
        if(!set)
        {
            ldep = monkeys[lhs].search;
            rdep = monkeys[rhs].search;
            if(ldep && rdep)
                throw new Exception("error! both " ~ lhs ~ rhs);
            set = true;
        }
        return ldep || rdep;
    }

    void calc2(long v = 0)
    {
        if(name == "humn")
        {
            val = v;
            return;
        }

        if(name == "root")
        {
            if(ldep)
                monkeys[lhs].calc2(monkeys[rhs].calc);
            else
                monkeys[rhs].calc2(monkeys[lhs].calc);
        }
        else
        {
            // it's a math operation, need to inverse the operation and push down
            if(ldep)
            {
                auto rval = monkeys[rhs].calc;
                final switch(op)
                {
                case "*":
                    // lhs * rhs = v
                    // lhs = v / rhs
                    monkeys[lhs].calc2(v / rval);
                    break;
                case "+":
                    // lhs + rhs = v
                    // lhs = v - rhs
                    monkeys[lhs].calc2(v - rval);
                    break;
                case "-":
                    // lhs - rhs = v
                    // lhs = v + rhs
                    monkeys[lhs].calc2(rval + v);
                    break;
                case "/":
                    // lhs / rhs = v
                    // lhs = v * rhs
                    monkeys[lhs].calc2(rval * v);
                    break;
                }
            }
            else
            {
                auto lval = monkeys[lhs].calc;
                final switch(op)
                {
                case "*":
                    // lhs * rhs = v
                    // rhs = v / lhs
                    monkeys[rhs].calc2(v / lval);
                    break;
                case "+":
                    // lhs + rhs = v
                    // rhs = v - lhs
                    monkeys[rhs].calc2(v - lval);
                    break;
                case "-":
                    // lhs - rhs = v
                    // lhs - v = rhs
                    monkeys[rhs].calc2(lval - v);
                    break;
                case "/":
                    // lhs / rhs = v
                    // lhs / v = rhs
                    monkeys[rhs].calc2(lval / v);
                    break;
                }
            }
        }
    }
}

monkey[string] monkeys;

void main(string[] args)
{
    auto input = readText(args[1]).strip.split('\n');
    foreach(ln; input)
    {
        auto parts = ln.split(':');
        try {
            auto v = parts[1].strip.to!long;
            monkeys[parts[0]] = monkey(parts[0], v, true);
        } catch(Exception) {
            // not an integer
            auto result = monkey(parts[0]);
            parts[1].formattedRead(" %s %s %s", &result.lhs, &result.op, &result.rhs);
            monkeys[result.name] = result;
        }
    }
    writeln("part1: ", monkeys["root"].calc);

    monkeys["root"].op = "=";
    foreach(ref m; monkeys)
        m.reset();

    monkeys["root"].search;

    monkeys["root"].calc2;
    writeln("part2: ", monkeys["humn"].val);
}
