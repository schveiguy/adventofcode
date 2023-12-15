import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;


void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    string[] cities;
    size_t getCityIdx(string city)
    {
        auto result = cities.countUntil(city);
        if(result == -1)
        {
            cities ~= city;
            return cities.length - 1;
        }
        return result;
    }

    int[size_t][size_t] graph;
    foreach(i; input)
    {
        string src, dest;
        int dist;
        i.formattedRead("%s to %s = %s", src, dest, dist);
        graph[getCityIdx(src)][getCityIdx(dest)] = dist;
        graph[getCityIdx(dest)][getCityIdx(src)] = dist;
    }
    foreach(i; 0 .. cities.length)
        graph[i][cities.length] = 0;
    static struct State
    {
        size_t city;
        size_t mask;
    }
    size_t[State] memo;
    foreach(i; 0 .. cities.length)
        memo[State(i, (1L << i))] = 0;
    size_t shortest(State s)
    {
        // we are at this city.
        if(auto r = s in memo)
            return *r;
        size_t answer = size_t.max;
        auto prevmask = s.mask & ~(1 << s.city);
        foreach(i; 0 .. cities.length)
        {
            if(prevmask & (1UL << i))
            {
                // see what it would be if we visited this city last time
                answer = min(answer, shortest(State(i, prevmask)) + graph[i][s.city]);
            }
        }
        return memo[s] = answer;
    }

    writeln(shortest(State(cities.length, (1UL << (cities.length + 1)) - 1)));

    size_t[State] memo2;
    foreach(i; 0 .. cities.length)
        memo2[State(i, (1L << i))] = 0;
    size_t longest(State s)
    {
        // we are at this city.
        if(auto r = s in memo2)
            return *r;
        size_t answer = 0;
        auto prevmask = s.mask & ~(1 << s.city);
        foreach(i; 0 .. cities.length)
        {
            if(prevmask & (1UL << i))
            {
                // see what it would be if we visited this city last time
                answer = max(answer, longest(State(i, prevmask)) + graph[i][s.city]);
            }
        }
        return memo[s] = answer;
    }
    writeln(longest(State(cities.length, (1UL << (cities.length + 1)) - 1)));
}
