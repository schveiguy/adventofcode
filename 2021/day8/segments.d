import std.stdio;
import std.file : readText;
import std.algorithm;
import std.string;
import std.conv;
import std.range;

int[const(char)[]] solve(char[][] digits)
{
    digits.sort!((a, b) => a.length < b.length);
    const(char)[] one = digits[0];
    const(char)[] seven = digits[1];
    const(char)[] four = digits[2];
    const(char)[] eight = digits[$-1];
    int[const(char)[]] result;
    result[one] = 1;
    result[seven] = 7;
    result[four] = 4;
    result[eight] = 8;

    char c;
    char f;
    const(char)[] six;
    const(char[])[] nine;

    // 6 is the only digit with 6 segments that only contains one of the segments from 1
    foreach(d; digits)
        if(d.length == 6)
        {
           if(!d.canFind(one[0]))
           {
               six = d;
               c = one[0];
               f = one[1];
           }
           else if(!d.canFind(one[1]))
           {
               six = d;
               c = one[1];
               f = one[0];
           }
           else
               // possibly the nine
               nine ~= d;
        }

    result[six] = 6;

    const(char)[] two;
    const(char)[] three;
    const(char)[] five;
    // two is the only 5 segment
    foreach(d; digits)
    {
        if(d.length == 5)
        {
            if(!d.canFind(f))
                two = d;
            else if(!d.canFind(c))
                five = d;
            else
                three = d;
        }
    }

    result[two] = 2;
    result[three] = 3;
    result[five] = 5;

    // the only difference between 2 and 3 is the e/f segment
    foreach(e; two)
    {
        if(!three.canFind(e))
        {
            // this is the 'e' segment. This will be in the zero, but not the nine
            int nineidx = nine[0].canFind(e);
            result[nine[nineidx]] = 9;
            result[nine[!nineidx]] = 0;
            break;
        }
    }
    return result;
}

void main(string[] args)
{
    auto input = cast(char[])readText(args[1]).strip;
    int p1 = 0;
    int p2;
    foreach(ln; input.splitter('\n'))
    {
        auto parts = ln.findSplit("|");
        auto digits = parts[0].strip.split;
        auto outputs = parts[2].strip.split;
        foreach(ref d; digits)
            d.representation.sort;
        foreach(ref o; outputs)
            o.representation.sort;
        auto mapping = solve(digits);
        int p2val = 0;
        foreach(v; outputs)
        {
            if([2, 4, 3, 7].canFind(v.length)) ++p1;
            p2val = p2val * 10 + mapping[v];
        }
        p2 += p2val;
    }
    writeln("part1: ", p1);
    writeln("part2: ", p2);
}
