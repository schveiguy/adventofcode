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
    struct Inst
    {
        char member; // 0 => no comparison
        bool lt;
        int val;
        string target; // A => accept, R => reject, else go to another workflow
        string check(int[4] vals)
        {
            if(member == '\0')
                return target; // always applies
            else if(member == 'A')
                return null; // go no further
            int inputval = vals["xmas".indexOf(member)];
            return (lt ? inputval < val : inputval > val) ? target : null;
        }
    }

    Inst[][string] workflows;

    int[4][] items;

    foreach(i; input)
    {
        if(i[0] == '{')
        {
            int[4] vals;
            i.formattedRead("{x=%s,m=%s,a=%s,s=%s}", vals[0], vals[1], vals[2], vals[3]);
            items ~= vals;
        }
        else
        {
            auto parts = i.splitter!(c => c == '{' || c == '}' || c == ',').filter!(s => s.length > 0).array;
            Inst[] things;
            foreach(p; parts[1 .. $])
            {
                Inst x;

                x.member = p[0];
                if(x.member == 'A' || x.member == 'R')
                {
                    x.member = '\0';
                    x.target = p;
                }
                else
                {
                    if(p[1] == '<' || p[1] == '>')
                    {
                        x.lt = p[1] == '<';
                        p[2 .. $].formattedRead("%d:%s", x.val, x.target);
                    }
                    else
                    {
                        // sending to a new workflow
                        x.member = '\0';
                        x.target = p;
                    }
                }
                things ~= x;
            }
            workflows[parts[0]] = things;
        }
    }

    int part1()
    {
        int accepted = 0;
        foreach(vals; items)
        {
            Inst[] cur = workflows["in"];
            while(true)
            {
                auto result = cur.front.check(vals);
                if(result.length == 0)
                    cur.popFront;
                else if(result == "A")
                {
                    accepted += vals[].sum;
                    break;
                }
                else if(result == "R")
                {
                    break;
                }
                else
                {
                    // new workflow
                    cur = workflows[result];
                }
            }
        }
        return accepted;
    }
    writeln(part1());

    // sentinels for part 2
    workflows["A"] = [Inst('A')];
    workflows["R"] = [];

    long part2()
    {
        int[2][4] vals = [
            [1, 4001],
            [1, 4001],
            [1, 4001],
            [1, 4001]
        ];
        static long calc(ref int[2][4] vals)
        {
            long total = 1;
            foreach(i; 0 .. 4)
                total *= vals[i][1] - vals[i][0];
            return total;
        }
        long recurse(Inst[] ilist, int[2][4] vals)
        {
            long total = 0;
            foreach(cur; ilist)
            {
                if(cur.member == 'A')
                {
                    total += calc(vals);
                    break;
                }
                if(cur.member == 'R')
                {
                    break;
                }
                if(cur.member == '\0')
                {
                    total += recurse(workflows[cur.target], vals);
                    break;
                }
                auto m = "xmas".indexOf(cur.member);
                if(cur.lt)
                {
                    auto orig = vals[m][1];
                    if(vals[m][0] < cur.val)
                    {
                        // select this one
                        vals[m][1] = min(cur.val, orig);
                        total += recurse(workflows[cur.target], vals);
                        if(vals[m][1] == orig)
                            // prune
                            break;
                        vals[m][0] = vals[m][1];
                        vals[m][1] = orig;
                    }
                }
                else
                {
                    auto orig = vals[m][0];
                    if(vals[m][1] > cur.val + 1)
                    {
                        // select this one
                        vals[m][0] = max(cur.val + 1, orig);
                        total += recurse(workflows[cur.target], vals);
                        if(vals[m][0] == orig)
                            // prune
                            break;
                        vals[m][1] = vals[m][0];
                        vals[m][0] = orig;
                    }
                }
            }
            return total;
        }
        return recurse(workflows["in"], vals);
    }

    writeln(part2());
}
