langs = []
solutions = { }
[2019, 2020, 2021, 2022].each do |year|
    page = File.read("#{year}.md")
    page.scan(/\s*\|[^|]*\[.+\]\((.*?)\)[^|]*\|\s*([^|-]*?)\s*\|[^|]*\|/) do |x|
        solution = x[0]
        lang = x[1]
        langs << x[1]
        solutions[lang] = [] if !solutions.has_key?(lang)
        solutions[lang] << solution
    end
end
langs_tally = langs.tally.sort_by{|_, n| n}.reverse
out = "# Language Summary\n\nA table of programming languages used during the events, and how many solutions they were used for."
out << "\n\n| Language | Count | Tally |\n| --- | --- | --- |"
langs_tally.each do |lang, n|
    urls = ""
    solutions[lang].each do |solution|
        urls << "<a href=\"#{solution}\">#</a>"
    end
    out << "\n| #{lang} | #{n} | <code>#{urls}</code> |"
end
out << "\n"
File.write("languages.md", out)
puts "DONE"
