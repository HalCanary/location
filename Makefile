
Location: Location.m Location.info.plist
	cc $< \
	  -framework CoreLocation  \
	  -framework AppKit  \
	  -sectcreate __TEXT __info_plist Location.info.plist \
	  -o $@

codesign.stamp: Location
	codesign \
	  -s ${CODESIGN_IDENTITY} \
	  --verbose --force \
	  --options runtime $<
	codesign -d --entitlements /dev/stdout $< 
	touch $@

run: Location 
	./Location

Location.zip: Location codesign.stamp
	zip $@ $^

notarize.stamp: Location.zip
	xcrun notarytool submit $^ \
	  --wait \
	  --apple-id ${APPLE_ID} \
	  --team-id  ${CODESIGN_IDENTITY} \
	  --password ${CODESIGN_PASSWORD}
	touch $@

clean:
	rm Location

.PHONY: run clean
