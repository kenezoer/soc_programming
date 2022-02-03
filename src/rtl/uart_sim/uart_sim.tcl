set severity_pack_assert_off {warning}
set pack_assert_off { std_logic_arith numeric_std }
run 1
set uart_term_cmd [list xterm -geometry 70x20+0+0 -bg black -fg green -T {UART_0 output} -e tail -f uart_0.log.tmp &]
eval exec $uart_term_cmd
