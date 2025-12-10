import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;
import std.traits;

long best(string bank, int n, long cur)
{
    if(n == 0) return cur;
    auto digit = bank[0 .. $-(n-1)].enumerate.maxElement!(v => v[1]);
    return best(bank[digit[0]+1 .. $], n-1, cur * 10 + digit[1] - '0');
}
void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;

    long joltsp1 = 0;
    long joltsp2 = 0;
    foreach(bank; input) {
        joltsp1 += best(bank, 2, 0);
        joltsp2 += best(bank, 12, 0);
    }
    writeln(i"part1: $(joltsp1)");
    writeln(i"part2: $(joltsp2)");
}
