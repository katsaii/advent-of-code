langs = []
[2019, 2020, 2021].each do |year|
    page = File.read("#{year}.md")
    page.scan(/\s*\|[^|]*Day[^|]*\|\s*([^|-]*?)\s*\|[^|]*\|/) do |x|
        langs << x[0]
    end
end
langs_tally = langs.tally.sort_by{|_, n| n}.reverse
out = <<~HEADER
    # Programming Language Popularity

    A table of programming languages used during the events, and how many solutions they were used for.

    | Language | Solution Count |
    | --- | --- |
HEADER
langs_tally.each do |lang, n|
    out += "| #{lang} | #{n} |\n"
end
File.write("languages.md", out)
