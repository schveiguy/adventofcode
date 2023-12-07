import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;
import std.range;
import std.array;
import std.container.rbtree;
import std.math;

void main(string[] args)
{
    static struct Node {
        bool list;
        Node[] children;
        int value;
        int opCmp(Node right)
        {
            if(list != right.list)
            {
                if(list)
                    return this.opCmp(Node(true, [right]));
                else
                    return Node(true, [this]).opCmp(right);
            }
            else if(list)
            {
                auto ch1 = children;
                auto ch2 = right.children;
                while(!ch1.empty && !ch2.empty)
                {
                    auto c = ch1.front.opCmp(ch2.front);
                    if(c == 0)
                    {
                        ch1.popFront;
                        ch2.popFront;
                    }
                    else
                        return c;
                }
                if(ch1.empty && ch2.empty)
                    return 0;
                return ch1.empty ? -1 : 1;
            }
            else
            {
                if(value == right.value)
                    return 0;
                return value < right.value ? -1 : 1;
            }
        }
    }
    Node parseRec(ref string x)
    {
        Node result;
        if(x.front == '[')
        {
            result.list = true;
            x.popFront;
            while(x.front != ']')
            {
                if(x.front == ',')
                    x.popFront;
                else
                    result.children ~= parseRec(x);
            }
            x.popFront; // ']'
            return result;
        }
        else
        {
            result.value = .parse!int(x);
            return result;
        }
    }
    Node parse(string x)
    {
        return parseRec(x);
    }

    auto input = readText(args[1]).strip.splitter.map!(t => parse(t)).array;
    int p1;
    foreach(i; 0 .. input.length / 2)
    {
        if(input[i*2] < input[i*2+1])
            p1 += i+1;
    }

    writeln("part1: ", p1);

    auto div1 = parse("[[2]]");
    auto div2 = parse("[[6]]");
    input ~= div1;
    input ~= div2;
    input.sort;
    int p2 = 1;
    foreach(i, ref p; input)
    {
        if(p == div1 || p == div2)
        {
            p2 *= i+1;
        }
    }
    writeln("part2: ", p2);
}
