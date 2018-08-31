# Parameters for the S1000D XSL stylesheet
PARAMS+=-param double.sided "0"
PARAMS+=-param hierarchical.table.of.contents "1"
PARAMS+=-param include.pmentry.bookmarks "1"
PARAMS+=-param ulink.show "0"
PARAMS+=-param external.pub.ref.inline "'code'"
PARAMS+=-param show.unclassified "0"
PARAMS+=-param auto.expand.acronyms "'no'"
PARAMS+=-param title.page.issue.date "1"

all: S1000D_tools.pdf

S1000D_tools.pdf: S1000D_tools.xml
	s1kd2pdf $^ $(PARAMS)

S1000D_tools.xml: csdb/PMC-*.XML csdb/DMC-*.XML
	s1kd-flatten -p $^ > $@

csdb/DMC-S1000DTOOLS-A-00-00-00-00A-005A-D_EN-CA.XML: csdb/DMC-*.XML
	s1kd-acronyms -xpd $^ | xml-merge $@ - | xmllint --format --output $@ -

README.md: csdb/DMC-S1000DTOOLS-A-00-00-00-00A-040A-D_EN-CA.XML
	s1kd2db $^ | pandoc -f docbook -t markdown_github -o $@

clean:
	rm -f S1000D_tools.pdf S1000D_tools.xml
