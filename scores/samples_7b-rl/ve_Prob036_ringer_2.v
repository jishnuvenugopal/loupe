
module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    assign motor = vibrate_mode;
    assign ringer = (~vibrate_mode) & ring;

endmodule
