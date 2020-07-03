# Parameters for the S1000D XSL stylesheet
PARAMS+=-param double.sided 0
PARAMS+=-param hierarchical.table.of.contents 1
PARAMS+=-param include.pmentry.bookmarks 1
PARAMS+=-param ulink.show 0
PARAMS+=-stringparam external.pub.ref.inline 'code'
PARAMS+=-param show.unclassified 0
PARAMS+=-stringparam auto.expand.acronyms 'no'
PARAMS+=-param title.page.issue.date 1
PARAMS+=-param title.page.publisher 0
PARAMS+=-stringparam font.family 'Helvetica,Arial'
PARAMS+=-param generate.title.page 1
PARAMS+=-param generate.highlights 1
PARAMS+=-param generate.list.of.datamodules 1
PARAMS+=-param generate.table.of.contents 1

all: s1kd-tools.pdf

s1kd-tools.pdf: s1kd-tools.xml
	s1kd2pdf $^ $(PARAMS)

s1kd-tools.xml: custom
	s1kd-ls -DP $< | xargs s1kd-flatten -px | xml-format -o $@

custom: csdb/PMC-*.XML csdb/DMC-*.XML
	sh build.sh $@ csdb $< pdf 3.2.0

csdb/DMC-S1KDTOOLS-A-00-00-00-00A-005A-D_EN-CA.XML: csdb/DMC-*.XML
	s1kd-acronyms -xpd $^ | xml-merge $@ - | xml-format -o $@

README.md: csdb/DMC-S1KDTOOLS-A-00-00-00-00A-040B-D_EN-CA.XML
	s1kd2db $^ | pandoc -f docbook -t markdown_github -o $@

HIGHLIGHTS.md: csdb/PMC-*.XML csdb/DMC-*.XML high-github.xsl
	s1kd-flatten -d csdb csdb/PMC-*.XML | s1kd-fmgen -t HIGH -x high-github.xsl | s1kd2db - | pandoc -f docbook -t markdown_github -o $@

clean:
	rm -rf s1kd-tools.pdf s1kd-tools.xml custom
