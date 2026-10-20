
module TopModule(ring, vibrate_mode, ringer, motor);
  input ring;
  input vibrate_mode;
  output reg ringer;
  output reg motor;

  assign ringer = ring && !vibrate_mode;
  assign motor = ring && vibrate_mode;
endmodule
