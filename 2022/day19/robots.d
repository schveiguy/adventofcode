import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;
import std.range;
import std.array;
import std.math;

void main(string[] args)
{
    auto input = readText(args[1]).strip.split('\n');

    static struct state {
        long ore;
        long clay;
        long obs;
        long r_ore;
        long r_clay;
        long r_obs;
    }

    long run(string ln, int minutes, out long id)
    {
        int r_ore_cost;
        int r_clay_cost;
        int r_obs_ore_cost;
        int r_obs_clay_cost;
        int r_geode_ore_cost;
        int r_geode_obs_cost;
        ln.formattedRead("Blueprint %d: Each ore robot costs %d ore. Each clay robot costs %d ore. Each obsidian robot costs %d ore and %d clay. Each geode robot costs %d ore and %d obsidian.", &id, &r_ore_cost, &r_clay_cost, &r_obs_ore_cost, &r_obs_clay_cost, &r_geode_ore_cost, &r_geode_obs_cost);

        auto r_ore_max = max(r_ore_cost, r_clay_cost, r_obs_ore_cost, r_geode_ore_cost);

        long[state] cur;
        cur[state(0, 0, 0, 1, 0, 0)] = 0;
        foreach(i; 0 .. minutes)
        {
            writeln("minute ", i, " number of states is ", cur.length);
            long[state] next;
            void update(state s, long geode)
            {
                next[s] = max(next.get(s, 0), geode);
            }
            foreach(k, v; cur)
            {
                // determine which robots can be built
                bool bOre = k.r_ore < r_ore_max && r_ore_cost <= k.ore;
                bool bObs = k.r_obs < r_geode_obs_cost && r_obs_ore_cost <= k.ore && r_obs_clay_cost <= k.clay;
                bool bClay = k.r_obs < r_geode_obs_cost && k.r_clay < r_obs_clay_cost && r_clay_cost <= k.ore;
                bool bGeode = r_geode_ore_cost <= k.ore && r_geode_obs_cost <= k.obs;

                // mine materials
                k.ore += k.r_ore;
                k.clay += k.r_clay;
                k.obs += k.r_obs;

                if(bGeode)
                {
                    // always build a geode, and don't build anything else. The whole goal is to build geode robots.
                    auto nk = k;
                    nk.ore -= r_geode_ore_cost;
                    nk.obs -= r_geode_obs_cost;
                    update(nk, v + (minutes-i));
                }
                else
                {
                    // try not building any robots, but only if we need more resources for other robots to be built.
                    update(k, v);
                    // try building one of each robot
                    if(bOre)
                    {
                        // ore
                        auto nk = k;
                        nk.ore -= r_ore_cost;
                        ++nk.r_ore;
                        update(nk, v);
                    }

                    if(bClay)
                    {
                        // clay
                        auto nk = k;
                        nk.ore -= r_clay_cost;
                        ++nk.r_clay;
                        update(nk, v);
                    }

                    if(bObs)
                    {
                        // obsidian
                        auto nk = k;
                        nk.ore -= r_obs_ore_cost;
                        nk.clay -= r_obs_clay_cost;
                        ++nk.r_obs;
                        update(nk, v);
                    }
                }
            }

            cur = next;
        }

        return cur.byValue.maxElement;
    }

    long pt1;
    long pt2 = 1;
    foreach(ln; input)
    {
        long id;
        auto maxval = run(ln, 23, id);
        writeln("blueprint ", id, " has max geode ", maxval);
        pt1 += id * maxval;

        if(id < 4)
        {
            maxval = run(ln, 31, id);
            pt2 *= maxval;
        }
    }
    writeln("part1: ", pt1);
    writeln("part2: ", pt2);
}
