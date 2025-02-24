#git show --no-patch --format=%cd --date=short --date=format:%y.%m $(git rev-parse HEAD)
#echo $(git show --no-patch --format=%cd --date=short --date=format:%y.%m $(git rev-parse HEAD)).$(git rev-list --count --after="$(git show --no-patch --format=%cd --date=short --date=format:%Y-%m-01 $(git rev-parse HEAD))" --before="$(git show --no-patch --format=%cd --date=short --date=format:%Y-%m-30 $(git rev-parse HEAD))" HEAD)
#PROGRAM_VERSION := $(shell echo $$(date +%y.%m).$$(git rev-list --count --since="$$(date +'%Y-%m-01')" HEAD))
#PROGRAM_VERSION := $(shell echo $$(git show --no-patch --format=%cd --date=short --date=format:%y.%m $$(git rev-parse HEAD)).$$(git rev-list --count --after="$$(git show --no-patch --format=%cd --date=short --date=format:%Y-%m-01 $$(git rev-parse HEAD))" --before="$$(git show --no-patch --format=%cd --date=short --date=format:%Y-%m-30 $$(git rev-parse HEAD))" HEAD) )

YEAR_MONTH = $(shell echo $$(git show --no-patch --format=%cd --date=short --date=format:%y.%m $$(git rev-parse HEAD)) )
DATE_COMMITS_BEFORE = $(shell echo $$(git show --no-patch --format=%cd --date=short --date=format:%Y-%m-30 $$(git rev-parse HEAD)) )
DATE_COMMITS_AFTER = $(shell echo $$(git show --no-patch --format=%cd --date=short --date=format:%Y-%m-01 $$(git rev-parse HEAD)) )
COMMITS = $(shell echo $$(git rev-list --count --after="$(DATE_COMMITS_AFTER)" --before="$(DATE_COMMITS_BEFORE)" HEAD) )

# Define current git clone version
PROGRAM_VERSION := $(YEAR_MONTH).$(COMMITS)

# Define required environment variables
VPN_SP3_PROXY  ?= $(SP3_PROXY)
VPN_CG_PROXY  ?= $(CG_PROXY)

# Define default C compiler and compiler flags
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
