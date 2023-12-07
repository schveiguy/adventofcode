import std.stdio;
import std.file : readText;
import std.algorithm;
import std.string;
import std.conv;
import std.range;
import std.array : array;

void main(string[] args)
{
    static immutable open = "([{<";
    static immutable close = ")]}>";
    static immutable points = [3, 57, 1197, 25137];

    auto input = readText(args[1]).strip.split;
    int pt1;
    long[] pt2;
mainloop:
    foreach(ln; input)
    {
        char[] stack;
        foreach(c; ln)
        {
            if(open.indexOf(c) != -1)
                stack ~= c;
            else {
                auto idx = close.indexOf(c);
                if(open[idx] != stack[$-1])
                {
                    pt1 += points[idx];
                    continue mainloop;
                }
                stack.popBack;
            }
        }
        if(stack.length)
        {
            long score = 0;
            foreach_reverse(c; stack)
            {
                score = score * 5 + 1 + open.indexOf(c);
            }
            pt2 ~= score;
        }
    }
    writeln("part1: ", pt1);
    pt2.sort;
    writeln("part2: ", pt2[$/2]);
}
