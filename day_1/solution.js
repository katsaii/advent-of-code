const fs = require("fs");
fs.readFile("input", (err, data) => {
	if (err) {
		console.error(err);
		return;
	}
	const dates = data.toString()
			.split(/\s+/)
			.map(x => parseInt(x, 10))
			.filter(x => !isNaN(x));
	const n = dates.length;
	console.log("question 1 solutions");
	for (let i = 0; i < n; i += 1) {
		for (let j = i + 1; j < n; j += 1) {
			const a = dates[i];
			const b = dates[j];
			if (a + b == 2020) {
				console.log(a * b);
			}
		}
	}
	console.log("\nquestion 2 solutions");
	for (let i = 0; i < n; i += 1) {
		for (let j = i + 1; j < n; j += 1) {
			for (let k = j + 1; k < n; k += 1) {
				const a = dates[i];
				const b = dates[j];
				const c = dates[k];
				if (a + b + c == 2020) {
					console.log(a * b * c);
				}
			}
		}
	}
});
