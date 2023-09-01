RASPIOS_IMAGE_NAME=raspios_lite_arm64

.PHONY: all custom

all: clean
	$(MAKE) build raspios_image_name=$(RASPIOS_IMAGE_NAME)

Pi1 Pi2 PiZero PiCM1: clean
	$(MAKE) build platform32=1 raspios_image_name=raspios_lite_armhf

Pi3 Pi4 Pi400 PiZero2 PiCM3 PiCM4: clean
	$(MAKE) build raspios_image_name=$(RASPIOS_IMAGE_NAME)

build:
	mkdir -p build
	podman build --build-arg PLATFORM32=$(platform32) --build-arg RASPIOS_IMAGE_NAME=$(raspios_image_name) -t rpi-rt-linux .
	podman rm tmp-rpi-rt-linux || true
	podman run --privileged --name tmp-rpi-rt-linux rpi-rt-linux /raspios/build.sh
	podman cp tmp-rpi-rt-linux:/raspios/build/ ./
	podman rm tmp-rpi-rt-linux

custom:
	podman run --rm --privileged -it rpi-rt-linux bash

clean:
	rm -fr build
