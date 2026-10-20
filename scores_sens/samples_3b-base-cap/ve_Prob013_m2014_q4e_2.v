
module TopModule (
    input  in1,
    input  in2,
    output out
);

    
    wire not_in1;
    not not_in1_gen (
        .a(in1),
        .y(not_in1)
    );

    
    wire not_in2;
    not not_in2_gen (
        .a(in2),
        .y(not_in2)
    );

    
    wire and_result;
    and and_gen (
        .a(not_in1),
        .b(not_in2),
        .y(and_result)
    );

    
    not nor_out_gen (
        .a(and_result),
        .y(out)
    );

endmodule
