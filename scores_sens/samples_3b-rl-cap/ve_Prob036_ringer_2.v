
module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

    
    assign motor = vibrate_mode;

    
    assign ringer = ~vibrate_mode & ring;

endmodule
