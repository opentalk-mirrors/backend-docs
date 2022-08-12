# Enable all rules by default
all

# Markdown tables cant have breaks in them thus this is set to the largest table.
rule 'MD013', :line_length => 790

exclude_rule 'MD024'

rule 'MD009', :br_spaces => 2
