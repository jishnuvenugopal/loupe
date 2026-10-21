
module TopModuleExample (
    input wire [31:0] input_data,
    output wire [31:0] reversed_data
);

    TopModule top_module (
        .in(input_data),
        .out(reversed_data)
    );

endmodule
