CUR_DIR = $(shell pwd)
LLVM_BUILD := ${CUR_DIR}/llvm-project/prefix
ANALYZER_DIR := ${CUR_DIR}/src
ANALYZER_BUILD := ${CUR_DIR}/build


UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
	NPROC := ${shell nproc}
else
	NPROC := ${shell sysctl -n hw.ncpu}
endif

build_analyzer_func = \
	(mkdir -p ${2} \
		&& cd ${2} \
		&& LLVM_DIR=${LLVM_BUILD} CC=gcc CXX=g++ \
			cmake ${1}	\
				-DCMAKE_BUILD_TYPE=Build \
				-DLLVM_ENABLE_ASSERTIONS=ON \
				-DCMAKE_CXX_FLAGS="-std=c++14 -fPIC -fno-rtti -g" \
		&& make -j${NPROC})


all: kanalyzer

kanalyzer:
	$(call build_analyzer_func, ${ANALYZER_DIR}, ${ANALYZER_BUILD})

clean:
	rm -rf ${ANALYZER_BUILD}
