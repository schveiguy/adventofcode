import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;

struct Range
{
    long dest;
    long src;
    long srcmax;
    long offset() => dest - src;
}

struct Value
{
    long src;
    long srcmax;
    long length() => srcmax - src;
    Value *next;
    string toString() => format("(%s ~ %s)", src, srcmax);
    Value* translate(Range r)
    {
        long a = max(src, r.src);
        long b = max(min(srcmax, r.srcmax), a);
        //writefln("here, %s %s %s %s %s %s", r.src, r.srcmax, src, srcmax, a, b);
        if(a > src && b < srcmax)
        {
            //write("splitting ", this);
            // splitting in 2
            auto nv = new Value(b, srcmax);
            nv.next = next;
            next = nv;
            srcmax = a;
            //writeln(" into ", this, " and ", *nv);
        }
        else if(a != b)
        {
            // consume some of the original value
            if(a == src)
                src = b;
            else
                srcmax = a;
        }
        // return the new value
        return new Value(a + r.offset, b + r.offset);
    }
}

struct valueRange
{
    Value *cur;
    bool processZeros = false;
    this(Value *v, bool processZeros = false)
    {
        cur = v;
        this.processZeros = processZeros;
        if(!processZeros && cur.length == 0)
            popFront;
    }

    void popFront()
    {
        cur = cur.next;
        if(!processZeros)
            while(cur && cur.length == 0)
                cur = cur.next;
    }

    ref Value front() => *cur;
    bool empty() => cur is null;
}

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;

    long[] seeds = input[0].find(' ').split.map!(to!long).array;

    Range[] ranges;
    auto part1 = seeds.dup;
    Value *part2 = new Value(seeds[0], seeds[0] + seeds[1]);
    Value *curp2 = part2;
    for(int i = 2; i < seeds.length; i += 2)
    {
        curp2 = curp2.next = new Value(seeds[i], seeds[i] + seeds[i + 1]);
    }

    void processRanges()
    {
        //writeln(part1);
        // process the values
        foreach(ref v; part1)
        {
            foreach(r; ranges)
            {
                if(v >= r.src && v < r.srcmax)
                {
                    //write("converting ", v);
                    v += r.offset;
                    //writeln(" to ", v);
                    break;
                }
            }
        }

        // part 2
        Value *newp2 = null;
        curp2 = null;
        //writeln(valueRange(part2, true));
        foreach(ref v; valueRange(part2))
        {
            foreach(r; ranges)
            {
                auto nv = v.translate(r);
                if(curp2)
                {
                    curp2 = curp2.next = nv;
                }
                else
                {
                    curp2 = newp2 = nv;
                }
            }
        }
        foreach(ref v; valueRange(part2))// handle all the remaining values
        {
            auto nv = new Value(v.src, v.srcmax);
            if(curp2)
            {
                curp2 = curp2.next = nv;
            }
            else
            {
                curp2 = newp2 = nv;
            }
        }
        part2 = newp2;
        ranges = null;
    }

    // process the input
    foreach(l; input[1 .. $])
    {
        if(isDigit(l[0]))
        {
            // range values
            long[] vals = l.splitter.map!(to!long).array;
            ranges ~= Range(vals[0], vals[1], vals[1] + vals[2]);
        }
        else
        {
            processRanges();
        }
    }
    processRanges();
    //writeln(part1);

    writeln(minElement(part1));
    writeln(minElement(valueRange(part2).map!(v => v.src)));
}
