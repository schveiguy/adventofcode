import std.stdio;
import std.algorithm;
import std.file : readText;
import std.range;
import std.conv;
import std.array;

int main(string[] args)
{
	string input = readText(args[1]);
	auto rng = input.split;
	int gamma = 0;
	int epsilon = 0;

	foreach(i; 0 .. rng.front.length)
	{
		int z = 0;
		int o = 0;
		foreach(v; rng)
			++(v[i] == '0' ? z : o);
		gamma = (gamma << 1) | (o > z);
		epsilon = (epsilon << 1) | (o < z);
	}
	writeln("gamma: ", gamma, " epsilon: ", epsilon, " result: ", gamma * epsilon);

	// now, do the oxygen and co2
	auto ox = rng;
	auto co2 = ox.dup;
	foreach(i; 0 .. ox.front.length)
	{
		int z = 0;
		int o = 0;
		foreach(v; ox)
			++(v[i] == '0' ? z : o);
		ox = ox.filter!(v => v[i] == (z > o ? '0' : '1')).array;
	}

	foreach(i; 0 .. co2.front.length)
	{
		int z = 0;
		int o = 0;
		foreach(v; co2)
			++(v[i] == '0' ? z : o);
		char keep = '0';
		if(z == 0 || (o > 0 && o < z))
			keep = '1';
		co2 = co2.filter!(v => v[i] == keep).array;
	}

	int oxv = ox[0].to!int(2);
	int co2v = co2[0].to!int(2);
	writeln("oxygen: ", oxv, " co2: ", co2v, " result: ", oxv * co2v);
	return 0;
}
