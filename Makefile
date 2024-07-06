
Location: Location.m Location.info.plist
	cc $< \
		-framework CoreLocation  \
		-framework AppKit  \
		-sectcreate __TEXT __info_plist Location.info.plist \
		-o $@
	if [ "$$CODESIGN_IDENTITY" ]; then \
		codesign \
			-s "${CODESIGN_IDENTITY}" \
			--verbose --force \
			--options runtime $@ ; fi

run: Location 
	./Location

clean:
	rm Location

.PHONY: run clean
