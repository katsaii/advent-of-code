const fs = require("fs");
fs.readFile("in/day_13.txt", (_, data) => {
	const packets = data.toString().split("\n\n")
		.map(packet => packet.split("\n").map(line => eval(line)));
	const compare = function(lhs, rhs) {
		switch (typeof lhs + typeof rhs) {
		case "numbernumber":
			return Math.sign(lhs - rhs);
		case "objectobject":
			for (let i = 0; i < Math.min(lhs.length, rhs.length); i += 1) {
				const cmp = arguments.callee(lhs[i], rhs[i]);
				if (cmp != 0) {
					return cmp;
				}
			}
			return arguments.callee(lhs.length, rhs.length);
		case "objectnumber": return arguments.callee(lhs, [rhs]);
		case "numberobject": return arguments.callee([lhs], rhs);
		}
	};
	const sum = Array.from(packets.entries()).reduce(
		(acc, [i, [lhs, rhs]]) => acc + (compare(lhs, rhs) < 1 ? i + 1 : 0), 0);
	console.log(sum);
});
