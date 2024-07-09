
Location: Location.m Location.info.plist Location.entitlements.plist Makefile
	cc $< \
	  -framework CoreLocation  \
	  -framework AppKit  \
	  -sectcreate __TEXT __info_plist Location.info.plist \
	  -sectcreate __TEXT __entitlements Location.entitlements.plist \
	  -o $@

codesign.stamp: Location Location.entitlements.plist
	codesign \
	  -s ${CODESIGN_IDENTITY} \
	  --entitlements Location.entitlements.plist \
	  --deep $< \
	  --verbose --force \
	  --options runtime
	codesign -d --entitlements /dev/stdout $< 
	touch $@

Location.zip: Location codesign.stamp
	zip $@ $^

notarize.stamp: Location.zip
	xcrun notarytool submit $^ \
	  --wait \
	  --apple-id ${APPLE_ID} \
	  --team-id  ${CODESIGN_IDENTITY} \
	  --password ${CODESIGN_PASSWORD}
	touch $@

run: notarize.stamp
	./Location

clean:
	rm Location notarize.stamp codesign.stamp

.PHONY: run clean
