import std.stdio;
import std.file : readText;
import std.algorithm;
import std.string;
import std.conv;
import std.range;
import std.array : array;
import std.format;
import std.ascii : isDigit;
import std.utf;

string[] reduce(string[] input)
{
retry:
    //writefln("working on %-(%s %)", input);
    size_t splitme = 0;
    // find an exploding number
    int nesting = 0;
    size_t prevnum = 0;
    foreach(i, v; input)
    {
        if(v[0] == '[')
        {
            if(++nesting == 5)
            {
                //writeln("exploding at item ", i);
                // find the previous number
                string[] newinput;
                if(input[prevnum][0].isDigit)
                {
                    newinput = input[0 .. prevnum];
                    newinput ~= (input[prevnum].to!int + input[i+1].to!int).to!string;
                    newinput ~= input[prevnum + 1 .. i];
                }
                else
                    newinput = input[0 .. i]; 
                newinput ~= "0";
                // find the next regular number
                int addme = input[i + 3].to!int;
                foreach(x; input[i + 5 .. $])
                {
                    if(addme && x[0].isDigit)
                    {
                        newinput ~= (x.to!int + addme).to!string;
                        addme = 0;
                    }
                    else
                        newinput ~= x;
                }
                input = newinput;
                goto retry;
            }
        }
        else if(v[0] == ']')
        {
            --nesting;
        }
        else if(v[0].isDigit)
        {
            prevnum = i;
            if(v.length > 1 && !splitme)
                splitme = i;
        }
    }

    // explosions done, try splitting
    if(splitme != 0)
    {
        //writeln("splitting at item ", splitme);
        auto num = input[splitme].to!int;
        input = input[0 .. splitme] ~ ["[", (num/2).to!string, ",", ((num+1)/2).to!string, "]"] ~ input[splitme + 1 .. $];
        goto retry;
    }

    return input;
}

long magnitude(string[] input) 
{
    size_t idx;
    long recurse()
    {
        if(input[idx][0].isDigit)
        {
            return input[idx++].to!long;
        }
        else
        {
            // recurse
            auto origidx = idx;
            ++idx; // [
            auto leftside = recurse();
            ++idx; // ,
            auto rightside = recurse();
            ++idx; // ]
            return leftside * 3 + rightside*2;
        }
    }
    return recurse();
}

void main(string[] args)
{
    auto input = readText(args[1]).strip.split;
    string[] cur;
    static string[] parse(string ln)
    {
        return ln.byChar.map!((ref c) => (&c)[0 .. 1]).array;
    }
    foreach(ln; input)
    {
        string[] parsed = parse(ln);
        if(cur.length)
            cur = reduce("[" ~ cur ~ "," ~ parsed ~ "]");
        else
            cur = reduce(parsed);
    }
    //writeln("reduced: ", cur.joiner);
    writeln("part1: ", magnitude(cur));

    // part 2
    long largest = 0;
    foreach(n1; input)
    {
        foreach(n2; input)
        {
            if(n1 == n2) continue;
            auto added = parse(format("[%s,%s]", n1, n2));
            auto mag = magnitude(reduce(added));
            largest = max(largest, mag);
        }
    }
    writeln("part2: ", largest);
}
