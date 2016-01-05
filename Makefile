all : image.elf
FW_FILE_1:=image.elf-0x00000.bin
FW_FILE_2:=image.elf-0x40000.bin

TARGET_OUT:=image.elf
SRCS:=	src/user_main.c

#	src/server.c

OBJS=$(subst .c,.o,$(SRCS))

GCC_FOLDER:=`pwd`/../esp-open-sdk/xtensa-lx106-elf
ESPTOOL_PY:=`pwd`/../esptool/esptool.py
FW_TOOL:=`pwd`/../esptool/esptool.py
SDK:=`pwd`/../esp_iot_sdk_v1.4.0
#PORT:=/dev/ttyUSB0
PORT:=/dev/ttyUSB0
PATH:=$(PATH):$(GCC_FOLDER)/bin

XTLIB:=$(SDK)/lib
XTGCCLIB:=$(GCC_FOLDER)/lib/gcc/xtensa-lx106-elf/4.8.2/libgcc.a
FOLDERPREFIX:=$(GCC_FOLDER)/bin
PREFIX:=$(FOLDERPREFIX)/xtensa-lx106-elf-
CC:=$(PREFIX)gcc

CFLAGS:=-Wall -mlongcalls -I$(SDK)/include -Imyclib -Iinclude -Iuser -Os -I$(SDK)/include/

#	   \
#

LDFLAGS_CORE:=\
	-nostdlib \
	-Wl,--relax -Wl,--gc-sections \
	-L$(XTLIB) \
	-L$(XTGCCLIB) \
	$(SDK)/lib/liblwip.a \
	$(SDK)/lib/libssl.a \
	$(SDK)/lib/libupgrade.a \
	$(SDK)/lib/libnet80211.a \
	$(SDK)/lib/liblwip.a \
	$(SDK)/lib/libwpa.a \
	$(SDK)/lib/libnet80211.a \
	$(SDK)/lib/libphy.a \
	$(SDK)/lib/libmain.a \
	$(SDK)/lib/libpp.a \
	$(XTGCCLIB) \
	-T $(SDK)/ld/eagle.app.v6.ld \
	-T $(SDK)/ld/eagle.rom.addr.v6.ld

LINKFLAGS:= \
	$(LDFLAGS_CORE) \
	-B$(XTLIB)

#image.elf : $(OBJS)
#	$(PREFIX)ld $^ $(LDFLAGS) -o $@

$(TARGET_OUT) : $(SRCS)
	$(PREFIX)gcc $(CFLAGS) $^  -flto $(LINKFLAGS) -o $@



$(FW_FILE_1): $(TARGET_OUT)
	@echo "FW $@"
	PATH=$(PATH) `pwd`/../esptool/esptool.py elf2image image.elf

#%$(FW_TOOL) -eo $(TARGET_OUT) -bo $@ -bs .text -bs .data -bs .rodata -bc -ec

$(FW_FILE_2): $(TARGET_OUT)
	@echo "FW $@"

#$(FW_TOOL) -eo $(TARGET_OUT) -es .irom0.text $@ -ec

fw : $(FW_FILE_1) $(FW_FILE_2)
	@echo "built firmware..."

burn : $(FW_FILE_1) $(FW_FILE_2)
	($(ESPTOOL_PY) --port $(PORT) write_flash 0x00000 $(FW_FILE_1) 0x40000 $(FW_FILE_2))||(true)


clean :
	rm -rf user/*.o driver/*.o $(TARGET_OUT) $(FW_FILE_1) $(FW_FILE_2)


