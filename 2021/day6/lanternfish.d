import std.stdio;
import std.algorithm;
import std.conv;
int main(string[] args)
{
	if(args.length < 3)
	{
		stderr.writefln("usage: %s numdays initialfish", args[0]);
		return 1;
	}
	long[int] fish;
	foreach(t; args[2].splitter(',').map!(s => s.to!int))
		++fish[t];
	foreach(i; 0 .. args[1].to!int)
	{
		long[int] newfish;
		foreach(k, v; fish)
			if(k == 0)
			{
				newfish.require(6) += v;
				newfish.require(8) += v;
			}
			else
			{
				newfish.require(k - 1) += v;
			}
		debug writeln("Day ", i, "\t", newfish);
		fish.clear();
		fish = newfish;
	}
	writeln("total fish: ", fish.byValue.sum);
	return 0;
}
