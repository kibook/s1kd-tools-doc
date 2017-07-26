# Parameters for the S1000D XSL stylesheet
PARAMS+=-param double.sided 0
PARAMS+=-stringparam end.of.data.module.position footer
PARAMS+=-param fop1.extensions 1

all: S1000D_tools.pdf

S1000D_tools.pdf: S1000D_tools.xml
	s1kd2pdf S1000D_tools.xml $(PARAMS)

S1000D_tools.xml: PMC-*.XML DMC-*.XML
	s1kd-makepub PMC-*.XML DMC-*.XML > S1000D_tools.xml

clean:
	rm -f S1000D_tools.pdf S1000D_tools.xml
