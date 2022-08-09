ret = bpf_get_current_pid_tgid();
bpf_trace_printk(msg, sizeof(msg), ret);
