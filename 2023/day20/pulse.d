import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;
import std.math;
import std.traits;

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    long highPulses = 0;
    long lowPulses = 0;
    struct node
    {
        string name;
        string[] outputs; // which nodes will receive this pulse
        bool type;
        int state;
        int mask;
        int[string] bits;

        int receive(string from, bool pulse)
        {
            if(type)
            {
                if(!pulse)
                {
                    state = !state;
                    return state;
                }
                return -1;
            }
            else
            {
                if(pulse)
                    state |= bits[from];
                else
                    state &= ~bits[from];
                return state != mask;
            }
        }
    }

    node[string] framework;
    string[] buttonNodes;

    foreach(i; input)
    {
        auto a = i.split(" -> ");
        auto target = a[1].split(", ");
        if(a[0] == "broadcaster")
        {
            buttonNodes = target;
        }
        else
        {
            node n;
            n.name = a[0][1 .. $];
            n.type = a[0][0] == '%';
            n.outputs = target;
            framework[n.name] = n;
        }
    }

    // determine how many inputs each conjunction module has
    foreach(ref n; framework)
    {
        if(!n.type)
        {
            foreach(x; framework)
            {
                if(x.outputs.canFind(n.name))
                {
                    int m = 1 << cast(int)n.bits.length;
                    n.bits[x.name] = m;
                }
            }
            foreach(x; buttonNodes)
                if(x == n.name)
                {
                    int m = 1 << cast(int)n.bits.length;
                    n.bits["broadcaster"] = m;
                }
            n.mask = (1 << n.bits.length) - 1;
        }
    }

    long[4] cycles = -1; // no cycle detected yet
    int cnt = 0;
    // note, change these to your cycle nodes according to your puzzle input. I haven't made the code
    // detect these.
    string[4] cyclenodes = ["bh", "dl", "vd", "ns"];
    void pulse()
    {
        ++cnt;
        static struct P
        {
            string from;
            string to;
            bool pulse;
        }
        P[] q;
        ++lowPulses; // button pulse
        //writeln("button -low-> broadcaster");
        foreach(s; buttonNodes)
        {
            // broadcast pulse
            q ~= P("broadcaster", s, false);
        }
        while(q.length > 0)
        {
            auto p = q.front;
            q.popFront;
            if(p.pulse) ++highPulses;
            else ++lowPulses;
            if(p.to == "zh" && p.pulse)
            {
                auto idx = cyclenodes[].countUntil(p.from);
                if(cycles[idx] == -1)
                    cycles[idx] = cnt;
                //writefln("%s: %s -%s-> %s", cnt, p.from, p.pulse ? "high" : "low", p.to);
            }
            if(auto n = p.to in framework)
            {
                auto val = n.receive(p.from, p.pulse);
                if(val != -1)
                    foreach(dname; n.outputs)
                        q ~= P(n.name, dname, val > 0);
            }
        }
    }
    long part2 = 0;
    foreach(i; 0 .. 1000)
    {
        pulse();
    }

    writeln(lowPulses * highPulses);
    bool done()
    {
        return !canFind(cycles[], -1);
    }
    while(!done)
    {
        pulse();
    }
    import std.numeric : lcm;
    writeln(cycles[].fold!((a, b) => lcm(a, b)));
}
