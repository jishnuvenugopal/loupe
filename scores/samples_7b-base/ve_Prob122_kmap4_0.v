
module TopModule(ina, inb, inc, ind, out);
  input ina, inb, inc, ind;
  output out;

  assign out = (ina & ~inc & ~ind) | (ina & inb & inc & ind) | (~ina & ~inb & inc & ~ind) | (ina & ~inb & ~inc & ~ind);

endmodule
