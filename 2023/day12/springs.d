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

struct State
{
    char nextslot;
    size_t left;
    int run;
    int choices;
    size_t matches;
}

alias Memo = long[State];

// The state of the machine is:
// 1. The remaining data to process (the input string of ".#?" combinations)
// 2. How many slots we have left (the remaining '?' in the input)
// 3. The current run of bad springs (consecutive '#' seen before this state)
// 4. The list of matches yet to solve.
// 5. The number of bad springs to pick out of the remaining slots (choices)
//
// setup:
// data to process is given
// slots is the count of '?' in the input.
// matches is given, but we append one 0 to avoid having to check for out-of-bounds.
// run of bad springs starts at 0.
// choices starts out as the sum of the matches subtracting the '#' in the input.
//
// algorithm:
// if the next char is '.', then check next match against current run (if run is not 0), recurse with run = 0, next data, next matches.
// if the next char is '#', add one to run, recurse on next data.
// if the next char is '?':
//    a. replace with '.', recurse with slots - 1, everything else remains the same
//    b. replace with '#', recurse with slots - 1, choices - 1, everything else remains the same.
// 
// We use the following euristics to prune:
// 1. choices cannot exceed slots.
// 2. choices cannot go below 0.
// 3. The new char is '#' and the run exceeds the next match.
// 
// memoization:
// In some cases, there are repeated ways to get to later states. So we memoize
// to avoid recalculation. This is only needed for part2, but I wanted to use
// the same algorithm for both parts.
// Memoization state is:
// - number of characters left
// - the first character (since we sometimes change it)
// - current run of bad springs
// - choices left (slots are dictated by the first two, so we don't need those)
// - matches left

long pick(char[] data, int run, int choices, int slots, int[] matches, Memo memo)
{
    auto st = State(data.length == 0 ? '\0' : data[0], data.length, run, choices, matches.length);

    long doit()
    {
        if(data.length == 0)
        {
            assert(slots == 0 && choices == 0); // sanity check
            return matches[0] == run; // last run must be the last match
        }
        if(data[0] == '?')
        {
            long result = 0;
            if(choices != slots) // can't pick a '.' if the choices matches the slots remaining.
            {
                // try picking a '.'
                data[0] = '.';
                result += pick(data, run, choices, slots - 1, matches, memo);
                data[0] = '?';
            }
            if(choices != 0) // can't pick a '#' if there are no more choices to pick.
            {
                data[0] = '#';
                result += pick(data, run, choices - 1, slots - 1, matches, memo);
                data[0] = '?';
            }
            return result;
        }

        if(data[0] == '.')
        {
            if(run != 0)
            {
                if(matches[0] == run)
                    return pick(data[1 .. $], 0, choices, slots, matches[1 .. $], memo);
                else
                    // impossible
                    return 0;
            }
            else
            {
                return pick(data[1 .. $], 0, choices, slots, matches, memo);
            }
        }
        if(data[0] == '#')
        {
            run += 1;
            if(matches[0] < run)
                // impossible
                return 0;
            else
                return pick(data[1 .. $], run, choices, slots, matches, memo);
        }
        assert(0); // something other than '.' or '#' or '?'
    }

    if(auto r = st in memo)
        return *r;
    return memo[st] = doit();
}

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    long part1 = 0;
    long part2 = 0;
    foreach(i; input)
    {
        auto data = i.split;
        int slots = cast(int)data[0].count('?'); // how many places we need to pick
        int[] matches = data[1].split(',').map!(to!int).array;
        int choices = sum(matches) - cast(int)data[0].count('#'); // how many more # we need
        matches ~= 0; // sentinel
        long v = pick(data[0].dup, 0, choices, slots, matches, new Memo);
        //writeln("part1: ", v);
        part1 += v;

        // part 2
        matches.length -= 1;
        auto p2matches = matches;
        auto p2data = data[0].dup;
        foreach(j; 0 .. 4)
        {
            p2data ~= '?';
            p2data ~= data[0];
            p2matches ~= matches;
        }
        p2matches ~= 0; // sentinel
        v = pick(p2data, 0, choices * 5, slots * 5 + 4, p2matches, new Memo);
        //writeln("part2: ", v);
        part2 += v;
    }
    writeln(part1);
    writeln(part2);
}
