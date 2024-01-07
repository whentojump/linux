#ifndef SCC_H
#define SCC_H SCC_H

extern char __start___llvm_prf_names;
extern char __stop___llvm_prf_names;
extern char __start___llvm_prf_cnts;
extern char __stop___llvm_prf_cnts;
extern char __start___llvm_prf_data;
extern char __stop___llvm_prf_data;
extern char __start___llvm_prf_vnds;
extern char __stop___llvm_prf_vnds;

// compiler-rt/lib/profile/InstrProfiling.h

enum ValueKind {
	IPVK_IndirectCallTarget = 0,
	IPVK_MemOPSize = 1,
	IPVK_First = IPVK_IndirectCallTarget,
	IPVK_Last = IPVK_MemOPSize,
};

typedef void *IntPtrT;

typedef struct __llvm_profile_data {
	const uint64_t NameRef;
	const uint64_t FuncHash;
	const IntPtrT CounterPtr;
	const IntPtrT BitmapPtr;
	const IntPtrT FunctionPointer;
	IntPtrT Values;
	const uint32_t NumCounters;
	const uint16_t NumValueSites[IPVK_Last+1];
	const uint32_t NumBitmapBytes;
} __llvm_profile_data;

// compiler-rt/lib/profile/InstrProfilingInternal.c

unsigned lprofProfileDumped(void);
void lprofSetProfileDumped(unsigned);

// compiler-rt/lib/profile/InstrProfiling.c

void __llvm_profile_reset_counters(void);

#endif /* SCC_H */
