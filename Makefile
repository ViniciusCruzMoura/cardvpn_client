
PROGRAM_VERSION := $(shell echo $$(date +%y.%m).$$(git rev-list --count --since="$$(date +'%Y-%m-01')" HEAD))
VPN_SP3_PROXY  ?= $(SP3_PROXY)
VPN_CG_PROXY  ?= $(CG_PROXY)

CC = gcc
CFLAGS += -Wall -Wextra --pedantic -s -O2 -Wno-missing-braces -Werror=implicit-function-declaration -D_GNU_SOURCE
LIBS += $(shell pkg-config openconnect --libs)
DEFINES += -DPROGRAM_VERSION='"$(PROGRAM_VERSION)"' \
		   -DVPN_SP3_PROXY='"$(VPN_SP3_PROXY)"' \
		   -DVPN_CG_PROXY='"$(VPN_CG_PROXY)"'

all: cardvpn_client

main.o: main.c
	$(CC) $(CFLAGS) $(DEFINES) -c main.c 

cardvpn_client: main.o
	$(CC) main.o -o cardvpn_client

.PHONY: version clean

version:
	@echo "Correções incluídas:"
	@echo "    VERSION := " $(PROGRAM_VERSION)
	@echo "Recursos incluídos (+) ou não (-):"
	@echo "    VPN_SP3_PROXY := " $(VPN_SP3_PROXY)
	@echo "    VPN_CG_PROXY := " $(VPN_CG_PROXY)
	@echo "Compilação e Vinculação:"
	@echo "    CFLAGS := " $(CFLAGS)
	@echo "    LIBS := " $(LIBS)
	@echo "    DIFINES := " $(DEFINES)

clean:
	@rm -f *.o
