HAS_ELIXIR=1

include bu.mk

doc::
	$(verbose) ${CP} _doc/* doc

