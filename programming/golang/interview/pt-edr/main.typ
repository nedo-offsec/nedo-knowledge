// main.typ — точка входа, собирает все разделы в один документ

#import "template.typ": *

#include "sections/01-basics.typ"

#pagebreak()
#line(length:100%)
#include "sections/02-runtime.typ"

#pagebreak()
#line(length:100%)
#include "sections/03-concurrency.typ"

#pagebreak()
#line(length:100%)
#include "sections/04-context-patterns.typ"

#pagebreak()
#line(length:100%)
#include "sections/05-tools.typ"

#pagebreak()
#line(length:100%)
#include "sections/06-recommendations.typ"

#pagebreak()
#line(length:100%)
#include "sections/07-questions.typ"
