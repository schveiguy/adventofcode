import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;

void main(string[] args)
{
    auto input = readText(args[1]).split('\n');
    enum color
    {
        red,
        green,
        blue
    }

    int sum;
    int powersum;
    foreach(line; input)
    {
        line = line.strip;
        if(line.length == 0)
            continue;
        int id;
        formattedRead(line, "Game %s:", id);
        int[3] maxcubes;
        foreach(pick; line.splitter(';'))
        {
            foreach(cb; pick.splitter(','))
            {
                cb = cb.strip;
                int n;
                color c;
                formattedRead(cb, "%s %s", n, c);
                maxcubes[c] = max(maxcubes[c], n);
            }
        }
        if(maxcubes[color.red] <= 12 && maxcubes[color.green] <= 13 && maxcubes[color.blue] <= 14)
        {
            sum += id;
        }
        powersum += maxcubes[].fold!((a, b) => a * b)(1);
    }
    writeln(sum);
    writeln(powersum);
}
