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

// compiler-rt/lib/profile/InstrProfilingInternal.c

unsigned lprofProfileDumped(void);
void lprofSetProfileDumped(unsigned);

// compiler-rt/lib/profile/InstrProfiling.c

void __llvm_profile_reset_counters(void);

#endif /* SCC_H */
