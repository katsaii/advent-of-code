langs = []
[2019, 2020, 2021].each do |year|
    page = File.read("#{year}.md")
    page.scan(/\s*\|[^|]*Day[^|]*\|\s*([^|-]*?)\s*\|[^|]*\|/) do |x|
        langs << x[0]
    end
end
langs_tally = langs.tally.sort_by{|_, n| n}.reverse.map{|lang, n| [lang, "#{n} `#{"#" * n}`"]}
max_lang_length = langs_tally.map{|lang, _| lang.length}.max
max_tally_length = langs_tally.map{|_, n| n.length}.max
out = <<~HEADER
    # Language Summary

    A table of programming languages used during the events, and how many solutions they were used for.
HEADER
lang_title = "Language"
tally_title = "Count"
lang_length = [max_lang_length, lang_title.length].max
tally_length = [max_tally_length, tally_title.length].max
out << "\n| #{lang_title}#{" " * (lang_length - lang_title.length)} "
out << "| #{tally_title}#{" " * (tally_length - tally_title.length)} |"
out << "\n| #{"-" * lang_length} | #{"-" * tally_length} |"
langs_tally.each do |lang, n|
    out << "\n| #{lang}#{" " * (lang_length - lang.length)} "
    out << "| #{n}#{" " * (tally_length - n.length)} |"
end
out << "\n"
File.write("languages.md", out)
