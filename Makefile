# Parameters for the S1000D XSL stylesheet
PARAMS+=-param double.sided 0
PARAMS+=-stringparam end.of.data.module.position footer
PARAMS+=-param fop1.extensions 1
PARAMS+=-param hierarchical.table.of.contents 1
PARAMS+=-param include.pmentry.bookmarks 1
PARAMS+=-param ulink.show 0
PARAMS+=-stringparam external.pub.ref.inline code
PARAMS+=-param show.unclassified 0

all: S1000D_tools.pdf

S1000D_tools.pdf: S1000D_tools.xml
	s1kd2pdf S1000D_tools.xml $(PARAMS)

S1000D_tools.xml: PMC-*.XML DMC-*.XML DMC-S1000DTOOLS-A-00-00-00-00A-005A-D_EN-CA.XML
	s1kd-makepub PMC-*.XML DMC-*.XML > S1000D_tools.xml

DMC-S1000DTOOLS-A-00-00-00-00A-005A-D_EN-CA.XML: acronymsTemplate.xml acronyms.xml
	xml-merge acronymsTemplate.xml acronyms.xml > DMC-S1000DTOOLS-A-00-00-00-00A-005A-D_EN-CA.XML

acronyms.xml: DMC-*.XML
	s1kd-acronyms -xpd DMC-*.XML > acronyms.xml

README.md: DMC-S1000DTOOLS-A-00-00-00-00A-040A-D_EN-CA.XML
	s1kd2db DMC-S1000DTOOLS-A-00-00-00-00A-040A-D_EN-CA.XML | pandoc -f docbook -t markdown_github > README.md

clean:
	rm -f S1000D_tools.pdf S1000D_tools.xml DMC-S1000DTOOLS-A-00-00-00-00A-005A-D_EN-CA.XML acronyms.xml
