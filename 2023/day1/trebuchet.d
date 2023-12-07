import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.ascii : isDigit;
import std.utf : byChar;
import std.array : array;

int part2a(string[] input)
{
    string[string] substitutions = [
        "one" : "1",
        "two" : "2",
        "three" : "3",
        "four" : "4",
        "five" : "5",
        "six" : "6",
        "seven" : "7",
        "eight" : "8",
        "nine" : "9",
    ];
    string doReplacing(string s)
    {
        auto orig = s;
outer:
        foreach(idx; 0 .. s.length)
        {
            foreach(k, v; substitutions)
            {
                if(s[idx].isDigit)
                    break outer;
                if(s[idx .. $].startsWith(k))
                {
                    s = s[0 .. idx] ~ v ~ s[idx + k.length .. $];
                    break outer;
                }
            }
        }
outer2:
        foreach_reverse(idx; 0 .. s.length)
        {
            foreach(k, v; substitutions)
            {
                if(s[idx].isDigit)
                    break outer2;
                if(s[idx .. $].startsWith(k))
                {
                    s = s[0 .. idx] ~ v ~ s[idx + k.length .. $];
                    break outer2;
                }
            }
        }
        //writefln("orig: %s, new: %s", orig, s);
        return s;
    }
    return input
        .map!(s => doReplacing(s))
        .map!((s) {
                auto f = s.byChar.filter!(c => c.isDigit).array;
                return only(f.front, f.back).to!int;
        })
        .sum;
}

int part2b(string[] input)
{
    string[] digits = [
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine"
    ];
    int sum = 0;
    foreach(line; input)
    {
        int frontDigit, backDigit;
        foreach(i; 0 .. line.length)
        {
            if(isDigit(line[i]))
            {
                frontDigit = line[i] - '0';
                break;
            }
            auto d = digits.countUntil!(x => line[i .. $].startsWith(x));
            if(d >= 0)
            {
                frontDigit = cast(int)(d + 1);
                break;
            }
        }

        foreach_reverse(i; 0 .. line.length)
        {
            if(isDigit(line[i]))
            {
                backDigit = line[i] - '0';
                break;
            }
            auto d = digits.countUntil!(x => line[i .. $].startsWith(x));
            if(d >= 0)
            {
                backDigit = cast(int)(d + 1);
                break;
            }
        }
        sum += frontDigit * 10 + backDigit;
    }
    return sum;
}

void main(string[] args)
{
    auto input = readText(args[1]).split;
    auto answer1 = input
        .map!((s) {
                auto f = s.byChar.filter!(c => c.isDigit).array;
                if(f.empty) return 0;
                return only(f.front, f.back).to!int;
        })
        .sum;
    writeln(answer1);

    writeln(part2a(input));
    writeln(part2b(input));
}
