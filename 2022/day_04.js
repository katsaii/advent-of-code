const fs = require("fs");
fs.readFile("in/day_04.txt", (_, data) => {
	const lines = data
		.toString()
		.split(/\s+/)
		.filter(x => x)
		.map(line => line
			.split(/[-,]/)
			.map(n => parseInt(n)));
	const totalSubsets = lines.reduce((acc, [a1, a2, b1, b2]) => {
		const [min1, min2, max1, max2] =
			a2 - a1 < b2 - b1 ? [a1, a2, b1, b2] : [b1, b2, a1, a2];
		return acc + (min1 >= max1 && min2 <= max2);
	}, 0);
	const totalOverlaps = lines.reduce((acc, [a1, a2, b1, b2]) => {
		return acc + (a1 <= b2 && a2 >= b1);
	}, 0);
	console.log(totalSubsets);
	console.log(totalOverlaps)
})
