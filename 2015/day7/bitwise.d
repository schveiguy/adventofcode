import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;


void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    ushort[string] values;
    struct Inst {
        enum Type
        {
            AND,
            LSHIFT,
            NOT,
            OR,
            RSHIFT,
            VAL
        }
        Type type;
        string w1, w2;
        bool ready()
        {
            return (w1[0].isDigit() || (w1 in values)) && (w2.length == 0 || w2[0].isDigit() || (w2 in values));
        }
        ushort value()
        {
            ushort a = values.get(w1, w1.to!ushort);
            ushort b = w2.length > 0 ? values.get(w2, w2.to!ushort) : 0;
            with(Type) final switch(type)
            {
                case AND:
                    return a & b;
                case LSHIFT:
                    return cast(ushort)(a << b);
                case NOT:
                    return cast(ushort)~a;
                case OR:
                    return a | b;
                case RSHIFT:
                    return a >> b;
                case VAL:
                    return a;
            }
        }
    }
    Inst[string] instructions;
    foreach(i; input)
    {
        auto data = i.split(" -> ");
        auto ops = data[0].split;
        if(ops.length == 1)
        {
            instructions[data[1]] = Inst(Inst.Type.VAL, ops[0]);
        }
        else if(ops.length == 2)
        {
            assert(ops[0] == "NOT");
            instructions[data[1]] = Inst(Inst.Type.NOT, ops[1]);
        }
        else
        {
            instructions[data[1]] = Inst(ops[1].to!(Inst.Type), ops[0], ops[2]);
        }
    }
    ushort getSignal(string wire)
    {
        bool changed = true;
        while(changed && !(wire in values))
        {
            changed = false;
            foreach(name, inst; instructions)
            {
                if(name in values)
                    continue;
                if(inst.ready)
                {
                    values[name] = inst.value;
                    changed = true;
                }
            }
        }
        return values[wire];
    }
    writeln(getSignal("a"));
    values = ["b": values["a"]];
    writeln(getSignal("a"));
}
